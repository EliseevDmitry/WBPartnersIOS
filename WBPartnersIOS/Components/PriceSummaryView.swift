//
//  PriceSummaryView.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

import SwiftUI

struct PriceSummaryView: View {
    let text: String
    let priceDetails: Double

    var body: some View {
            
        ZStack(alignment: .bottom){
            HStack {
                Text("\(text) ")
                    .background(Color.white)
                Spacer()
                Text(" 100000")
                    .background(Color.white)
            }
            DashesLine()
                .offset(CGSize(width: 0, height: -4))
                .zIndex(-1)
        }
    }
}


struct DashesLine: View {
    @Environment(\.screenWidth) private var screenWidth
    let dashCount = 29
    let gapCount = 28
    let lineHeight: CGFloat = 1
    let cornerRadius: CGFloat = 0.5
    var body: some View {
            let dashWidth = screenWidth / (CGFloat(dashCount) + CGFloat(gapCount) / 2)
            let gapWidth = dashWidth / 2
            
            HStack(spacing: gapWidth) {
                ForEach(0..<dashCount, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .frame(width: dashWidth, height: lineHeight)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    PriceSummaryView(text: "Цена продовца до скидки", priceDetails: 100000)
        .environment(\.screenWidth, 375)
}
