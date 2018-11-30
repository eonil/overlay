//
//  Overlay.swift
//  Overlay
//
//  Created by Henry on 2018/11/29.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

///
/// This performs asynchronous present/dismiss of content view.
/// You can order `render`ing at any time, but rendering command
/// will be deferred until any present/dismiss animation finishes.
///
/// If you push multiple states quickly in animation, only last state will
/// survice. Any intermediate state will be ignored.
///
/// Presented content view can be dragged or swiped to dismiss itself.
/// This controller attaches gesture recognizers on content view to do this.
///
/// - If dragged up, the content view will be resized.
/// - **Your content view SHOULD allow and be prepared temporal size growth.**
/// - If dragged down, the content view will be translated.
/// - If it's been dragged over specific line, this controller
///   will dismiss the content view.
///
public final class Overlay {
    public enum Control {
        case config(Config)
        case render(State)
    }
    public typealias Config = OverlayConfig
    public typealias State = OverlayState

    public init() {
    }
    public func control(_ c: Control) {
        switch c {
        case .config(let c):
            config = c
            step()
        case .render(let s):
            queue = s
            step()
        }
    }
    public var note: ((OverlayNote) -> Void)?

    ////

    private var config = Config()
    private var execs = ExecutionState.none
    private var queue: State?

    ///
    /// This method manages state transitions between states.
    ///
    private func step() {
        switch execs {
        case .none:
            let newState = queue
            queue = nil
            guard let newp = newState?.getPair() else { break }
            let fvc = FillViewController(contaier: newp.container, config: config)
            let ccs = ContentConstraintPalette()
            let tc = OnewayTransitionController(
                config: config,
                fillViewController: fvc,
                viewPair: newp,
                contentConstraints: ccs)
            tc.note = { [weak self] in self?.step() }
            tc.runPresentationAnimation()
            execs = .present(tc)

        case .present(let tc):
            // Wait until animation finishes.
            guard !tc.isAnimating else { break }
            let rc = tc.spawnRunningContext()
            rc.note = { [weak self] m in self?.processRunningContextNote(m) }
            execs = .running(rc)
            rc.installInteractions()

        case .dismiss(let tc):
            // Wait until animation finishes.
            guard !tc.isAnimating else { break }
            execs = .none
            step()

        case .cross(let tc):
            // Wait until animation finishes.
            guard !tc.isAnimating else { break }
            let rc = tc.spawnRunningContext()
            rc.note = { [weak self] m in self?.processRunningContextNote(m) }
            execs = .running(rc)
            rc.installInteractions()

        case .running(let rc):
            guard let newState = queue else { break }
            queue = nil
            if config.crossTransitionStyle == .resizingAndAlphaBlending, let tc = rc.spawnCrossTransitionController(to: newState) {
                // Perform cross-transition.
                rc.deinstallInteractions()
                tc.note = { [weak self] in self?.step() }
                tc.runTransitionAnimation()
                execs = .cross(tc)
                break
            }
            // Perform oneway-transition. (dismiss)
            if let tc = rc.spawnDismissionOnewayTransitionController(to: newState) {
                rc.deinstallInteractions()
                tc.note = { [weak self] in self?.step() }
                tc.runDismissionAnimation()
                execs = .dismiss(tc)

                // Queue again. If there was a new content, it'll be executed.
                queue = newState
            }
        }
    }

    private func processRunningContextNote(_ m: OverlayNote) {
        if config.automaticallyDismissByEndUserInteraction {
            switch execs {
            case .running(let rc):
                let vp = rc.getViewPair()
                let s = OverlayState(container: vp.container, content: nil)
                control(.render(s))
            default:
                break
            }
        }
        note?(.dismiss)
    }
}

private enum ExecutionState {
    /// Nothing is presented, and no working.
    case none
    /// Oneway transition is in progress.
    case present(OnewayTransitionController)
    /// Oneway transition is in progress.
    case dismiss(OnewayTransitionController)
    /// Cross transition is in progress.
    case cross(CrossTransitionController)
    /// An overlay content view has been presented.
    /// Also can perform end-user interaction.
    case running(RunningContext)
}


