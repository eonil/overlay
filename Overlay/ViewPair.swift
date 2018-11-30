//
//  ViewPair.swift
//  Overlay
//
//  Created by Henry on 2018/11/29.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

struct ViewPair: Equatable, Hashable {
    var container: UIView
    var content: UIView

    func measureContentSize() -> CGSize {
        let sz = content.systemLayoutSizeFitting(
            CGSize(width: container.bounds.width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
        return sz
    }

    static func == (_ a: ViewPair, _ b: ViewPair) -> Bool {
        return a.container === b.container
            && a.content === b.content
    }
}

