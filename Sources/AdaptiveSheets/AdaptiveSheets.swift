// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import UIKit

extension View {
    /// A view modifier that presents an adaptive sheet when a binding to an optional item is non-nil.
    /// - Parameters:
    ///   - item: The optional item that presents the sheet when non-nil.
    ///   - detents: The set of possible heights where a sheet can rest.
    ///   - startDetent: The initial detent where the sheet should be presented (defaults to large if nil).
    ///   - backgroundInteraction: Controls how the user can interact with the content behind the sheet.
    ///   - grabberIndicator: Controls the visibility of the grabber indicator at the top of the sheet.
    ///   - disableDismissOnSwipe: When true, prevents dismissal when swiping down on the sheet.
    ///   - cornerRardius: The corner radius applied to the sheet.
    ///   - onDismiss: Closure executed when the sheet is dismissed.
    ///   - bottomSheetcontent: Content builder that creates the view to be presented in the sheet.
    /// - Returns: A view with an adaptive sheet presentation.
    @ViewBuilder public func adaptiveSheets<Content: View, Item: Identifiable>(
        item: Binding<Item?>,
        detents: [AdaptiveDetents],
        startDetent: AdaptiveDetents? = nil,
        backgroundInteraction: AdaptivePresetationBackgroundInteraction = .automatic,
        grabberIndicator: AdaptiveVisibility = .visible,
        disableDismissOnSwipe: Bool = false,
        cornerRardius: CGFloat = 20,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder bottomSheetcontent: @escaping (Item?) -> Content
    ) -> some View {
        if #available(iOS 16.4, *) {
            self
                .sheet(item: item, onDismiss: onDismiss) { item in
                    bottomSheetcontent(item)
                        .presentationDetents(Set(detents.map({$0.toSwiftUIPresentationDetent})),
                                             selection: .constant(startDetent != nil ? startDetent!.toSwiftUIPresentationDetent : .large))
                        .presentationBackgroundInteraction(backgroundInteraction.toSwiftUIInteraction)
                        .presentationCornerRadius(cornerRardius)
                        .presentationDragIndicator(grabberIndicator.toVisibility)
                        .interactiveDismissDisabled(disableDismissOnSwipe)
                }
        }
        else {
            self
                .uiKitSheet(
                    item: item,
                    content: bottomSheetcontent,
                    backgroundInteract: backgroundInteraction,
                    grabberIndicator: grabberIndicator,
                    startDetent: startDetent,
                    detents: detents,
                    disableDismissOnSwipe: disableDismissOnSwipe,
                    cornerRadius: cornerRardius,
                    onDismiss: onDismiss
                )
        }
        
    }
    
    /// A view modifier that presents an adaptive sheet when a binding to a boolean value becomes true.
    /// - Parameters:
    ///   - isPresented: Binding that controls whether the sheet is presented.
    ///   - detents: The set of possible heights where a sheet can rest.
    ///   - startDetent: The initial detent where the sheet should be presented (defaults to large if nil).
    ///   - backgroundInteraction: Controls how the user can interact with the content behind the sheet.
    ///   - grabberIndicator: Controls the visibility of the grabber indicator at the top of the sheet.
    ///   - disableDismissOnSwipe: When true, prevents dismissal when swiping down on the sheet.
    ///   - cornerRardius: The corner radius applied to the sheet.
    ///   - onDismiss: Closure executed when the sheet is dismissed.
    ///   - bottomSheetcontent: Content builder that creates the view to be presented in the sheet.
    /// - Returns: A view with an adaptive sheet presentation.
    @ViewBuilder public func adaptiveSheets<Content: View>(
        isPresented: Binding<Bool>,
        detents: [AdaptiveDetents],
        startDetent: AdaptiveDetents? = nil,
        backgroundInteraction: AdaptivePresetationBackgroundInteraction = .automatic,
        grabberIndicator: AdaptiveVisibility = .visible,
        disableDismissOnSwipe: Bool = false,
        cornerRardius: CGFloat = 20,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder bottomSheetcontent: @escaping () -> Content
    ) -> some View {
        if #available(iOS 16.4, *) {
            self
                .sheet(isPresented: isPresented, onDismiss: onDismiss) {
                    bottomSheetcontent()
                        .presentationDetents(Set(detents.map({$0.toSwiftUIPresentationDetent})),
                                             selection: .constant(startDetent != nil ? startDetent!.toSwiftUIPresentationDetent : .large))
                        .presentationBackgroundInteraction(backgroundInteraction.toSwiftUIInteraction)
                        .presentationCornerRadius(cornerRardius)
                        .presentationDragIndicator(grabberIndicator.toVisibility)
                        .interactiveDismissDisabled(disableDismissOnSwipe)
                }
        }
        else {
            self
                .uiKitSheet(
                    isPresented: isPresented,
                    content: bottomSheetcontent,
                    backgroundInteract: backgroundInteraction,
                    grabberIndicator: grabberIndicator,
                    startDetent: startDetent,
                    detents: detents,
                    disableDismissOnSwipe: disableDismissOnSwipe,
                    cornerRadius: cornerRardius,
                    onDismiss: onDismiss
                )
        }
        
    }
}
