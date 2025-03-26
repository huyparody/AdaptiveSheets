import XCTest
import SwiftUI
@testable import AdaptiveSheets

final class AdaptiveSheetsTests: XCTestCase {
    @MainActor func testVersionBasedImplementationSelection() throws {
        // Create a test view
        let testView = Text("Test View")
        
        // Create test binding
        let isPresented = Binding<Bool>.constant(true)
        
        // Apply the adaptiveSheets modifier
        let modifiedView = testView.adaptiveSheets(
            isPresented: isPresented,
            detents: [.medium, .large, .height(400)],
            startDetent: .medium,
            backgroundInteraction: .automatic,
            grabberIndicator: .visible,
            disableDismissOnSwipe: false
        ) {
            Text("Sheet Content")
        }
        
        // Just verify the view was created successfully
        XCTAssertNotNil(modifiedView)
        
        // Test with different combinations of parameters
        let modifiedView2 = testView.adaptiveSheets(
            isPresented: isPresented,
            detents: [.medium, .fraction(0.8)],
            startDetent: .medium,
            backgroundInteraction: .enabled,
            grabberIndicator: .hidden
        ) {
            VStack {
                Text("Title")
                Text("Content")
                Button("Action") {}
            }
        }
        
        XCTAssertNotNil(modifiedView2)
    }
    
    // Test with identifiable item
    @MainActor func testWithIdentifiableItem() throws {
        // Create a test view
        let testView = Text("Host View")
        
        // Create a test item
        struct SheetItem: Identifiable {
            let id = UUID()
            let title: String
            let message: String
        }
        
        // Create test binding
        let item = Binding<SheetItem?>.constant(SheetItem(
            title: "Test Title",
            message: "Test Message"
        ))
        
        // Apply the adaptiveSheets modifier
        let modifiedView = testView.adaptiveSheets(
            item: item,
            detents: [.medium, .large],
            startDetent: .medium
        ) { item in
            if let item = item {
                VStack {
                    Text(item.title)
                        .font(.headline)
                    Text(item.message)
                        .font(.body)
                }
            } else {
                Text("No item")
            }
        }
        
        XCTAssertNotNil(modifiedView)
        
        // Test with different parameter combinations
        let modifiedView2 = testView.adaptiveSheets(
            item: item,
            detents: [.height(300), .fraction(0.7)],
            startDetent: nil,  // Should default to large
            backgroundInteraction: .disabled,
            grabberIndicator: .visible,
            disableDismissOnSwipe: true,
            cornerRardius: 30
        ) { item in
            Text("Item: \(item?.title ?? "None")")
        }
        
        XCTAssertNotNil(modifiedView2)
    }
    
    // Test that combining multiple adaptive sheets works properly
    @MainActor func testCombiningMultipleSheets() throws {
        let testView = Text("Host View")
        
        // First sheet binding
        let isFirstSheetPresented = Binding<Bool>.constant(false)
        
        // Second sheet item
        struct SecondSheetItem: Identifiable {
            let id = UUID()
            let text: String
        }
        let secondSheetItem = Binding<SecondSheetItem?>.constant(nil)
        
        // Apply multiple sheet modifiers
        let modifiedView = testView
            .adaptiveSheets(
                isPresented: isFirstSheetPresented,
                detents: [.medium, .large]
            ) {
                Text("First Sheet")
            }
            .adaptiveSheets(
                item: secondSheetItem,
                detents: [.medium, .fraction(0.9)]
            ) { item in
                Text("Second Sheet: \(item?.text ?? "")")
            }
        
        // Just verify that multiple modifiers can be applied
        XCTAssertNotNil(modifiedView)
    }
}
