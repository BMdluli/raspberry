//
//  CircularProgressView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/17.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let colour: String

    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(
                    Color.gray.opacity(0.5),
                    lineWidth: 30
                )

            // Progress Circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color(colour),
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90)) // Start at the top
                .animation(.easeOut(duration: 1.0), value: progress) // Smooth animation
        }
        .accessibilityElement(children: .ignore) // For better accessibility
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(progress * 100))% complete")
    }
}


#Preview {
    CircularProgressView(progress: 0.5, colour: "PrimaryOrange")
}
