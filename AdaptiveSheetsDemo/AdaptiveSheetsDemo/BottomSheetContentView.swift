//
//  BottomSheetContentView.swift
//  AdaptiveSheetsDemo
//
//  Created by Huy Trinh Duc on 25/3/25.
//

import SwiftUI

struct BottomSheetContentView: View {
    var body: some View {
        VStack(spacing: 18) {
            Text("Hello sheets")
            
            List(0..<50, id: \.self) { index in
                Text("\(index)")
            }
            .listStyle(.plain)
        }
        .padding(.top, 20)
    }
}

#Preview {
    BottomSheetContentView()
}
