# AdaptiveSheets

A Swift package that provides adaptive sheet presentations across iOS versions. This library offers a unified API for displaying sheet presentations with customizable detents (heights) that works on both iOS 16.4+ (using native SwiftUI functionality) and earlier iOS versions (through a UIKit implementation).

## Requirements

- iOS 15.0+
- Swift 6.0+
- Xcode 16+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/huyparody/AdaptiveSheets.git", from: "1.0.0")
]
```

Or add it directly in Xcode:
1. File > Add Packages...
2. Enter the repository URL: `https://github.com/huyparody/AdaptiveSheets.git`
3. Select the version you want to use

## Features

- Compatible with iOS 15.0+
- Unified API across iOS versions
- Multiple detent options (heights):
  - Fractional heights (e.g., 0.5 of screen height)
  - Standard medium and large sizes
  - Custom fixed heights
- Customizable presentation:
  - Background interaction control
  - Grabber indicator visibility
  - Corner radius adjustment
  - Dismissal behavior control
- Support for both boolean and item-based presentations

## Usage

### Basic Usage

```swift
import SwiftUI
import AdaptiveSheets

struct ContentView: View {
    @State private var isShow: Bool = false
    
    var body: some View {
        VStack {
            Button("Show Sheet") {
                isShow.toggle()
            }
        }
        .adaptiveSheets(
            isPresented: $isShow,
            detents: [.fraction(0.5), .medium],
            startDetent: .medium
        ) {
            // Your sheet content here
            Text("Sheet Content")
        }
    }
}
```

### Advanced Usage

```swift
.adaptiveSheets(
    isPresented: $isShow,
    detents: [.fraction(0.99), .medium, .height(200)],
    startDetent: .medium,
    backgroundInteraction: .enabledUpThrough(.height(200)),
    grabberIndicator: .visible,
    disableDismissOnSwipe: false,
    cornerRardius: 20,
    onDismiss: {
        print("Sheet dismissed")
    }
) {
    YourSheetContentView()
}
```

### Item-Based Presentation

```swift
struct Item: Identifiable {
    let id = UUID()
    let title: String
}

struct ContentView: View {
    @State private var selectedItem: Item? = nil
    
    var body: some View {
        Button("Show Sheet") {
            selectedItem = Item(title: "Example")
        }
        .adaptiveSheets(
            item: $selectedItem,
            detents: [.medium, .large]
        ) { item in
            if let item = item {
                Text(item.title)
            }
        }
    }
}
```

## Available Detent Options

- `.medium` - Standard medium height
- `.large` - Standard large height (full sheet)
- `.fraction(CGFloat)` - Fraction of screen height (0.0 to 1.0)
- `.height(CGFloat)` - Fixed height in points

## Demo

The repository includes a demo project that showcases different ways to implement AdaptiveSheets in your SwiftUI application.

## License

AdaptiveSheets is released under an MIT license
