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
}
