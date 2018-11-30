//
//  CrossTransitionController2.swift
//  Overlay
//
//  Created by Henry on 2018/11/30.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

typealias CrossTransitionController = CrossTransitionController2
final class CrossTransitionController2 {
    var note: (() -> Void)?
    var isAnimating: Bool {
        return animc.isRunning
    }

    init(config x: OverlayConfig, fillViewController fvc: FillViewController, container c: UIView, oldContent oc: UIView, newContent nc: UIView, oldContentConstraints oldccs: ContentConstraintPalette) {
        assert(!oc.translatesAutoresizingMaskIntoConstraints)
        assert(!nc.translatesAutoresizingMaskIntoConstraints)
        config = x
        fillViewController = fvc
        container = c
        oldContent = oc
        newContent = nc
        oldContentConstraints = oldccs
        newContentConstraints = ContentConstraintPalette()
    }
    func runTransitionAnimation() {
        let d = config.crossTransitionDuration
        animc.run(
            predelay: 0.0,
            duration: d,
            postdelay: 0,
            prepare: { [weak self] in self?.prepareCrossTransition() },
            layout:  { [weak self] in self?.layoutResizingTransition() },
            cleanup: { [weak self] in self?.cleanupCrossTransition() })

        // Pseudo cross-dissolve.
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: d / 2,
            delay: 0,
            options: [],
            animations: { [weak self] in self?.layoutNewContentPresentation() },
            completion: nil)
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: d / 2,
            delay: 0,
            options: [],
            animations: { [weak self] in self?.layoutOldContentDismission() },
            completion: nil)
    }
    func spawnRunningContext() -> RunningContext {
        precondition(animc.isRunning == false)
        return RunningContext(
            config: config,
            fillViewController: fillViewController,
            viewPair: newViewPair,
            contentConstraints: newContentConstraints)
    }

    private let config: OverlayConfig
    private let animc = AnimationController()
    private let fillViewController: FillViewController
    private let container: UIView
    private let oldContent: UIView
    private let newContent: UIView
    private var oldContentConstraints: ContentConstraintPalette
    private var newContentConstraints: ContentConstraintPalette

    private var oldViewPair: ViewPair {
        return ViewPair(container: container, content: oldContent)
    }
    private var newViewPair: ViewPair {
        return ViewPair(container: container, content: newContent)
    }
    private func delta() -> CGFloat {
        let oh = oldContentConstraints.sizeAtInstallation?.height ?? 0
        let nh = newContentConstraints.sizeAtInstallation?.height ?? 0
        return nh - oh
    }
    private func prepareCrossTransition() {
        container.addSubview(newContent)
        oldContentConstraints.setContentDisplacement(to: 0)
        newContentConstraints.installConstraints(newViewPair)
        newContentConstraints.setContentDisplacement(to: +delta())
        newContent.alpha = 0
        container.layoutIfNeeded()
    }
    private func layoutNewContentPresentation() {
        newContent.alpha = 1
    }
    private func layoutOldContentDismission() {
        oldContent.alpha = 0
    }
    private func layoutResizingTransition() {
        oldContentConstraints.setContentDisplacement(to: -delta())
        newContentConstraints.setContentDisplacement(to: 0)
        let fctx = newContentConstraints.fillingContext(displacement: 0)
        fillViewController.layoutCrossTransition(context: fctx)
        container.layoutIfNeeded()
    }
    private func cleanupCrossTransition() {
        oldContentConstraints.deinstallConstraints(oldViewPair)
        oldContent.removeFromSuperview()
        oldContent.alpha = 1
        container.layoutIfNeeded()
        note?()
    }
}
