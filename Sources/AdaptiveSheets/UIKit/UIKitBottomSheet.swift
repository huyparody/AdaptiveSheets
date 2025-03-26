// A SwiftUI library for adaptive bottom sheets with UIKit integration
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
    /**
     Presents a UIKit-based bottom sheet when a binding to a Boolean value is true.
     
     - Parameters:
        - isPresented: A binding to a Boolean value that determines whether to present the sheet.
        - content: A closure that returns the content of the sheet.
        - backgroundInteract: Determines whether touches outside the sheet are passed to underlying views.
        - grabberIndicator: Controls the visibility of the grabber handle at the top of the sheet.
        - startDetent: The initial presentation state of the sheet.
        - detents: The possible sizes (heights) at which the sheet can rest.
        - disableDismissOnSwipe: When true, prevents dismissal by swiping down.
        - cornerRadius: The corner radius applied to the sheet.
        - onDismiss: A closure executed when the sheet is dismissed.
     */
    func uiKitSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content,
        backgroundInteract: AdaptivePresetationBackgroundInteraction = .automatic,
        grabberIndicator: AdaptiveVisibility = .visible,
        startDetent: AdaptiveDetents? = .large,
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
                    startDetent: startDetent,
                    detents: detents,
                    cornerRadius: cornerRadius,
                    disableDismissOnSwipe: disableDismissOnSwipe,
                    onDismiss: onDismiss
                )
            )
    }
    
    /**
     Presents a UIKit-based bottom sheet when a binding to an optional item is non-nil.
     
     - Parameters:
        - item: A binding to an optional value that determines whether to present the sheet.
        - content: A closure that returns the content of the sheet based on the item.
        - backgroundInteract: Determines whether touches outside the sheet are passed to underlying views.
        - grabberIndicator: Controls the visibility of the grabber handle at the top of the sheet.
        - startDetent: The initial presentation state of the sheet.
        - detents: The possible sizes (heights) at which the sheet can rest.
        - disableDismissOnSwipe: When true, prevents dismissal by swiping down.
        - cornerRadius: The corner radius applied to the sheet.
        - onDismiss: A closure executed when the sheet is dismissed.
     */
    func uiKitSheet<Item, Content>(
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Item?) -> Content,
        backgroundInteract: AdaptivePresetationBackgroundInteraction = .automatic,
        grabberIndicator: AdaptiveVisibility = .visible,
        startDetent: AdaptiveDetents? = .large,
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
                    startDetent: startDetent,
                    detents: detents,
                    disableDismissOnSwipe: disableDismissOnSwipe,
                    cornerRadius: cornerRadius,
                    onDismiss: onDismiss
                )
            )
    }
}

// MARK: - UIKit Integration Helper Types

/**
 UIViewControllerRepresentable that manages a bottom sheet presentation based on an optional item.
 This helper bridges SwiftUI and UIKit presentation controllers.
 */
struct UIKitSheetItemHelper<Item: Identifiable, Content: View>: UIViewControllerRepresentable {
    var sheetView: Content
    let controller: UIViewController = UIViewController()
    @Binding var item: Item?
    var backgroundInteraction: AdaptivePresetationBackgroundInteraction
    var grabberIndicator: AdaptiveVisibility
    var startDetent: AdaptiveDetents?
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
    
    /**
     Updates the view controller to present or dismiss the sheet based on changes to the item binding.
     */
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if item != nil {
            // Only present if not already presented
            if context.coordinator.currentPresentedController == nil {
                let sheetController = CustomHostingController(
                    rootView: sheetView,
                    backgroundInteraction: backgroundInteraction,
                    grabberIndicator: grabberIndicator,
                    startDetent: startDetent,
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
    
    /**
     Coordinator that handles sheet presentation controller delegate methods
     and maintains state between view updates.
     */
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

/**
 UIViewControllerRepresentable that manages a bottom sheet presentation based on a Boolean binding.
 */
struct UIKitSheetHelper<Content: View>: UIViewControllerRepresentable {
    
    var sheetView: Content
    let controller: UIViewController = UIViewController()
    @Binding var isPresented: Bool
    var backgroundInteraction: AdaptivePresetationBackgroundInteraction
    var grabberIndicator: AdaptiveVisibility
    var startDetent: AdaptiveDetents?
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
    
    /**
     Updates the view controller to present or dismiss the sheet based on changes to the isPresented binding.
     */
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            // Only present if not already presented
            if context.coordinator.currentPresentedController == nil {
                let sheetController = CustomHostingController(
                    rootView: sheetView,
                    backgroundInteraction: backgroundInteraction,
                    grabberIndicator: grabberIndicator,
                    startDetent: startDetent,
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
    
    /**
     Coordinator that handles sheet presentation controller delegate methods
     and maintains state between view updates.
     */
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

/**
 A custom UIHostingController that configures a UISheetPresentationController with
 the specified adaptive sheet parameters.
 */
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
    
    /**
     Configures the presentation controller with the specified sheet parameters
     when the view loads.
     */
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
