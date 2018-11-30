//
//  OverlayState.swift
//  Overlay
//
//  Created by Henry on 2018/11/29.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

public struct OverlayState: Equatable {
    public weak var container: UIView?
    public weak var content: UIView? {
        willSet {
            assert(newValue == nil || newValue!.translatesAutoresizingMaskIntoConstraints == false)
        }
    }

    public init() {
    }
    public init(container c: UIView, content cc: UIView?) {
        assert(cc == nil || cc!.translatesAutoresizingMaskIntoConstraints == false)
        container = c
        content = cc
    }
    func getPair() -> ViewPair? {
        guard let container = container else { return nil }
        guard let content = content else { return nil }
        return ViewPair(container: container, content: content)
    }
    func nilCount() -> Int {
        return (container == nil ? 1 : 0) + (content == nil ? 1 : 0)
    }

    public static func == (_ a: OverlayState, _ b: OverlayState) -> Bool {
        return a.container === b.container
            && a.content === b.content
    }
}
