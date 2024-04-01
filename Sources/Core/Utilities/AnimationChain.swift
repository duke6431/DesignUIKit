//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 3/29/24.
//

import Foundation
import QuartzCore

//public protocol AnimationChainable: Chainable {
//    var totalTime: TimeInterval { get }
//    func callAsFunction(using view: BView) -> CAAnimationGroup
//    var next: AnimationChainable? { get }
//}

public enum AnimationChainEffect {
    case opacity(CGFloat)
    case offset(x: CGFloat, y: CGFloat)
    case scale(multiplier: CGFloat)
    case rotate(radians: CGFloat)
    case custom(configuration: (CABasicAnimation) -> Void)
}

public enum AnimationChainSpringOption {
    case none
    case light
    case medium
    case heavy
}

public class AnimationChain: NSObject, Chainable {
    fileprivate weak var target: BView?
    public var effect: AnimationChainEffect
    public var delay: TimeInterval?
    public var duration: TimeInterval
    public var spring: AnimationChainSpringOption
    public var timingFunction: CAMediaTimingFunction?
    public var completion: (() -> Void)?
    public var sequential: AnimationChain?
    public var parallel: AnimationChain?
    
    public var totalTime: TimeInterval { (delay ?? 0) + duration }
    
    public init(
        effect: AnimationChainEffect, delay: TimeInterval? = nil, duration: TimeInterval = 0.25,
        spring: AnimationChainSpringOption = .light, timingFunction: CAMediaTimingFunction? = nil
    ) {
        self.effect = effect
        self.delay = delay
        self.duration = duration
        self.timingFunction = timingFunction
        self.spring = spring
    }
    
    public func animation(using view: BView) -> CAAnimation {
        var animation = CASpringAnimation()
        animation.initialVelocity = 30
        switch spring {
        case .none:
            animation.damping = .greatestFiniteMagnitude
        case .light:
            animation.damping = 3
        case .medium:
            animation.damping = 7
        case .heavy:
            animation.damping = 10
        }
        switch effect {
        case .opacity(let alpha):
            animation.keyPath = "opacity"
            animation.fromValue = view.layer.presentation()?.value(forKey: "opacity")
            animation.toValue = alpha
        case .offset(let x, let y):
            animation.keyPath = "position"
            guard let currentPosition = view.layer.presentation()?.value(forKey: "position") as? CGPoint else { break }
            animation.fromValue = view.layer.presentation()?.value(forKey: "position")
            animation.toValue = CGPoint(x: currentPosition.x + x, y: currentPosition.y + y)
        case .scale(let multiplier):
            animation.keyPath = "transform.scale"
            animation.fromValue = view.layer.presentation()?.value(forKey: "transform.scale")
            animation.toValue = multiplier
        case .rotate(let radians):
            animation.keyPath = "transform.rotation.z"
            animation.fromValue = view.layer.presentation()?.value(forKey: "transform.rotation.z")
            animation.toValue = radians
        case .custom(let configuration):
            configuration(animation)
        }
        
        animation.delegate = self
        animation.beginTime = CACurrentMediaTime() + (delay ?? 0)
        animation.duration = duration
        if let timingFunction { animation.timingFunction = timingFunction }
        return animation
    }
    
    func execute() {
        guard let target else { return }
        target.layer.add(animation(using: target), forKey: nil)
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

//public class AnimationChainGroup: NSObject, AnimationChainable, Chainable {
//    public var action: AnimationChainAction
//    public var next: AnimationChainable?
//    fileprivate var completion: (() -> Void)?
//    
//    public var totalTime: TimeInterval { action.totalTime }
//    public init(action: AnimationChainAction, next: AnimationChainable? = nil, completion: (() -> Void)? = nil) {
//        self.action = action
//        self.next = next
//        self.completion = completion
//    }
//    
//    public func callAsFunction(using view: BView) -> CAAnimationGroup {
//        let group = CAAnimationGroup()
//        group.delegate = self
//        group.animations = [action(using: view)] + (next?(using: view).animations ?? [])
//        group.isRemovedOnCompletion = true
//        return group
//    }
//    
//    func next(_ group: AnimationChainGroup) -> Self {
//        self.next = group
//        return self
//    }
//    
//    @discardableResult
//    func completion(_ completion: (() -> Void)?) -> Self {
//        self.completion = completion
//        return self
//    }
//}
//
//extension AnimationChainGroup: CAAnimationDelegate {
//    
//}
//
//public enum AnimationChainType {
//    case parallel
//    case serial
//}
//
//public class AnimationChain: Chainable {
//    public var actionGroup: AnimationChainGroup
//    public var target: BView
//    public var sequential: AnimationChain?
//    public var parallel: AnimationChain?
//    public var completion: (() -> Void)?
//    
//    public init(actionGroup: AnimationChainGroup, target: BView,
//         sequential: AnimationChain? = nil, parallel: AnimationChain? = nil) {
//        self.actionGroup = actionGroup
//        self.target = target
//        self.sequential = sequential
//        self.parallel = parallel
//    }
//    
//    public func execute() {
//        if let completion = completion {
//            actionGroup.completion { [sequential] in
//                completion()
//                sequential?.execute()
//            }
//        } else {
//            actionGroup.completion(sequential?.completion)
//        }
//        target.layer.add(actionGroup(using: target), forKey: nil)
//        parallel?.execute()
//    }
//    
//    public func parallel(_ chain: AnimationChain) -> Self {
//        parallel = chain
//        return self
//    }
//    
//    public func sequential(_ chain: AnimationChain) -> Self {
//        sequential = chain
//        return self
//    }
//}
