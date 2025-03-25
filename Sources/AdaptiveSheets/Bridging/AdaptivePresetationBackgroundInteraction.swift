//
//  AdaptivePresetationBackgroundInteraction.swift
//  AdaptiveSheets
//
//  Created by Huy Trinh Duc on 25/3/25.
//

import Foundation
import SwiftUI

public struct AdaptivePresetationBackgroundInteraction: Equatable, Hashable, Sendable {
    enum InteractionType: Equatable, Hashable, Sendable {
        case automatic
        case enabled
        case enabledUpThrough(AdaptiveDetents)
        case disabled
    }
    
    let type: InteractionType
    
    public static let automatic = AdaptivePresetationBackgroundInteraction(type: .automatic)
    
    public static let enabled = AdaptivePresetationBackgroundInteraction(type: .enabled)
    
    public static func enabledUpThrough(_ detents: AdaptiveDetents) -> AdaptivePresetationBackgroundInteraction {
        .init(type: .enabledUpThrough(detents))
    }
    
    public static let disabled = AdaptivePresetationBackgroundInteraction(type: .disabled)
}

extension AdaptivePresetationBackgroundInteraction {
    
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
