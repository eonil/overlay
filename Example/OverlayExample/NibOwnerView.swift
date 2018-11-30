//
//  NibOwnerView.swift
//  OverlayExample
//
//  Created by Henry on 2018/11/30.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

class NibOwnerView: UIView {
    @IBOutlet var container: UIView?

    func loadFromNib(name: String) {
        let b = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: b)
        nib.instantiate(withOwner: self, options: nil)
        guard let c = container else { return }
        container = nil
        addSubview(c)
        c.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            c.leadingAnchor.constraint(equalTo: leadingAnchor),
            c.trailingAnchor.constraint(equalTo: trailingAnchor),
            c.topAnchor.constraint(equalTo: topAnchor),
            c.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
    }
}
