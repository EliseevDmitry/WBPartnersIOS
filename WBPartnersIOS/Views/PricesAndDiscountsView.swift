//
//  PricesAndDiscountsView.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

enum StatePricesView {
    case error, loading, empty
    
    var imageName: String? {
        switch self {
        case .error:
            "illustration-circle-error"
        case .empty:
            "illustration-flashlight-guide"
        case .loading:
            nil
        }
    }
}


struct PricesAndDiscountsView: View {
    @EnvironmentObject var router: Router
    @Binding var loadingState: StatePricesView
    
    @State private var isAnimating = false
    var body: some View {
        VStack {
            Color.wbColor.background
                .overlay {
                    VStack {
                        switch loadingState {
                        case .error:
                            errorStateView
                        case .loading:
                            loadingStateView
                        case .empty:
                            emptyStateView
                        }
                    }
                }
        }
    }
    
    private var loadingStateView: some View {
        LoadingCircleView(isAnimating: $isAnimating)
    }
    
    private var emptyStateView: some View {
        Group {
            if let name = loadingState.imageName {
                Image(name)
            }
            Text("Ничего не найдено")
        }
    }
    
    private var errorStateView: some View {
        Group {
            if let name = loadingState.imageName {
                Image(name)
            }
            Text("Что то пошло не так")
                .font(.titleABeeZeeRegular())
                .foregroundStyle(Color.wbColor.text)
            Text("Попробуйте позднее")
                .font(.titleABeeZeeRegular())
                .foregroundStyle(Color.wbColor.textPrimary)
            Button {
                router.push(.products)
            } label: {
                HStack {
                    Image(.refreshicon)
                    Text("Обновить")
                        .tint(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.wbColor.buttons)
            .clipShape(.rect(cornerRadius: 10))
        }
    }
}



#Preview {
    NavigationView(content: {
        PricesAndDiscountsView(loadingState: .constant(.empty))
    })
}
