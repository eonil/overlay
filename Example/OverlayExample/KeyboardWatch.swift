//
//  KeyboardWatch.swift
//  OverlayExample
//
//  Created by Henry on 2018/12/07.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

final class KeyboardWatch {
    var note: ((CGRect) -> Void)?
    private var observer: Any?
    init() {
        observer = NotificationCenter.default.addObserver(forName: UIView.keyboardWillChangeFrameNotification, object: nil, queue: .main, using: { [weak self] n in self?.processKeyboardWillChangeFrame(n) })
    }
    deinit {
        NotificationCenter.default.removeObserver(observer!)
    }
    private func processKeyboardWillChangeFrame(_ n: Notification) {
        guard let f = n.userInfo?[UIView.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        note?(f)
    }
}
