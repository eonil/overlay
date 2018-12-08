//
//  OverlayConfig.swift
//  Overlay
//
//  Created by Henry on 2018/11/30.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

///
/// Provides declarative configuration of `Overlay`.
///
public struct OverlayConfig {
    public var onewayTransitionDuration = TimeInterval(0.4)
    
    public var crossTransitionDuration = TimeInterval(0.4)
    public var crossTransitionStyle = CrossTransitionStyle.default
    public enum CrossTransitionStyle {
        /// No cross-transition.
        /// Dismisses any existing overlay content and
        /// presents a new overlay content.
        case none
        /// Resizes and performs alpha blending to show
        /// transition smoothly.
        case resizingAndAlphaBlending
        static var `default`: CrossTransitionStyle {
            return .resizingAndAlphaBlending
        }
    }

    /// You can control background filling by providing custom view.
    /// This configuration will be applied on next overlay content presentation.
    public var backgroundFilling = BackgroundFilling.default
    /// All views in this struct willl be controlled by Auto Layout,
    /// and must be resizable to any size.
    public struct BackgroundFilling {
        public var emptySpaceFillingView: (UIView & TransitionProtocol)?
        public var contentBackgroundView: (UIView & TransitionProtocol)?
    }

    /// Dragging gets harder if end-user's overlay content dragged distance approaches to this value.
    public var draggingDistanceLimit = CGFloat(50)
    /// If end-user dragged overlay content distance is larger than this, dismiss note will be sent.
    public var draggingDistanceForDismission = CGFloat(70)
    /// If end-user dragged overlay content velocity is larger than this, dismiss note will be sent.
    public var draggingVelocityForDismission = CGFloat(1000)
    public var automaticallyDismissByEndUserInteraction = true

//    public var contentTopInset = CGFloat(0)

    public init() {}
}

///
/// Presets.
///
public extension OverlayConfig.BackgroundFilling {
    public static var `default`: OverlayConfig.BackgroundFilling {
        return darkBlurFillingWithNoContentBackground
    }
    public static var darkBlurFillingWithNoContentBackground: OverlayConfig.BackgroundFilling {
        return OverlayConfig.BackgroundFilling(
            emptySpaceFillingView: DarkBlurFillingView(),
            contentBackgroundView: nil)
    }
    public static var darkBlurFillingWithDarkSolidContentBackground: OverlayConfig.BackgroundFilling {
        return OverlayConfig.BackgroundFilling(
            emptySpaceFillingView: DarkBlurFillingView(),
            contentBackgroundView: DarkSolidFillingView())
    }
    public static var darkSolidFillingWithDarkBlurContentBackground: OverlayConfig.BackgroundFilling {
        return OverlayConfig.BackgroundFilling(
            emptySpaceFillingView: DarkSolidFillingView(),
            contentBackgroundView: DarkBlurFillingView())
    }
}

private final class DarkSolidFillingView: UIView, TransitionProtocol {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func preparePresentation() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        alpha = 0
    }
    func layoutPresentation() {
        alpha = 1
    }
    func cleanupPresentation() {
    }
    func prepareDismission() {
    }
    func layoutDismission() {
        alpha = 0
    }
    func cleanupDismission() {
    }
}

private final class DarkBlurFillingView: UIVisualEffectView, TransitionProtocol {
    override init(effect: UIVisualEffect?) {
        super.init(effect: nil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func preparePresentation() {
    }
    func layoutPresentation() {
        effect = UIBlurEffect(style: .dark)
    }
    func cleanupPresentation() {
    }
    func prepareDismission() {
    }
    func layoutDismission() {
        effect = nil
    }
    func cleanupDismission() {
    }
}

private extension UIView {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}


