//
//  OBJCProxy.swift
//  Overlay
//
//  Created by Henry on 2018/11/29.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation

final class OBJCProxy: NSObject {
    var note: (() -> Void)?
    @objc
    func handle() {
        note?()
    }
}
