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

    ////

    override func viewDidLoad() {
        super.viewDidLoad()
//        config.crossTransitionStyle = .none
        config.backgroundFilling = .darkSolidFillingWithDarkBlurContentBackground
        config.automaticallyDismissByEndUserInteraction = false
        overlay.control(.config(config))
        overlay.note = { [weak self] m in self?.processOverlayNote(m) }
    }

    @IBOutlet weak var containerView: UIView?

    @IBAction
    func userTapPresent1Button(_ sender: UIButton) {
        var s = OverlayState()
        s.container = containerView
        s.content = contentView1
        overlay.control(.render(s))
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
}
