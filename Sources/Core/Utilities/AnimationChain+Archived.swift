//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/2/24.
//

import Foundation
import QuartzCore

open class ACBaseEffect: Chainable {
    public var delay: TimeInterval? = nil
    public var duration: TimeInterval = 0.25
    public var spring: ACSpringOption = .none()
    public var timingFunction: CAMediaTimingFunction? = nil
    public init(
        delay: TimeInterval? = nil, duration: TimeInterval = 0.25,
        spring: ACSpringOption = .none(), timingFunction: CAMediaTimingFunction? = nil
    ) {
        self.delay = delay
        self.duration = duration
        self.spring = spring
        self.timingFunction = timingFunction
    }
    
    public func animation(for view: BView) -> CABasicAnimation {
        let animation = CASpringAnimation()
        configure(animation, with: view)
        animation.initialVelocity = spring.initialVelocity
        animation.damping = spring.damping
        animation.beginTime = CACurrentMediaTime() + (delay ?? 0)
        animation.duration = duration
        if let timingFunction { animation.timingFunction = timingFunction }
        return animation
    }
    
    func configure(_ animation: CASpringAnimation, with view: BView) {
        fatalError("Configuration must be overidden")
    }
}

public class ACOpacity: ACBaseEffect {
    public var alpha: CGFloat
    public init(alpha: CGFloat, delay: TimeInterval? = nil, duration: TimeInterval = 0.25, spring: ACSpringOption = .none(), timingFunction: CAMediaTimingFunction? = nil) {
        self.alpha = alpha
        super.init(delay: delay, duration: duration, spring: spring, timingFunction: timingFunction)
    }
    
    override func configure(_ animation: CASpringAnimation, with view: BView) {
        animation.keyPath = "opacity"
        animation.fromValue = view.layer.presentation()?.value(forKey: "opacity")
        animation.toValue = alpha
    }
}

public class ACOffset: ACBaseEffect {
    var x: CGFloat
    var y: CGFloat
    public init(x: CGFloat, y: CGFloat, delay: TimeInterval? = nil, duration: TimeInterval = 0.25, spring: ACSpringOption = .none(), timingFunction: CAMediaTimingFunction? = nil) {
        self.x = x
        self.y = y
        super.init(delay: delay, duration: duration, spring: spring, timingFunction: timingFunction)
    }
    
    override func configure(_ animation: CASpringAnimation, with view: BView) {
        animation.keyPath = "position"
        guard let currentPosition = view.layer.presentation()?.value(forKey: "position") as? CGPoint else { return }
        animation.fromValue = view.layer.presentation()?.value(forKey: "position")
        animation.toValue = CGPoint(x: currentPosition.x + x, y: currentPosition.y + y)
    }
}

public class ACScale: ACBaseEffect {
    var multiplier: CGFloat
    public init(multiplier: CGFloat, delay: TimeInterval? = nil, duration: TimeInterval = 0.25, spring: ACSpringOption = .none(), timingFunction: CAMediaTimingFunction? = nil) {
        self.multiplier = multiplier
        super.init(delay: delay, duration: duration, spring: spring, timingFunction: timingFunction)
    }
    
    override func configure(_ animation: CASpringAnimation, with view: BView) {
        animation.keyPath = "transform.scale"
        animation.fromValue = view.layer.presentation()?.value(forKey: "transform.scale")
        animation.toValue = multiplier
    }
}

public class ACRotate: ACBaseEffect {
    var radians: CGFloat
    public init(radians: CGFloat, delay: TimeInterval? = nil, duration: TimeInterval = 0.25, spring: ACSpringOption = .none(), timingFunction: CAMediaTimingFunction? = nil) {
        self.radians = radians
        super.init(delay: delay, duration: duration, spring: spring, timingFunction: timingFunction)
    }
    
    override func configure(_ animation: CASpringAnimation, with view: BView) {
        animation.keyPath = "transform.rotation.z"
        animation.fromValue = view.layer.presentation()?.value(forKey: "transform.rotation.z")
        animation.toValue = radians
    }
}

public class ACCustom: ACBaseEffect {
    var configuration: (CABasicAnimation) -> Void
    public init(configuration: @escaping (CABasicAnimation) -> Void, delay: TimeInterval? = nil, duration: TimeInterval = 0.25, spring: ACSpringOption = .none(), timingFunction: CAMediaTimingFunction? = nil) {
        self.configuration = configuration
        super.init(delay: delay, duration: duration, spring: spring, timingFunction: timingFunction)
    }
    
    override func configure(_ animation: CASpringAnimation, with view: BView) {
        configuration(animation)
    }
}

public enum ACSpringOption {
    public static var defaultInitialVelocity: CGFloat = 30
    
    case none(initialVelocity: CGFloat? = nil, damping: CGFloat = .greatestFiniteMagnitude)
    case light(initialVelocity: CGFloat? = nil, damping: CGFloat = 5)
    case medium(initialVelocity: CGFloat? = nil, damping: CGFloat = 10)
    case heavy(initialVelocity: CGFloat? = nil, damping: CGFloat = 15)
    
    public var initialVelocity: CGFloat {
        switch self {
        case .none(let initialVelocity, _): initialVelocity ?? Self.defaultInitialVelocity
        case .light(let initialVelocity, _): initialVelocity ?? Self.defaultInitialVelocity
        case .medium(let initialVelocity, _): initialVelocity ?? Self.defaultInitialVelocity
        case .heavy(let initialVelocity, _): initialVelocity ?? Self.defaultInitialVelocity
        }
    }
    
    public var damping: CGFloat {
        switch self {
        case .none(_, let damping): damping
        case .light(_, let damping): damping
        case .medium(_, let damping): damping
        case .heavy(_, let damping): damping
        }
    }
}

public class AnimationChain: NSObject, Chainable {
    fileprivate weak var target: BView?
    public var effects: [ACBaseEffect]
    public var completion: (() -> Void)?
    public var sequential: AnimationChain?
    public var parallel: AnimationChain?
    
    public init(
        effects: [ACBaseEffect]
    ) {
        self.effects = effects
        super.init()
    }
    
    public convenience init(
        _ target: BView,
        @FBuilder<ACBaseEffect> effects: () -> [ACBaseEffect]
    ) {
        self.init(effects: effects())
        target.animationChain = self
        self.target = target
    }
    
    public func animation(using view: BView) -> CAAnimation {
        let group = CAAnimationGroup()
        group.delegate = self
        let animations = effects.map { $0.animation(for: view) }
        group.animations = animations
        group.duration = effects.map { ($0.delay ?? 0) + $0.duration }.max() ?? 0
        return group
    }
    
    public func execute() {
        guard let target else { return }
        target.layer.add(animation(using: target), forKey: nil)
        target.layer.makeAnimationsPersistent()
        parallel?.execute()
    }
    
    @discardableResult
    public func target(_ target: BView) -> Self {
        target.animationChain = self
        self.target = target
        return self
    }
    
    @discardableResult
    public func next(_ action: AnimationChain) -> Self {
        self.sequential = action
        return self
    }
    
    @discardableResult
    public func parallel(_ action: AnimationChain) -> Self {
        self.parallel = action
        return self
    }
    
    @discardableResult
    public func completion(_ completion: @escaping () -> Void) -> Self {
        self.completion = completion
        return self
    }
}

extension AnimationChain: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        sequential?.execute()
        completion?()
    }
}

public extension BView {
    static let animationChain = ObjectAssociation<AnimationChain>()
    
    var animationChain: AnimationChain? {
        get { Self.animationChain[self] }
        set { Self.animationChain[self] = newValue }
    }
}
