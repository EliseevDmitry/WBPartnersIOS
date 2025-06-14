//
//  ProductCardView.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .top, spacing: 15){
                
                RemoteImage(url: product.thumbnail, contentMode: .fit)
                        .frame(width: 84, height: 116)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.wbColor.background, lineWidth: 1)
                        )
                    
                
                VStack(alignment: .leading){
                    Text(product.category)
                    Text(product.title)
                    Text(product.id)
                    Text(product.wbId)
                    Text("\(product.discountedPrice)")
                }
                Spacer()
                Button{
                    
                } label: {
                    Image(.morehorizontal)
                }
                .padding(8)
                .background(Color.wbColor.background)
                .clipShape(.rect(cornerRadius: 5))
            }
            .frame(height: 152)
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .padding(.horizontal)
            PriceSummaryView(text: "Цена продовца до скидки", priceDetails: product.price)
            PriceSummaryView(text: "Скидка продовца", priceDetails: product.discountPercentage)
            PriceSummaryView(text: "цена со скидкой", priceDetails: product.discountedPrice)
            //Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
        .background(Color.blue)
        .onAppear{
            print(product)
        }
    }
}

#Preview {
    ProductCardView(product: MocData.testProduct)
}
