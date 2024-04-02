//
//  File.swift
//
//
//  Created by Duc Minh Nguyen on 3/29/24.
//

import Foundation
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

protocol StepAnimatable {
    /// Start a sequence where you add each step in the `addSteps` closure. Use the provided `AnimationSequence` object
    /// to add each step which should either be an actual animation or a delay.
    /// The `completion` closure is executed when the last animation has finished.
    /// - Parameters:
    ///   - addSteps: Closure used to add steps to the provided `AnimationSequence` object
    ///   - completion: Executed when the last animation has finished.
    static func animateSteps(_ addSteps: (AnimationSequence) -> Void, completion: ((Bool) -> Void)?)
}

class AnimationSequence {
    
    /// A step for each animation in the sequence.
    enum Step {
        /// A step that merely adds a delay, accumulated for the next step with actual animations
        /// - Parameter duration: Duration of the delay in seconds
        case delay(duration: TimeInterval)
        
#if canImport(UIKit)
        /// An animation step that results in a `UIView.animate()` call with all the necessary options
        /// - Parameter duration: Duration of the animation
        /// - Parameter options: Animation options, when `.repeats` make sure to set a limit or any subsequent next step might not be executed
        /// - Parameter timingFunction: `CAMediaTimingFunction` to apply to animation, will wrap animation in `CATransaction`
        /// - Parameter animations: Closure in which values to animate should be changed
        case animation(
            duration: TimeInterval,
            options: UIView.AnimationOptions = [],
            timingFunction: CAMediaTimingFunction? = nil,
            animations: () -> Void)
#else
        case animation(
            duration: TimeInterval,
            timingFunction: CAMediaTimingFunction? = nil,
            animations: () -> Void)
#endif
        
        /// Step that contains group of animation steps, all of which should be performed simultaniously
        /// - Parameter animations: All the steps to animate at the same time
        case group(animations: [Self])
    }
    
    fileprivate(set) var steps: [Step] = []
}

fileprivate extension AnimationSequence.Step {
    
    /// Full duration for each step type, uses longest duration of animations in a group
    var duration: TimeInterval {
        switch self {
            #if canImport(UIKit)
        case .animation(let duration, _, _, _):
            return duration
            #else
        case .animation(let duration, _, _):
            return duration
            #endif
        case .delay(let delay):
            return delay
        case .group(let steps):
            guard let longestDuration = steps.map({ $0.duration }).max() else {
                return 0
            }
            return longestDuration
        }
    }
}

extension AnimationSequence {
    
    #if canImport(UIKit)
    /// Adds an animation to the sequence with all the available options.
    ///
    /// Adding each steps can by done in a chain, as this method returns `Self`
    /// - Note: Adding a timing function will wrap the animation in a `CATransaction` commit
    /// - Parameters:
    ///   - duration: How long the animation should last
    ///   - options: Options to use for the animation
    ///   - timingFunction: `CAMediaTimingFunction` to use for animation
    ///   - animations: Closure in which values to animate should be changed
    /// - Returns: Returns self, enabling the use of chaining mulitple calls
    @discardableResult func add(
        duration: TimeInterval,
        options: UIView.AnimationOptions = [],
        timingFunction: CAMediaTimingFunction? = nil,
        animations: @escaping () -> Void
    ) -> Self {
        steps.append(
            .animation(duration: duration, options: options, timingFunction: timingFunction, animations: animations)
        )
        return self
    }
    #else
    /// Adds an animation to the sequence with all the available options.
    ///
    /// Adding each steps can by done in a chain, as this method returns `Self`
    /// - Note: Adding a timing function will wrap the animation in a `CATransaction` commit
    /// - Parameters:
    ///   - duration: How long the animation should last
    ///   - options: Options to use for the animation
    ///   - timingFunction: `CAMediaTimingFunction` to use for animation
    ///   - animations: Closure in which values to animate should be changed
    /// - Returns: Returns self, enabling the use of chaining mulitple calls
    @discardableResult func add(
        duration: TimeInterval,
        timingFunction: CAMediaTimingFunction? = nil,
        animations: @escaping () -> Void
    ) -> Self {
        steps.append(
            .animation(duration: duration, timingFunction: timingFunction, animations: animations)
        )
        return self
    }
    #endif
    
