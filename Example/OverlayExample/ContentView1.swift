//
//  ContentView1.swift
//  OverlayExample
//
//  Created by Henry on 2018/11/29.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
final class ContentView1: NibOwnerView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        loadFromNib(name: "ContentView1")
        accessibilityIdentifier = "ContentView1"
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
        loadFromNib(name: "ContentView1")
        accessibilityIdentifier = "ContentView1"
    }
}
