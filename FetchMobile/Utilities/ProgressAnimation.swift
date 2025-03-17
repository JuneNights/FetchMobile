//
//  ProgressAnimation.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

import SwiftUI

struct ProgressAnimation: View {
    let foreground: Color
    let background: Color
    @Binding var progressText: String
    @Binding var progress: Double
    @State private var animatedProgress: Double = 0 // Smooth animated progress

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Spacer()
                    ProgressView(progressText, value: animatedProgress, total: 100)
                        .tint(foreground)
                        .accentColor(foreground)
                        .padding(.horizontal, 25)
                        .padding(.top, 25)
                    
                    HStack {
                        Text("\(Int(animatedProgress))%")
                            .font(.system(size: 20, weight: .bold, design: .default))
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .onChange(of: progress) { newValue in
                    animateProgress(to: newValue)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(foreground)
        .background(background)
    }

    // Smooth animation function
    private func animateProgress(to target: Double) {
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if abs(animatedProgress - target) < 1 {
                animatedProgress = target
                timer.invalidate()
            } else {
                withAnimation(.easeOut(duration: 0.1)) {
                    animatedProgress += (target - animatedProgress) * 0.1
                }
            }
        }
    }
}
