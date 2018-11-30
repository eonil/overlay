//
//  BackgroundFillingLayoutContext.swift
//  Overlay
//
//  Created by Henry on 2018/11/30.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

struct BackgroundFillingLayoutContext {
    var contentBottom = CGFloat(0)
    var contentHeight = CGFloat(0)
    var contentDisplacement = CGFloat(0)
}

extension ContentConstraintPalette {
    func fillingContext(displacement d: CGFloat) -> BackgroundFillingLayoutContext {
        let b = CGFloat(0)
        let h = sizeAtInstallation?.height ?? 0
        return BackgroundFillingLayoutContext(
            contentBottom: b,
            contentHeight: h,
            contentDisplacement: d)
    }
}
