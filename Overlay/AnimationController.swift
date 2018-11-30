//
//  AnimationController.swift
//  Overlay
//
//  Created by Henry on 2018/11/29.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

final class AnimationController {
    private(set) var isRunning = false
    func run(predelay: TimeInterval = 0, duration: TimeInterval = 0.4, postdelay: TimeInterval = 0, prepare: @escaping () -> Void, layout: @escaping () -> Void, cleanup: @escaping () -> Void) {
        isRunning = true
        prepare()
        UIView.animate(
            withDuration: duration,
            delay: predelay,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [.transitionCrossDissolve],
            animations: layout,
            completion: { [weak self] _ in
                let ms = Int(round(postdelay * 1000))
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(ms), execute: { [weak self] in
                    self?.isRunning = false
                    cleanup()
                })
        })
    }
}
