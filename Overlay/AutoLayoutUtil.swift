//
//  AutoLayoutUtil.swift
//  Overlay
//
//  Created by Henry on 2018/12/06.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func constrainToFillContainer() {
        precondition(superview != nil)
        precondition(!translatesAutoresizingMaskIntoConstraints)
        guard let v = superview else { return }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: v.centerXAnchor),
            centerYAnchor.constraint(equalTo: v.centerYAnchor),
            widthAnchor.constraint(equalTo: v.widthAnchor),
            heightAnchor.constraint(equalTo: v.heightAnchor),
            ])
    }
}
