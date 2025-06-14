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
        VStack{
            HStack(alignment: .top, spacing: 15){
                AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 84, height: 116)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.wbColor.background, lineWidth: 1)
                        )
                    
                } placeholder: {
                    ProgressView()
                }
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
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
        .background(Color.gray)
        .onAppear{
            print(product)
        }
    }
}

#Preview {
    ProductCardView(product: MocData.testProduct)
}
