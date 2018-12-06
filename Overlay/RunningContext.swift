//
//  RunningContext.swift
//  Overlay
//
//  Created by Henry on 2018/11/30.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

final class RunningContext {
    var note: ((OverlayNote) -> Void)?

    init(config x: OverlayConfig, fillViewController fvc: FillViewController, viewPair vp: ViewPair, contentConstraints ccs: ContentConstraintPalette) {
        config = x
        fillViewController = fvc
        viewPair = vp
        contentConstraints = ccs

        tapWaitingView.translatesAutoresizingMaskIntoConstraints = false
        tapWaitingView.note = { [weak self] in self?.note?(.dismiss) }

        panGesture.addTarget(panProxy, action: #selector(OBJCProxy.handle))
        panProxy.note = { [weak self] in self?.processPan() }
    }
    func getViewPair() -> ViewPair {
        return viewPair
    }
    func installInteractions() {
        viewPair.container.insertSubview(tapWaitingView, belowSubview: viewPair.content)
        tapWaitingView.constrainToFillContainer()
        viewPair.content.addGestureRecognizer(panGesture)
        viewPair.container.resignFirstResponder()
        viewPair.content.becomeFirstResponder()
        areInteractionsInstalled = true
    }
    func deinstallInteractions() {
        areInteractionsInstalled = false
        viewPair.content.resignFirstResponder()
        viewPair.container.becomeFirstResponder()
        viewPair.content.removeGestureRecognizer(panGesture)
        NSLayoutConstraint.deactivate(tapWaitingView.constraints)
        tapWaitingView.removeFromSuperview()
    }

    func isCrossTransition(to newState: OverlayState) -> Bool {
        let oldp = viewPair
        guard let newp = newState.getPair() else { return false }
        guard newp.container === oldp.container else { return false }
        return true
    }
    ///
    /// - Returns:
    ///     `nil` if cross transition is impossible or inappropriate.
    ///
    func spawnDismissionOnewayTransitionController(to newState: OverlayState) -> OnewayTransitionController? {
        let oldp = viewPair
        guard oldp.container !== newState.container || oldp.content !== newState.content else { return nil }
        return OnewayTransitionController(
            config: config,
            fillViewController: fillViewController,
            viewPair: viewPair,
            contentConstraints: contentConstraints)
    }
    ///
    /// - Returns:
    ///     `nil` if cross transition is impossible or inappropriate.
    ///
    func spawnCrossTransitionController(to newState: OverlayState) -> CrossTransitionController? {
        let oldp = viewPair
        guard oldp.container !== newState.container || oldp.content !== newState.content else { return nil }
        guard let newp = newState.getPair() else { return nil }
        guard newp.container === oldp.container else { return nil }
        let oldccs = contentConstraints
        return CrossTransitionController(
            config: config,
            fillViewController: fillViewController,
            container: viewPair.container,
            oldContent: viewPair.content,
            newContent: newp.content,
            oldContentConstraints: oldccs)
    }

    ////

    private let config: OverlayConfig
    private let animc = AnimationController()
    private let fillViewController: FillViewController
    private let viewPair: ViewPair
    private let tapWaitingView = TapWaitingView()
    private var contentConstraints: ContentConstraintPalette

    private let panGesture = UIPanGestureRecognizer()
    private let panProxy = OBJCProxy()
    private var areInteractionsInstalled = false

    private func processPan() {
        switch panGesture.state {
        case .began:
            panGesture.setTranslation(.zero, in: viewPair.container)
        case .changed:
            let c = config.draggingDistanceLimit
            let dt = panGesture.translation(in: viewPair.container)
            let d = dt.y < 0 ? -dim(limit: c)(-dt.y) : dim(limit: c)(dt.y)
            layoutContentDisplacement(to: d)
            if d >= config.draggingDistanceForDismission {
                note?(.dismiss)
            }

            let v = panGesture.velocity(in: viewPair.container)
            if v.y >= config.draggingVelocityForDismission {
                note?(.dismiss)
            }

        case .ended:
            animc.run(
                prepare: {},
                layout:  { [weak self] in self?.layoutContentDisplacement(to: 0) },
                cleanup: {})

        case .cancelled, .failed:
            // If overlay content is getting dismissed by end-user interaction,
            // it'll ultimately cause removing of gesture recognizers, and
            // triggers cancellation of current gesture recognition.
            // In that case, it's better not to perform restoring animation.
            // Therefore, I do nothing on cancellation.
            break
        case .possible:
            break
        }
    }
    private func layoutContentDisplacement(to d: CGFloat) {
        contentConstraints.setContentDisplacement(to: d)
        fillViewController.layoutContentDisplacement(d)
        viewPair.container.layoutIfNeeded()
    }
}

private func dim(limit c: CGFloat) -> (_: CGFloat) -> CGFloat {
    return { s in
        let d = c * 2
        return d - exp(-(s) / d) * d
    }
}

private final class TapWaitingView: UIView {
    var note: (() -> Void)?
    private let tap = UITapGestureRecognizer()
    private func install() {
        addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(processUserTap))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        install()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        install()
    }
    @objc
    func processUserTap(_ sender: UITapGestureRecognizer) {
        note?()
    }
}
