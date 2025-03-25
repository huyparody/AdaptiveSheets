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
        case medium
        case large
        case fraction(CGFloat)
        case height(CGFloat)
    }
    
    private let type: DetentTypes
    
    public static let medium = AdaptiveDetents(type: .medium)
    
    public static let large = AdaptiveDetents(type: .large)
    
    public static func fraction(_ fraction: CGFloat) -> AdaptiveDetents {
        AdaptiveDetents(type: .fraction(fraction))
    }
    
    public static func height(_ height: CGFloat) -> AdaptiveDetents {
        AdaptiveDetents(type: .height(height))
    }
}

extension AdaptiveDetents {
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

// UIKit Detents

extension UISheetPresentationController.Detent.Identifier {
    public static let height: UISheetPresentationController.Detent.Identifier = .init("height")
    public static let fraction: UISheetPresentationController.Detent.Identifier = .init(rawValue: "fraction")
}

extension UISheetPresentationController.Detent {
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
