//
//  UIKitBottomSheet.swift
//  AdaptiveSheets
//
//  Created by Huy Trinh Duc on 25/3/25.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    func uiKitSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content,
        backgroundInteract: AdaptivePresetationBackgroundInteraction = .automatic,
        grabberIndicator: AdaptiveVisibility = .visible,
        startState: AdaptiveDetents? = .large,
        detents: [AdaptiveDetents],
        disableDismissOnSwipe: Bool = false,
        cornerRadius: CGFloat,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        return self
            .background(
                UIKitSheetHelper(
                    sheetView: content(),
                    isPresented: isPresented,
                    backgroundInteraction: backgroundInteract,
                    grabberIndicator: grabberIndicator,
                    startState: startState,
                    detents: detents,
                    cornerRadius: cornerRadius,
                    disableDismissOnSwipe: disableDismissOnSwipe,
                    onDismiss: onDismiss
                )
            )
    }
    
    func uiKitSheet<Item, Content>(
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Item?) -> Content,
        backgroundInteract: AdaptivePresetationBackgroundInteraction = .automatic,
        grabberIndicator: AdaptiveVisibility = .visible,
        startState: AdaptiveDetents? = .large,
        detents: [AdaptiveDetents],
        disableDismissOnSwipe: Bool = false,
        cornerRadius: CGFloat,
        onDismiss: (() -> Void)? = nil
    ) -> some View where Item: Identifiable, Content: View {
        return self
            .background(
                UIKitSheetItemHelper(
                    sheetView: content(
                        item.wrappedValue
                    ),
                    item: item,
                    backgroundInteraction: backgroundInteract,
                    grabberIndicator: grabberIndicator,
                    startState: startState,
                    detents: detents,
                    disableDismissOnSwipe: disableDismissOnSwipe,
                    cornerRadius: cornerRadius,
                    onDismiss: onDismiss
                )
            )
    }
}

// UIKit integration

struct UIKitSheetItemHelper<Item: Identifiable, Content: View>: UIViewControllerRepresentable {
    var sheetView: Content
    let controller: UIViewController = UIViewController()
    @Binding var item: Item?
    var backgroundInteraction: AdaptivePresetationBackgroundInteraction
    var grabberIndicator: AdaptiveVisibility
    var startState: AdaptiveDetents?
    var detents: [AdaptiveDetents]
    var disableDismissOnSwipe: Bool
    var cornerRadius: CGFloat
    var onDismiss: (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if item != nil {
            // Only present if not already presented
            if context.coordinator.currentPresentedController == nil {
                let sheetController = CustomHostingController(
                    rootView: sheetView,
                    backgroundInteraction: backgroundInteraction,
                    grabberIndicator: grabberIndicator,
                    startDetent: startState,
                    detents: detents,
                    cornerRadius: cornerRadius
                )
                sheetController.isModalInPresentation = disableDismissOnSwipe
                sheetController.presentationController?.delegate = context.coordinator
                
                // Present the sheet
                uiViewController.present(sheetController, animated: true)
                context.coordinator.currentPresentedController = sheetController
            }
        } else {
            // Dismiss if currently presented
            if context.coordinator.currentPresentedController != nil {
                uiViewController.dismiss(animated: true)
                context.coordinator.currentPresentedController = nil
            }
        }
    }
    
    //on dismiss...
    final class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        
        var parent: UIKitSheetItemHelper
        var currentPresentedController: UIViewController?
        
        init(parent: UIKitSheetItemHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.onDismiss?()
        }
    }
}

struct UIKitSheetHelper<Content: View>: UIViewControllerRepresentable {
    
    var sheetView: Content
    let controller: UIViewController = UIViewController()
    @Binding var isPresented: Bool
    var backgroundInteraction: AdaptivePresetationBackgroundInteraction
    var grabberIndicator: AdaptiveVisibility
    var startState: AdaptiveDetents?
    var detents: [AdaptiveDetents]
    var cornerRadius: CGFloat
    var disableDismissOnSwipe: Bool
    var onDismiss: (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            // Only present if not already presented
            if context.coordinator.currentPresentedController == nil {
                let sheetController = CustomHostingController(
                    rootView: sheetView,
                    backgroundInteraction: backgroundInteraction,
                    grabberIndicator: grabberIndicator,
                    startDetent: startState,
                    detents: detents,
                    cornerRadius: cornerRadius
                )
                sheetController.isModalInPresentation = disableDismissOnSwipe
                sheetController.presentationController?.delegate = context.coordinator
                
                // Present the sheet
                uiViewController.present(sheetController, animated: true)
                context.coordinator.currentPresentedController = sheetController
            }
        } else {
            // Dismiss if currently presented
            if context.coordinator.currentPresentedController != nil {
                uiViewController.dismiss(animated: true)
                context.coordinator.currentPresentedController = nil
            }
        }
    }
    
    //on dismiss...
    final class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        
        var parent: UIKitSheetHelper
        var currentPresentedController: UIViewController?
        
        init(parent: UIKitSheetHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.onDismiss?()
        }
    }
}

final class CustomHostingController<Content: View>: UIHostingController<Content> {
    
    var backgroundInteraction: AdaptivePresetationBackgroundInteraction
    var grabberIndicator: AdaptiveVisibility
    var startDetent: AdaptiveDetents?
    var detents: [AdaptiveDetents]
    var cornerRadius: CGFloat
    
    init(rootView: Content,
         backgroundInteraction: AdaptivePresetationBackgroundInteraction,
         grabberIndicator: AdaptiveVisibility,
         startDetent: AdaptiveDetents?,
         detents: [AdaptiveDetents],
         cornerRadius: CGFloat) {
        self.backgroundInteraction = backgroundInteraction
        self.grabberIndicator = grabberIndicator
        self.startDetent = startDetent
        self.detents = detents
        self.cornerRadius = cornerRadius
        super.init(rootView: rootView)
    }
    
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = detents.map({$0.toUIKitPresentationDetent})
            presentationController.selectedDetentIdentifier = startDetent?.toUIKitPresentationDetentIdentifier
            presentationController.largestUndimmedDetentIdentifier = backgroundInteraction.toUIKitLargestDetent
            presentationController.prefersGrabberVisible = grabberIndicator.toBool
            presentationController.preferredCornerRadius = cornerRadius
        }
    }
}
