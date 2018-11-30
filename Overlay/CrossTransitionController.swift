////
////  CrossTransitionController.swift
////  Overlay
////
////  Created by Henry on 2018/11/30.
////  Copyright © 2018 Henry. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//final class CrossTransitionController {
//    var note: (() -> Void)?
//    var isAnimating: Bool {
//        return animc.isRunning
//    }
//
//    init(fillViewController fvc: FillViewController, container c: UIView, oldContent oc: UIView, newContent nc: UIView, oldContentConstraints oldccs: ContentConstraintPalette) {
//        assert(!oc.translatesAutoresizingMaskIntoConstraints)
//        assert(!nc.translatesAutoresizingMaskIntoConstraints)
//        fillViewController = fvc
//        container = c
//        oldContent = oc
//        newContent = nc
//        oldContentConstraints = oldccs
//        newContentConstraints = ContentConstraintPalette()
//    }
//    func runTransitionAnimation() {
//        animc.run(
//            predelay: 0,
//            duration: 0.4,
//            postdelay: 0,
//            prepare: { [weak self] in self?.prepareCrossTransition() },
//            layout:  { [weak self] in self?.layoutCrossTransition() },
//            cleanup: { [weak self] in self?.cleanupCrossTransition() })
//    }
//    func spawnRunningContext() -> RunningContext {
//        precondition(animc.isRunning == false)
//        return RunningContext(
//            fillViewController: fillViewController,
//            viewPair: newViewPair,
//            contentConstraints: newContentConstraints)
//    }
//
//    private let animc = AnimationController()
//    private let fillViewController: FillViewController
//    private let container: UIView
//    private let oldContent: UIView
//    private let newContent: UIView
//    private var oldContentConstraints: ContentConstraintPalette
//    private var newContentConstraints: ContentConstraintPalette
//
//    private var oldViewPair: ViewPair {
//        return ViewPair(container: container, content: oldContent)
//    }
//    private var newViewPair: ViewPair {
//        return ViewPair(container: container, content: newContent)
//    }
//    private func delta() -> CGFloat {
//        let oh = oldContentConstraints.sizeAtInstallation?.height ?? 0
//        let nh = newContentConstraints.sizeAtInstallation?.height ?? 0
//        return nh - oh
//    }
//    private func prepareCrossTransition() {
//        container.addSubview(newContent)
//        oldContentConstraints.setContentDisplacement(to: 0)
//        newContentConstraints.installConstraints(newViewPair)
//        newContentConstraints.bottom?.constant = 0
//        newContentConstraints.setContentDisplacement(to: +delta())
//        newContent.alpha = 0
//        container.layoutIfNeeded()
//    }
//    private func layoutCrossTransition() {
//        oldContentConstraints.setContentDisplacement(to: -delta())
//        newContentConstraints.setContentDisplacement(to: 0)
//        oldContent.alpha = 0
//        newContent.alpha = 1
//        container.layoutIfNeeded()
//    }
//    private func cleanupCrossTransition() {
//        oldContentConstraints.deinstallConstraints(oldViewPair)
//        oldContent.removeFromSuperview()
//        oldContent.alpha = 1
//        note?()
//    }
//}