    /// Adds a delay to the animation sequence
    ///
    /// While this adds an actual step to the sequence, in practice the next step that actually does
    /// the animation will use the delay of the previous steps (or all previous delays leading up to that step)
    /// - Parameter delay: Duration of the delay
    /// - Returns: Returns self, enabling the use of chaining mulitple calls
    @discardableResult func delay(_ duration: TimeInterval) -> Self {
        steps.append(
            .delay(duration: duration)
        )
        return self
    }
}

extension AnimationSequence {
    
    /// Group of animation steps, all of which should be performed simultaniously
    class AnimationGroup {
        
        private(set) var animations: [Step] = []
        
        #if canImport(UIKit)
        /// Adds an animation to the animation group with all the available options.
        ///
        /// Adding each animation can by done in a chain, as this method returns `Self`
        /// - Note: Adding a timing function will wrap the animation in a `CATransaction` commit
        /// - Parameters:
        ///   - duration: How long the animation should last
        ///   - options: Options to use for the animation
        ///   - timingFunction: `CAMediaTimingFunction` to use for animation
        ///   - animations: Closure in which values to animate should be changed
        /// - Returns: Returns self, enabling the use of chaining mulitple calls
        @discardableResult func animate(
            duration: TimeInterval,
            options: UIView.AnimationOptions = [],
            timingFunction: CAMediaTimingFunction? = nil,
            animations: @escaping () -> Void
        ) -> Self {
            self.animations.append(
                .animation(duration: duration, options: options, timingFunction: timingFunction, animations: animations)
            )
            return self
        }
        #else
        /// Adds an animation to the animation group with all the available options.
        ///
        /// Adding each animation can by done in a chain, as this method returns `Self`
        /// - Note: Adding a timing function will wrap the animation in a `CATransaction` commit
        /// - Parameters:
        ///   - duration: How long the animation should last
        ///   - options: Options to use for the animation
        ///   - timingFunction: `CAMediaTimingFunction` to use for animation
        ///   - animations: Closure in which values to animate should be changed
        /// - Returns: Returns self, enabling the use of chaining mulitple calls
        @discardableResult func animate(
            duration: TimeInterval,
            timingFunction: CAMediaTimingFunction? = nil,
            animations: @escaping () -> Void
        ) -> Self {
            self.animations.append(
                .animation(duration: duration, timingFunction: timingFunction, animations: animations)
            )
            return self
        }
        #endif
    }
    
    /// Adds a group of animations, all of which will be executed add once.
    /// - Parameter addAnimations: Closure used to add animations to the provided `AnimationGroup` object
    /// - Returns: Returns self, enabling the use of chaining mulitple calls
    @discardableResult func addGroup(with addAnimations: (AnimationGroup) -> Void) -> Self {
        let group = AnimationGroup()
        addAnimations(group)
        steps.append(
            .group(animations: group.animations)
        )
        return self
    }
}

