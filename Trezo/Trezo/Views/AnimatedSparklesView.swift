//
//  AnimatedCirclesView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/12/31.
//

import SwiftUI

struct AnimatedSparklesView: View {
    @State private var animate = false
    
    let sparklesCount = 10 // Number of sparkles
    let sparkleColors: [Color] = [.yellow, .orange, .white] // Sparkle colors

    var body: some View {
        ZStack {
            // Animated sparkles
            ForEach(0..<sparklesCount, id: \.self) { index in
                Circle()
                    .frame(width: 8, height: 8) // Size of each sparkle
                    .foregroundColor(sparkleColors.randomElement()!) // Random color for each sparkle
                    .offset(x: animate ? CGFloat.random(in: 50...100) : 0,
                            y: animate ? CGFloat.random(in: -100...100) : 0) // Sparkles radiating outward
                    .opacity(animate ? 0 : 1) // Fade out as they move outward
                    .animation(
                        Animation.easeOut(duration: 4)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.1), // Staggered animation start
                        value: animate
                    )
            }
            
            // Center content
            ZStack {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.white)
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)
            }
        }
        .onAppear {
            animate = true // Start animation when the view appears
        }
    }
}

struct AnimatedSparklesView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedSparklesView()
    }
}


#Preview {
    AnimatedSparklesView()
}
