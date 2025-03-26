//
//  AdaptivePresetationBackgroundInteraction.swift
//  AdaptiveSheets
//
//  Created by Huy Trinh Duc on 25/3/25.
//

import Foundation
import SwiftUI

public struct AdaptivePresetationBackgroundInteraction: Equatable, Hashable, Sendable {
    /// Defines the type of interaction allowed with the background when a sheet is presented.
    enum InteractionType: Equatable, Hashable, Sendable {
        /// Uses the system's default behavior.
        case automatic
        /// Allows interaction with the background for all detent sizes.
        case enabled
        /// Allows interaction with the background only up to the specified detent.
        case enabledUpThrough(AdaptiveDetents)
        /// Prevents interaction with the background when a sheet is presented.
        case disabled
    }
    
    let type: InteractionType
    
    /// Uses the system's default behavior for background interaction.
    public static let automatic = AdaptivePresetationBackgroundInteraction(type: .automatic)
    
    /// Allows interaction with the background content regardless of the sheet's position.
    public static let enabled = AdaptivePresetationBackgroundInteraction(type: .enabled)
    
    /// Allows interaction with the background only when the sheet is at or below the specified detent.
    /// - Parameter detents: The maximum detent where background interaction is still enabled.
    /// - Returns: An interaction configuration with the specified behavior.
    public static func enabledUpThrough(_ detents: AdaptiveDetents) -> AdaptivePresetationBackgroundInteraction {
        .init(type: .enabledUpThrough(detents))
    }
    
    /// Prevents any interaction with the background when a sheet is presented.
    public static let disabled = AdaptivePresetationBackgroundInteraction(type: .disabled)
}

extension AdaptivePresetationBackgroundInteraction {
    
    /// Converts this adaptive background interaction to the equivalent SwiftUI PresentationBackgroundInteraction.
    /// - Returns: The corresponding SwiftUI presentation background interaction.
    @available(iOS 16.4, *)
    var toSwiftUIInteraction: PresentationBackgroundInteraction {
        switch type {
        case .automatic:
            return .automatic
        case .enabled:
            return .enabled
        case .enabledUpThrough(let detent):
            return .enabled(upThrough: detent.toSwiftUIPresentationDetent)
        case .disabled:
            return .disabled
        }
    }
    
    /// Converts this adaptive background interaction to the equivalent UIKit largest detent identifier.
    /// - Returns: The UIKit detent identifier up to which background interaction is enabled, or nil for automatic/disabled.
    var toUIKitLargestDetent: UISheetPresentationController.Detent.Identifier? {
        switch type {
        case .automatic, .disabled:
            return nil
        case .enabled:
            return .large
        case .enabledUpThrough(let detent):
            return detent.toUIKitPresentationDetentIdentifier
        }
    }
}