// MARK: - Actual animation logic
fileprivate extension AnimationSequence.Step {
#if canImport(UIKit)
    /// Perform the animation for this step
    ///
    /// Wraps animation steps with a `timingFunction` in a `CATransaction` commit
    /// - Parameters:
    ///   - delay: Time in seconds to wait to perform the animation
    ///   - completion: Closure to be executed when animation has finished
    func animate(
        withDelay delay: TimeInterval,
        completion: ((Bool) -> Void)?
    ) {
        switch self {
        case .animation(let duration, let options, let timingFunction, let animations):
            let createAnimations: (((Bool) -> Void)?) -> Void = { completion in
                UIView.animate(
                    withDuration: duration,
                    delay: delay,
                    options: options,
                    animations: animations,
                    completion: completion
                )
            }
            
            if let timingFunction = timingFunction {
                CATransaction.begin()
                CATransaction.setAnimationDuration(duration)
                CATransaction.setAnimationTimingFunction(timingFunction)
                CATransaction.setCompletionBlock({ completion?(true) })
                
                createAnimations(nil)
                
                CATransaction.commit()
            } else {
                createAnimations(completion)
            }
        case .group(let steps):
            let sortedSteps = steps.sorted(by: { $0.duration < $1.duration })
            guard let longestStep = sortedSteps.last else {
                // No steps to animate, call completion
                completion?(true)
                return
            }
            sortedSteps.dropLast().forEach { step in
                step.animate(withDelay: delay, completion: nil)
            }
            // Animate the longest step with the completion, so the completion closure
            // is executed when all steps should be completed
            longestStep.animate(withDelay: delay, completion: completion)
        case .delay(_):
            fatalError("Delay steps should not be animated")
        }
    }
#else
    /// Perform the animation for this step
    ///
    /// Wraps animation steps with a `timingFunction` in a `CATransaction` commit
    /// - Parameters:
    ///   - delay: No delay for animation
    ///   - completion: Closure to be executed when animation has finished
    func animate(
        withDelay delay: TimeInterval,
        completion: ((Bool) -> Void)?
    ) {
        switch self {
        case .animation(let duration, let timingFunction, let animations):
            let createAnimations: (((Bool) -> Void)?) -> Void = { completion in
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = duration
                    animations() // Assuming animations are functions to perform
                } completionHandler: {
                    completion?(true)
                }
            }
            
            if let timingFunction = timingFunction {
                NSAnimationContext.beginGrouping()
                NSAnimationContext.current.duration = duration
                NSAnimationContext.current.timingFunction = timingFunction
                NSAnimationContext.current.completionHandler = { completion?(true) }
                
                createAnimations(nil)
                
                NSAnimationContext.endGrouping()
            } else {
                createAnimations(completion)
            }
        case .group(let steps):
            let sortedSteps = steps.sorted(by: { $0.duration < $1.duration })
            guard let longestStep = sortedSteps.last else {
                // No steps to animate, call completion
                completion?(true)
                return
            }
            sortedSteps.dropLast().forEach { step in
                step.animate(withDelay: delay, completion: nil)
            }
            // Animate the longest step with the completion
            longestStep.animate(withDelay: delay, completion: completion)
        case .delay(_):
            fatalError("Delay steps should not be animated")
        }
    }
#endif
}

extension BView: StepAnimatable {
    
    class func animateSteps(_ addSteps: (AnimationSequence) -> Void, completion: ((Bool) -> Void)? = nil) {
        let sequence = AnimationSequence()
        
        // Call the block with the sequence object,
        // hopefully resulting in steps added to the sequence
        addSteps(sequence)
        
        // Start animating all the steps
        animate(remainingSteps: sequence.steps, completion: completion)
    }
}

fileprivate extension BView {
    
    /// Recursive method that calls itself with less remaining steps each time
    /// - Parameters:
    ///   - steps: Array of steps that needs to be animated
    ///   - completion: Completion closure to be executed when last step has finished
    private class func animate(remainingSteps steps: [AnimationSequence.Step], completion: ((Bool) -> Void)? = nil) {
        
        var cummulativeDelay: TimeInterval = 0
        
        // Drop any initial steps with just a delay, but keep track of their delay
        let animatableSteps = steps.drop { step in
            if case let .delay(delay) = step {
                cummulativeDelay += delay
                return true
            }
            return false
        }
        
        guard let step = animatableSteps.first else {
            // When there's no more steps available, there's no more animations to be done
            guard let completion = completion else {
                // No completion closure to call
                return
            }
            
            if cummulativeDelay > 0 {
                // Wait out the remaing delay until calling completion closure
                DispatchQueue.main.asyncAfter(deadline: .now() + cummulativeDelay) {
                    completion(true)
                }
            } else {
                completion(true)
            }
            return
        }
        
        let remainingSteps = animatableSteps.dropFirst()
        
        // Actually perform animation for first step to animate
        // with the accumulated delay of possible previous delay steps
        step.animate(withDelay: cummulativeDelay) { finished in
            // Recursively call this class method again with the remaining steps
            animate(remainingSteps: Array(remainingSteps), completion: completion)
        }
    }
}
