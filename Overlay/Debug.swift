//
//  Debug.swift
//  Overlay
//
//  Created by Henry on 2018/11/30.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

struct Debug {
    static func assertAutoLayoutCompatibleView(_ v: @autoclosure() -> UIView?) {
        guard let v = v() else { return }
        assert(
            v.translatesAutoresizingMaskIntoConstraints == false,
            ["Supplied view \(v) `translatesAutoresizingMaskIntoConstraints` is not set to `false`.",
             "This view is not Auto Layout compatible."].joined())
    }
    static func assertNonZeroHeightView(_ v: @autoclosure() -> UIView?) {
        guard let v = v() else { return }
        let sz = v.systemLayoutSizeFitting(
            CGSize(width: UIScreen.main.bounds.width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
        assert(
            sz.height > 0,
            "Supplied view's compressed height == 0. Please check it again.")
    }
}
