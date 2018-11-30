//
//  FillViewController.swift
//  Overlay
//
//  Created by Henry on 2018/11/30.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

final class FillViewController {
    enum Note {
        ///
        /// User taps on anywhere on fill-view.
        ///
        case userTap
    }
    var note: ((Note) -> Void)?

    init(contaier c: UIView, config x: OverlayConfig) {
        Debug.assertAutoLayoutCompatibleView(x.backgroundFilling.emptySpaceFillingView)
        Debug.assertAutoLayoutCompatibleView(x.backgroundFilling.contentBackgroundView)
        container = c
        config = x
    }
    func preparePresentation() {
        // Space filling view will be placed to fill container
        // and does not change its geometry.
        if let spaceFillingView = spaceFillingView {
            container.addSubview(spaceFillingView)
            emptySpaceFillingConstraints = [
                spaceFillingView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                spaceFillingView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                spaceFillingView.topAnchor.constraint(equalTo: container.topAnchor),
                spaceFillingView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            ]
            NSLayoutConstraint.activate(emptySpaceFillingConstraints)
            spaceFillingView.preparePresentation()
        }
        // Content background view will be placed on container
        // and its layout will be controlled by oneway/cross transition controllers.
        if let contentBackgroundView = contentBackgroundView {
            container.addSubview(contentBackgroundView)
            let vp = ViewPair(container: container, content: contentBackgroundView)
            contentBackgroundConstraints.installConstraints(vp)
            contentBackgroundView.preparePresentation()
        }
    }
    func layoutPresentation(context: BackgroundFillingLayoutContext) {
        spaceFillingView?.layoutPresentation()
        contentBackgroundView?.layoutPresentation()
        contentBackgroundConstraints.apply(context: context)
    }
    func cleanupPresentation() {
        spaceFillingView?.cleanupPresentation()
        contentBackgroundView?.cleanupPresentation()
    }

    func layoutCrossTransition(context: BackgroundFillingLayoutContext) {
        contentBackgroundConstraints.apply(context: context)
    }
    func layoutContentDisplacement(_ d: CGFloat) {
        contentBackgroundConstraints.setContentDisplacement(to: d)
    }

    func prepareDismission() {
        spaceFillingView?.prepareDismission()
        contentBackgroundView?.prepareDismission()
    }
    func layoutDismission(context: BackgroundFillingLayoutContext) {
        spaceFillingView?.layoutDismission()
        contentBackgroundView?.layoutDismission()
        contentBackgroundConstraints.apply(context: context)
    }
    func cleanupDismission() {
        spaceFillingView?.cleanupDismission()
        emptySpaceFillingConstraints.removeAll()
        spaceFillingView?.removeFromSuperview()

        if let contentBackgroundView = contentBackgroundView {
            contentBackgroundView.cleanupDismission()
            NSLayoutConstraint.deactivate(emptySpaceFillingConstraints)
            let vp = ViewPair(container: container, content: contentBackgroundView)
            contentBackgroundConstraints.deinstallConstraints(vp)
            contentBackgroundView.removeFromSuperview()
        }
    }

    private let container: UIView
    private let config: OverlayConfig
    private var emptySpaceFillingConstraints = [NSLayoutConstraint]()
    private var contentBackgroundConstraints = ContentConstraintPalette()

    private var spaceFillingView: (UIView & TransitionProtocol)? {
        return config.backgroundFilling.emptySpaceFillingView
    }
    private var contentBackgroundView: (UIView & TransitionProtocol)? {
        return config.backgroundFilling.contentBackgroundView
    }
}

private extension ContentConstraintPalette {
    mutating func apply(context: BackgroundFillingLayoutContext) {
        bottom?.constant = context.contentBottom
        height?.constant = context.contentHeight
        sizeAtInstallation?.height = context.contentHeight
        setContentDisplacement(to: context.contentDisplacement)
    }
}
