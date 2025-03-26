//
//  AdaptiveDetents.swift
//  AdaptiveSheets
//
//  Created by Huy Trinh Duc on 25/3/25.
//

import SwiftUI
import UIKit
import AdaptiveSheetsPrivateDetent

public struct AdaptiveDetents: Equatable, Hashable, Sendable {
    
    enum DetentTypes: Equatable, Hashable {
        /// Medium-sized detent (approximately half the screen)
        case medium
        /// Large-sized detent (full screen)
        case large
        /// Detent sized as a fraction of the screen height
        case fraction(CGFloat)
        /// Detent with a fixed height in points
        case height(CGFloat)
    }
    
    private let type: DetentTypes
    
    /// Standard medium-sized detent (approximately half the screen)
    public static let medium = AdaptiveDetents(type: .medium)
    
    /// Full-screen detent
    public static let large = AdaptiveDetents(type: .large)
    
    /// Creates a detent sized as a fraction of the screen height
    /// - Parameter fraction: Value between 0 and 1 representing the portion of the screen height
    /// - Returns: An adaptive detent with the specified fraction
    public static func fraction(_ fraction: CGFloat) -> AdaptiveDetents {
        AdaptiveDetents(type: .fraction(fraction))
    }
    
    /// Creates a detent with a fixed height in points
    /// - Parameter height: The height in points
    /// - Returns: An adaptive detent with the specified height
    public static func height(_ height: CGFloat) -> AdaptiveDetents {
        AdaptiveDetents(type: .height(height))
    }
}

extension AdaptiveDetents {
    /// Converts to SwiftUI's native PresentationDetent type
    @available(iOS 16.0, *)
    var toSwiftUIPresentationDetent: PresentationDetent {
        switch type {
        case .medium:
            return .medium
        case .large:
            return .large
        case .fraction(let fraction):
            return .fraction(fraction)
        case .height(let height):
            return .height(height)
        }
    }
    
    /// Converts to UIKit's presentation detent identifier
    var toUIKitPresentationDetentIdentifier: UISheetPresentationController.Detent.Identifier {
        switch type {
        case .medium:
            return .medium
        case .large:
            return .large
        case .fraction:
            return .fraction
        case .height:
            return .height
        }
    }
    
    /// Converts to UIKit's presentation detent
    @MainActor
    var toUIKitPresentationDetent: UISheetPresentationController.Detent {
        switch type {
        case .medium:
            return .medium()
        case .large:
            return .large()
        case .fraction(let fraction):
            return .fraction(fraction)
        case .height(let height):
            return .height(height)
        }
    }
}

// MARK: - UIKit Detents Extensions

extension UISheetPresentationController.Detent.Identifier {
    /// Custom identifier for height-based detents
    public static let height: UISheetPresentationController.Detent.Identifier = .init("height")
    /// Custom identifier for fraction-based detents
    public static let fraction: UISheetPresentationController.Detent.Identifier = .init(rawValue: "fraction")
}

extension UISheetPresentationController.Detent {
    /// Creates a detent with a fixed height in points
    /// - Parameter height: The height in points
    /// - Returns: A UIKit detent with the specified height
    public static func height(_ height: CGFloat) -> UISheetPresentationController.Detent {
        if #available(iOS 16.0, *) {
            return .custom(identifier: .height) { context in
                return height
            }
        } else {
            return ._detent(
                withIdentifier: UISheetPresentationController.Detent.Identifier.height.rawValue,
                constant: height
            )
        }
    }
    
    /// Creates a detent sized as a fraction of the screen height
    /// - Parameter fraction: Value between 0 and 1 representing the portion of the screen height
    /// - Returns: A UIKit detent with the specified fraction of screen height
    public static func fraction(_ fraction: CGFloat) -> UISheetPresentationController.Detent {
        if #available(iOS 16.0, *) {
            return .custom(identifier: .fraction) { context in
                return context.maximumDetentValue * fraction
            }
        } else {
            return ._detent(
                withIdentifier: UISheetPresentationController.Detent.Identifier.fraction.rawValue,
                constant: UIScreen.main.bounds.height * fraction
            )
        }
    }
}
