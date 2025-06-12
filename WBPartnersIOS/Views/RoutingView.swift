//
//  ContentView.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

struct RoutingView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationView {
            VStack {
                if let route = router.currentRoute {
                    destinationView(for: route)
                } else {
                    PricesAndDiscountsView(loadingState: .constant(.loading))
                }
            }
            .navigationTitle("Цены и скидки")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if shouldShowBackButton() {
                        Button(action: {
                            router.pop()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
            }
        }
        
    }
    
    @ViewBuilder
        private func destinationView(for route: AppRoute) -> some View {
            switch route {
            case .products:
                ProductsView()
            case .pricesAndDiscounts(let state):
                PricesAndDiscountsView(loadingState: .constant(state))
            }
        }
        
        private func shouldShowBackButton() -> Bool {
            guard let route = router.currentRoute else { return false }
            switch route {
            case .pricesAndDiscounts(let state):
                return state != .error
            default:
                return true
            }
        }
    
    
}
