//
//  LoadingLineView.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

struct LoadingCircleView: View {
    @Binding var isAnimating: Bool
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.5)
            .stroke(Color.wbColor.buttons, lineWidth: 5)
            .frame(width: 32, height: 32)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(
                Animation.linear(duration: 1)
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    LoadingCircleView(isAnimating: .constant(true))
}
