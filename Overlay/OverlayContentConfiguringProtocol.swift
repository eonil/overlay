//
//  OverlayContentConfiguringProtocol.swift
//  Overlay
//
//  Created by Henry on 2018/12/08.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

///
/// Your content-view can conform this protocol to customize behaviors.
///
/// - Note:
///     This is just an idea. But implementation of this makes code more
///     complex, and I do not want to implement this unless there're many requests.
///
protocol OverlayContentConfiguringProtocol: class {
    /// Default return value is `.none`.
    var overlayContentTopEdgeConstrainStyle: OverlayContentEdgeConstrainStyle { get }
}
extension OverlayContentConfiguringProtocol {
    var overlayContentTopEdgeConstrainStyle: OverlayContentEdgeConstrainStyle {
        return .none
    }
}

enum OverlayContentEdgeConstrainStyle {
    // Do not constrain content edge.
    // Large content view can overflow container view area.
    case none
    // Constrain edge of content view.
    // If content view is too large for the container,
    // it will be reized to fit in the container.
    case space(CGFloat)
}
