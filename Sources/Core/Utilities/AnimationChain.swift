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
    case opacity(CGFloat, delay: TimeInterval? = nil, duration: TimeInterval = 0.25, spring: AnimationChainSpringOption = .none, timingFunction: CAMediaTimingFunction? = nil)
    case offset(x: CGFloat, y: CGFloat, delay: TimeInterval?, duration: TimeInterval = 0.25, spring: AnimationChainSpringOption = .none, timingFunction: CAMediaTimingFunction? = nil)
    case scale(multiplier: CGFloat, delay: TimeInterval? = nil, duration: TimeInterval = 0.25, spring: AnimationChainSpringOption = .none, timingFunction: CAMediaTimingFunction? = nil)
    case rotate(radians: CGFloat, delay: TimeInterval? = nil, duration: TimeInterval = 0.25, spring: AnimationChainSpringOption = .none, timingFunction: CAMediaTimingFunction? = nil)
    case custom(configuration: (CABasicAnimation) -> Void, delay: TimeInterval? = nil, duration: TimeInterval = 0.25, spring: AnimationChainSpringOption = .none, timingFunction: CAMediaTimingFunction? = nil)
    
    var delay: TimeInterval? {
        switch self {
        case .opacity(_, let delay, _, _, _): delay
        case .offset(_, _, let delay, _, _, _): delay
        case .scale(_, let delay, _, _, _): delay
        case .rotate(_, let delay, _, _, _): delay
        case .custom(_, let delay, _, _, _): delay
        }
    }
    var duration: TimeInterval {
        switch self {
        case .opacity(_, _, let duration, _, _): duration
        case .offset(_, _, _, let duration, _, _): duration
        case .scale(_, _, let duration, _, _): duration
        case .rotate(_, _, let duration, _, _): duration
        case .custom(_, _, let duration, _, _): duration
        }
    }
    
    var spring: AnimationChainSpringOption {
        switch self {
        case .opacity(_, _, _, let spring, _): spring
        case .offset(_, _, _, _, let spring, _): spring
        case .scale(_, _, _, let spring, _): spring
        case .rotate(_, _, _, let spring, _): spring
        case .custom(_, _, _, let spring, _): spring
        }
    }
    
    var timingFunction: CAMediaTimingFunction? {
        switch self {
        case .opacity(_, _, _, _, let timingFunction): timingFunction
        case .offset(_, _, _, _, _, let timingFunction): timingFunction
        case .scale(_, _, _, _, let timingFunction): timingFunction
        case .rotate(_, _, _, _, let timingFunction): timingFunction
        case .custom(_, _, _, _, let timingFunction): timingFunction
        }
    }
}

public enum AnimationChainSpringOption {
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
    public var effects: [AnimationChainEffect]
    public var completion: (() -> Void)?
    public var sequential: AnimationChain?
    public var parallel: AnimationChain?

    public init(
        effects: [AnimationChainEffect]
    ) {
        self.effects = effects
    }
    
    public init(
        _ target: BView,
        @FBuilder<AnimationChainEffect> effects: () -> [AnimationChainEffect]
    ) {
        target.animationChain = self
        self.target = target
        self.effects = effects()
    }
    
    public func animation(using view: BView) -> CAAnimation {
        let group = CAAnimationGroup()
        group.animations = effects.map { animation(using: view, effect: $0) }
        return group
    }
    
    public func animation(using view: BView, effect: AnimationChainEffect) -> CAAnimation {
        let animation = CASpringAnimation()
        animation.initialVelocity = effect.spring.initialVelocity
        switch effect {
        case .opacity(let alpha, _, _, _, _):
            animation.keyPath = "opacity"
            animation.fromValue = view.layer.presentation()?.value(forKey: "opacity")
            animation.toValue = alpha
        case .offset(let x, let y, _, _, _, _):
            animation.keyPath = "position"
            guard let currentPosition = view.layer.presentation()?.value(forKey: "position") as? CGPoint else { break }
            animation.fromValue = view.layer.presentation()?.value(forKey: "position")
            animation.toValue = CGPoint(x: currentPosition.x + x, y: currentPosition.y + y)
        case .scale(let multiplier, _, _, _, _):
            animation.keyPath = "transform.scale"
            animation.fromValue = view.layer.presentation()?.value(forKey: "transform.scale")
            animation.toValue = multiplier
        case .rotate(let radians, _, _, _, _):
            animation.keyPath = "transform.rotation.z"
            animation.fromValue = view.layer.presentation()?.value(forKey: "transform.rotation.z")
            animation.toValue = radians
        case .custom(let configuration, _, _, _, _):
            configuration(animation)
        }
        animation.damping = effect.spring.damping
        animation.delegate = self
        animation.beginTime = CACurrentMediaTime() + (effect.delay ?? 0)
        animation.duration = effect.duration
        if let timingFunction = effect.timingFunction { animation.timingFunction = timingFunction }
        return animation
    }
    
