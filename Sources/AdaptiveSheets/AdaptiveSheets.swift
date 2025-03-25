// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import UIKit

extension View {
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
                    startState: startDetent,
                    detents: detents,
                    disableDismissOnSwipe: disableDismissOnSwipe,
                    cornerRadius: cornerRardius,
                    onDismiss: onDismiss
                )
        }
        
    }
    
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
                    startState: startDetent,
                    detents: detents,
                    disableDismissOnSwipe: disableDismissOnSwipe,
                    cornerRadius: cornerRardius,
                    onDismiss: onDismiss
                )
        }
        
    }
}
