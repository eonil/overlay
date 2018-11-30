//
//  ContentConstraintPalette.swift
//  Overlay
//
//  Created by Henry on 2018/11/29.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

struct ContentConstraintPalette {
    var all = [NSLayoutConstraint]()
    weak var bottom: NSLayoutConstraint?
    weak var height: NSLayoutConstraint?
    ///
    /// Size measured at installation time.
    /// This will be used for later growth/translation management by end-user dragging.
    var sizeAtInstallation: CGSize?

    func setContentDisplacement(to d: CGFloat) {
        guard let h = sizeAtInstallation?.height else { return }
        if d < 0 {
            // Resize content view.
            height?.constant = h + -d
            bottom?.constant = 0
        }
        else {
            // Translate content view.
            height?.constant = h
            bottom?.constant = 0 + d
        }
    }
    mutating func installConstraints(_ vp: ViewPair) {
        assert(all.isEmpty)
        assert(bottom == nil)
        assert(height == nil)
        assert(vp.content.translatesAutoresizingMaskIntoConstraints == false)

        let sz = vp.measureContentSize()
//        assert(sz.height > 0)
        let bc = vp.content.bottomAnchor.constraint(equalTo: vp.container.bottomAnchor, constant: +sz.height)
        let hc = vp.content.heightAnchor.constraint(equalToConstant: sz.height)
        bottom = bc
        height = hc
        all.append(contentsOf: [
            vp.container.leadingAnchor.constraint(equalTo: vp.content.leadingAnchor),
            vp.container.trailingAnchor.constraint(equalTo: vp.content.trailingAnchor),
            bc,
            hc,
        ])
        NSLayoutConstraint.activate(all)
        sizeAtInstallation = sz
    }
    mutating func deinstallConstraints(_ vp: ViewPair) {
        NSLayoutConstraint.deactivate(all)
        bottom = nil
        height = nil
        all.removeAll(keepingCapacity: true)
        sizeAtInstallation = nil
    }
}
