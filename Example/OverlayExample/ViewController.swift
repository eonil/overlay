//
//  ViewController.swift
//  OverlayExample
//
//  Created by Henry on 2018/11/29.
//  Copyright © 2018 Henry. All rights reserved.
//

import UIKit
import Overlay

class ViewController: UIViewController {

    private let kbdw = KeyboardWatch()
    private let contentView1 = ContentView1()
    private let contentView2 = ContentView2()
    private let overlay = Overlay()
    private var config = OverlayConfig()

    private func processOverlayNote(_ m: OverlayNote) {
        switch m {
        case .dismiss:
            var s = OverlayState()
            s.container = containerView
            s.content = nil
            overlay.control(.render(s))
        }
    }
    private func processKeyboardNote(_ m: CGRect) {
        guard let f = view.window?.convert(m, from: nil) else { return }
        let f1 = view.convert(f, from: nil)
        let c = view.bounds.maxY - f1.minY
        containerViewBottomConstraint?.constant = c + 10
        view.layoutIfNeeded()

    }

    ////

    override func viewDidLoad() {
        super.viewDidLoad()
//        config.crossTransitionStyle = .none
        config.backgroundFilling = .darkSolidFillingWithDarkBlurContentBackground
        config.automaticallyDismissByEndUserInteraction = false
        overlay.control(.config(config))
        overlay.note = { [weak self] m in self?.processOverlayNote(m) }
        kbdw.note = { [weak self] m in self?.processKeyboardNote(m) }
    }

    @IBOutlet weak var containerView: UIView?
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var textField: UITextField?

    @IBAction
    func userTapPresent1Button(_ sender: UIButton) {
        var s = OverlayState()
        s.container = containerView
        s.content = contentView1
        overlay.control(.render(s))
        textField?.becomeFirstResponder()
    }
    @IBAction
    func userTapPresent2Button(_ sender: UIButton) {
        var s = OverlayState()
        s.container = containerView
        s.content = contentView2
        overlay.control(.render(s))
    }
    @IBAction
    func userTapDismissButton(_ sender: UIButton) {
        var s = OverlayState()
        s.container = containerView
        s.content = nil
        overlay.control(.render(s))
    }
    @IBAction
    func userSwitchSlowAnimation(_ sender: UISwitch) {
        let slow = sender.isOn
        config.onewayTransitionDuration = slow ? 4 : 0.4
        config.crossTransitionDuration = slow ? 4 : 0.4
        overlay.control(.config(config))
    }

    @IBAction
    func userTapHideKeyboardButton(_ sender: UIButton) {
        view.endEditing(true)
    }
}
