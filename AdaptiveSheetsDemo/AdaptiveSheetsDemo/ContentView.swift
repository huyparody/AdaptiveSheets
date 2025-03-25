//
//  ContentView.swift
//  AdaptiveSheetsDemo
//
//  Created by Huy Trinh Duc on 25/3/25.
//

import SwiftUI
import AdaptiveSheets

struct ContentView: View {
    
    @State private var isShow: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button {
                isShow.toggle()
            } label: {
                Text("Show Sheet")
            }

        }
        .padding()
        .adaptiveSheets(isPresented: $isShow,
                        detents: [.fraction(0.99), .medium, .height(200)],
                        startDetent: .medium,
                        backgroundInteraction: .enabledUpThrough(.height(200))	) {
            BottomSheetContentView()
        }
    }
}

#Preview {
    ContentView()
}
