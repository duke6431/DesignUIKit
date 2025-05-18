//
//  File.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 25/9/24.
//

import UIKit
import DesignCore

class HoldConfiguration {
    var onHold: ClosureSleeve?
    var onRelease: ClosureSleeve?
    var delay: TimeInterval = 0.15
    var timer: Timer?
    var holding: Bool = false
    var shouldRepeat: Bool = false
}

extension UIButton {
    private static let holdConfiguration = ObjectAssociation<HoldConfiguration>()

    var holdConfiguration: HoldConfiguration {
        get { Self.holdConfiguration[self] ?? .init() }
        set { Self.holdConfiguration[self] = newValue }
    }

    @objc func startHold() {
        holdConfiguration.holding = true
        guard let timer = holdConfiguration.timer else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + holdConfiguration.delay) { [weak self] in
            if self?.holdConfiguration.holding ?? false {
                RunLoop.main.add(timer, forMode: .default)
                self?.holdConfiguration.onHold?.invoke()
            }
        }
    }

    @objc func stopHold() {
        holdConfiguration.onRelease?.invoke()
        holdConfiguration.holding = false
        holdConfiguration.timer?.invalidate()
        holdConfiguration.timer = Timer(timeInterval: 0.1, repeats: holdConfiguration.shouldRepeat, block: { [weak self] _ in
            self?.holdConfiguration.onHold?.invoke()
        })
    }

    public func attachLongHold(
        delay: TimeInterval = 0.15,
        shouldRepeat: Bool = false,
        onHold: @escaping (UIButton) -> Void,
        onRelease: ((UIButton) -> Void)? = nil
    ) {
        holdConfiguration = .init()
        holdConfiguration.shouldRepeat = shouldRepeat
        holdConfiguration.timer?.invalidate()
        holdConfiguration.timer = Timer(timeInterval: 0.1, repeats: shouldRepeat, block: { [weak self] _ in
            self?.holdConfiguration.onHold?.invoke()
        })
        self.holdConfiguration.onHold = .init { [weak self] in
            guard let self = self else { return }
            onHold(self)
        }
        self.holdConfiguration.onRelease = .init { [weak self] in
            guard let self = self else { return }
            onRelease?(self)
        }
        self.addTarget(self, action: #selector(startHold), for: .touchDown)
        self.addTarget(self, action: #selector(stopHold), for: [.touchUpInside, .touchUpOutside])
    }
}
