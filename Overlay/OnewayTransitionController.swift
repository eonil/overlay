//
//  OnewayTransitionController.swift
//  Overlay
//
//  Created by Henry on 2018/11/30.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

final class OnewayTransitionController {
    var note: (() -> Void)?
    var isAnimating: Bool {
        return animc.isRunning
    }

    init(config x: OverlayConfig, fillViewController fvc: FillViewController, viewPair vp: ViewPair, contentConstraints ccs: ContentConstraintPalette) {
        assert(!vp.content.translatesAutoresizingMaskIntoConstraints)
        config = x
        fillViewController = fvc
        viewPair = vp
        contentConstraints = ccs
    }
    func runPresentationAnimation() {
        animc.run(
            predelay:  0,
            duration:  config.onewayTransitionDuration,
            postdelay: 0,
            prepare:   { [weak self] in self?.preparePresentation() },
            layout:    { [weak self] in self?.layoutPresentation() },
            cleanup:   { [weak self] in self?.cleanupPresentation() })
    }
    func runDismissionAnimation() {
        animc.run(
            predelay:  0,
            duration:  config.onewayTransitionDuration,
            postdelay: 0,
            prepare:   { [weak self] in self?.prepareDismission() },
            layout:    { [weak self] in self?.layoutDismission() },
            cleanup:   { [weak self] in self?.cleanupDismission() })
    }

    func spawnRunningContext() -> RunningContext {
        precondition(animc.isRunning == false)
        return RunningContext(
            config: config,
            fillViewController: fillViewController,
            viewPair: viewPair,
            contentConstraints: contentConstraints)
    }

    private let config: OverlayConfig
    private let animc = AnimationController()
    private let fillViewController: FillViewController
    private let viewPair: ViewPair
    private var contentConstraints: ContentConstraintPalette

    private func preparePresentation() {
        fillViewController.preparePresentation()
        viewPair.container.addSubview(viewPair.content)
        contentConstraints.installConstraints(viewPair)
        viewPair.container.layoutIfNeeded()
        // This must be layout separately after all other layout
        // finished. There're some corner cases that requires this.
        // - If content-view becomes first responder in this method,
        //   it can cause keyboard animation, and so extra animations too.
        //   If there's an extra animations intended, above layout
        //   must be done to start animation from correct positions.
        (viewPair.content as? TransitionProtocol)?.preparePresentation()
        viewPair.container.layoutIfNeeded()
    }
    private func layoutPresentation() {
        assert(contentConstraints.bottom != nil)
        let fctx = contentConstraints.fillingContext(displacement: 0)
        fillViewController.layoutPresentation(context: fctx)
        contentConstraints.bottom?.constant = 0
        viewPair.container.layoutIfNeeded()
        // This must be layout separately same reason with preparing.
        (viewPair.content as? TransitionProtocol)?.layoutPresentation()
        viewPair.container.layoutIfNeeded()
    }
    private func cleanupPresentation() {
        fillViewController.cleanupPresentation()
        (viewPair as? TransitionProtocol)?.cleanupPresentation()
        note?()
    }

    private func prepareDismission() {
        fillViewController.prepareDismission()
        viewPair.container.layoutIfNeeded()
        (viewPair.content as? TransitionProtocol)?.prepareDismission()
        viewPair.container.layoutIfNeeded()
    }
    private func layoutDismission() {
        let sz = viewPair.measureContentSize()
        let displacement = +sz.height
        contentConstraints.bottom?.constant = displacement
        let fctx = contentConstraints.fillingContext(displacement: displacement)
        fillViewController.layoutDismission(context: fctx)
        viewPair.container.layoutIfNeeded()
        (viewPair.content as? TransitionProtocol)?.layoutDismission()
        viewPair.container.layoutIfNeeded()
    }
    private func cleanupDismission() {
        fillViewController.cleanupDismission()
        (viewPair.content as? TransitionProtocol)?.cleanupDismission()
        contentConstraints.deinstallConstraints(viewPair)
        viewPair.content.removeFromSuperview()
        note?()
    }
}
