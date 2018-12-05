//
//  Protocols.swift
//  Overlay
//
//  Created by Henry on 2018/11/30.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

///
/// - Note:
///     Why do you need separation of prepare/layout stage?
///     Because you sometimes need to place your view in position
///     before starting layout.
///
///     Actually it's better if we can perform everything in value based.
///     But some UIKit stuffs -- such as `UIVisualEffectView` -- does not
///     work well with declarative explicit animations. Also it requires
///     significant amount of changes on existing codebase.
///     Therefore, I have to follow this method-call based approach for now.
///
public protocol TransitionProtocol {
    func preparePresentation()
    func layoutPresentation()
    func cleanupPresentation()
    func prepareDismission()
    func layoutDismission()
    func cleanupDismission()
}
public extension TransitionProtocol {
    func preparePresentation() {}
    func layoutPresentation() {}
    func cleanupPresentation() {}
    func prepareDismission() {}
    func layoutDismission() {}
    func cleanupDismission() {}
}

public protocol CrossTransitionProtocol: TransitionProtocol {
    func layoutCrossTransition()
}

public protocol InteractionProtocol {
    /// - Parameter ratio:
    ///     Displacement amount in points that dragged by user.
    func layoutDisplacement(_: CGFloat)
}
public extension InteractionProtocol {
    func layoutDisplacement(_: CGFloat) {}
}

//protocol FillTransitionProtocol {
//    func preparePresentation(context: FillTransitionContext)
//    func layoutPresentation(context: FillTransitionContext)
//    func cleanupPresentation(context: FillTransitionContext)
//    func prepareDismission(context: FillTransitionContext)
//    func layoutDismission(context: FillTransitionContext)
//    func cleanupDismission(context: FillTransitionContext)
//}
//extension FillTransitionProtocol {
//    func preparePresentation(context: FillTransitionContext) {}
//    func layoutPresentation(context: FillTransitionContext) {}
//    func cleanupPresentation(context: FillTransitionContext) {}
//    func prepareDismission(context: FillTransitionContext) {}
//    func layoutDismission(context: FillTransitionContext) {}
//    func cleanupDismission(context: FillTransitionContext) {}
//}
//
//struct FillTransitionContext {
//    var contentSize: CGSize
//}
