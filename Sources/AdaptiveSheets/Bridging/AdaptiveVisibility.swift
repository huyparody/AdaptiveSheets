//
//  AdaptiveVisibility.swift
//  AdaptiveSheets
//
//  Created by Huy Trinh Duc on 25/3/25.
//

import UIKit
import SwiftUI

@frozen public enum AdaptiveVisibility: Hashable, CaseIterable {
    case visible
    case hidden
    
    var toVisibility: Visibility {
        switch self {
        case .visible:
            return .visible
        case .hidden:
            return .hidden
        }
    }
    
    var toBool: Bool {
        switch self {
        case .visible:
            return true
        case .hidden:
            return false
        }
    }
}