    public func execute() {
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

//import UIKit
//
//protocol StepAnimatable {
//    
//    /// Start a sequence where you add each step in the `addSteps` closure. Use the provided `AnimationSequence` object
//    /// to add each step which should either be an actual animation or a delay.
//    /// The `completion` closure is executed when the last animation has finished.
//    /// - Parameters:
//    ///   - addSteps: Closure used to add steps to the provided `AnimationSequence` object
//    ///   - completion: Executed when the last animation has finished.
//    static func animateSteps(_ addSteps: (AnimationSequence) -> Void, completion: ((Bool) -> Void)?)
//}
//
//class AnimationSequence {
//    
//    /// A step for each animation in the sequence.
//    enum Step {
//        /// A step that merely adds a delay, accumulated for the next step with actual animations
//        /// - Parameter duration: Duration of the delay in seconds
//        case delay(duration: TimeInterval)
//        
//        /// An animation step that results in a `UIView.animate()` call with all the necessary options
//        /// - Parameter duration: Duration of the animation
//        /// - Parameter options: Animation options, when `.repeats` make sure to set a limit or any subsequent next step might not be executed
//        /// - Parameter timingFunction: `CAMediaTimingFunction` to apply to animation, will wrap animation in `CATransaction`
//        /// - Parameter animations: Closure in which values to animate should be changed
//        case animation(
//            duration: TimeInterval,
//            options: UIView.AnimationOptions = [],
//            timingFunction: CAMediaTimingFunction? = nil,
//            animations: () -> Void)
//        
//        /// Step that contains group of animation steps, all of which should be performed simultaniously
//        /// - Parameter animations: All the steps to animate at the same time
//        case group(animations: [Self])
//    }
//    
//    fileprivate(set) var steps: [Step] = []
//}
//
//fileprivate extension AnimationSequence.Step {
//    
//    /// Full duration for each step type, uses longest duration of animations in a group
//    var duration: TimeInterval {
//        switch self {
//        case .animation(let duration, _, _, _):
//            return duration
//        case .delay(let delay):
//            return delay
//        case .group(let steps):
//            guard let longestDuration = steps.map({ $0.duration }).max() else {
//                return 0
//            }
//            return longestDuration
//        }
//    }
//}
//
//extension AnimationSequence {
//    
//    /// Adds an animation to the sequence with all the available options.
//    ///
//    /// Adding each steps can by done in a chain, as this method returns `Self`
//    /// - Note: Adding a timing function will wrap the animation in a `CATransaction` commit
//    /// - Parameters:
//    ///   - duration: How long the animation should last
//    ///   - options: Options to use for the animation
//    ///   - timingFunction: `CAMediaTimingFunction` to use for animation
//    ///   - animations: Closure in which values to animate should be changed
//    /// - Returns: Returns self, enabling the use of chaining mulitple calls
//    @discardableResult func add(
//        duration: TimeInterval,
//        options: UIView.AnimationOptions = [],
//        timingFunction: CAMediaTimingFunction? = nil,
//        animations: @escaping () -> Void
//    ) -> Self {
//        steps.append(
//            .animation(duration: duration, options: options, timingFunction: timingFunction, animations: animations)
//        )
//        return self
//    }
//    
//    /// Adds a delay to the animation sequence
//    ///
//    /// While this adds an actual step to the sequence, in practice the next step that actually does
//    /// the animation will use the delay of the previous steps (or all previous delays leading up to that step)
//    /// - Parameter delay: Duration of the delay
//    /// - Returns: Returns self, enabling the use of chaining mulitple calls
//    @discardableResult func delay(_ duration: TimeInterval) -> Self {
//        steps.append(
//            .delay(duration: duration)
//        )
//        return self
//    }
//}
//
//extension AnimationSequence {
//    
//    /// Group of animation steps, all of which should be performed simultaniously
//    class AnimationGroup {
//        
//        private(set) var animations: [Step] = []
//        
//        /// Adds an animation to the animation group with all the available options.
//        ///
//        /// Adding each animation can by done in a chain, as this method returns `Self`
//        /// - Note: Adding a timing function will wrap the animation in a `CATransaction` commit
//        /// - Parameters:
//        ///   - duration: How long the animation should last
//        ///   - options: Options to use for the animation
//        ///   - timingFunction: `CAMediaTimingFunction` to use for animation
//        ///   - animations: Closure in which values to animate should be changed
//        /// - Returns: Returns self, enabling the use of chaining mulitple calls
//        @discardableResult func animate(
//            duration: TimeInterval,
//            options: UIView.AnimationOptions = [],
//            timingFunction: CAMediaTimingFunction? = nil,
//            animations: @escaping () -> Void
//        ) -> Self {
//            self.animations.append(
//                .animation(duration: duration, options: options, timingFunction: timingFunction, animations: animations)
//            )
//            return self
//        }
//    }
//    
//    /// Adds a group of animations, all of which will be executed add once.
//    /// - Parameter addAnimations: Closure used to add animations to the provided `AnimationGroup` object
//    /// - Returns: Returns self, enabling the use of chaining mulitple calls
//    @discardableResult func addGroup(with addAnimations: (AnimationGroup) -> Void) -> Self {
//        let group = AnimationGroup()
//        addAnimations(group)
//        steps.append(
//            .group(animations: group.animations)
//        )
//        return self
//    }
//}
//
//// MARK: - Actual animation logic
//fileprivate extension AnimationSequence.Step {
//    
//    /// Perform the animation for this step
//    ///
//    /// Wraps animation steps with a `timingFunction` in a `CATransaction` commit
//    /// - Parameters:
//    ///   - delay: Time in seconds to wait to perform the animation
//    ///   - completion: Closure to be executed when animation has finished
//    func animate(
//        withDelay delay: TimeInterval,
//        completion: ((Bool) -> Void)?
//    ) {
//        switch self {
//        case .animation(let duration, let options, let timingFunction, let animations):
//            let createAnimations: (((Bool) -> Void)?) -> Void = { completion in
//                UIView.animate(
//                    withDuration: duration,
//                    delay: delay,
//                    options: options,
//                    animations: animations,
//                    completion: completion
//                )
//            }
//            
//            if let timingFunction = timingFunction {
//                CATransaction.begin()
//                CATransaction.setAnimationDuration(duration)
//                CATransaction.setAnimationTimingFunction(timingFunction)
//                CATransaction.setCompletionBlock({ completion?(true) })
//                
//                createAnimations(nil)
//                
//                CATransaction.commit()
//            } else {
//                createAnimations(completion)
//            }
//        case .group(let steps):
//            let sortedSteps = steps.sorted(by: { $0.duration < $1.duration })
//            guard let longestStep = sortedSteps.last else {
//                // No steps to animate, call completion
//                completion?(true)
//                return
//            }
//            sortedSteps.dropLast().forEach { step in
//                step.animate(withDelay: delay, completion: nil)
//            }
//            // Animate the longest step with the completion, so the completion closure
//            // is executed when all steps should be completed
//            longestStep.animate(withDelay: delay, completion: completion)
//        case .delay(_):
//            fatalError("Delay steps should not be animated")
//        }
//    }
//}
//
//extension UIView: StepAnimatable {
//    
//    class func animateSteps(_ addSteps: (AnimationSequence) -> Void, completion: ((Bool) -> Void)? = nil) {
//        let sequence = AnimationSequence()
//        
//        // Call the block with the sequence object,
//        // hopefully resulting in steps added to the sequence
//        addSteps(sequence)
//        
//        // Start animating all the steps
//        animate(remainingSteps: sequence.steps, completion: completion)
//    }
//}
//
//fileprivate extension UIView {
//    
//    /// Recursive method that calls itself with less remaining steps each time
//    /// - Parameters:
//    ///   - steps: Array of steps that needs to be animated
//    ///   - completion: Completion closure to be executed when last step has finished
//    private class func animate(remainingSteps steps: [AnimationSequence.Step], completion: ((Bool) -> Void)? = nil) {
//        
//        var cummulativeDelay: TimeInterval = 0
//        
//        // Drop any initial steps with just a delay, but keep track of their delay
//        let animatableSteps = steps.drop { step in
//            if case let .delay(delay) = step {
//                cummulativeDelay += delay
//                return true
//            }
//            return false
//        }
//        
//        guard let step = animatableSteps.first else {
//            // When there's no more steps available, there's no more animations to be done
//            guard let completion = completion else {
//                // No completion closure to call
//                return
//            }
//
//            if cummulativeDelay > 0 {
//                // Wait out the remaing delay until calling completion closure
//                DispatchQueue.main.asyncAfter(deadline: .now() + cummulativeDelay) {
//                    completion(true)
//                }
//            } else {
//                completion(true)
//            }
//            return
//        }
//        
//        let remainingSteps = animatableSteps.dropFirst()
//        
//        // Actually perform animation for first step to animate
//        // with the accumulated delay of possible previous delay steps
//        step.animate(withDelay: cummulativeDelay) { finished in
//            // Recursively call this class method again with the remaining steps
//            animate(remainingSteps: Array(remainingSteps), completion: completion)
//        }
//    }
//}
