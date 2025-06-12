//
//  ContentView.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

struct ContentView: View {
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
            .navigationTitle(title(for: router.currentRoute))
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .products:
            ProductsView()
        case .pricesAndDiscounts:
            PricesAndDiscountsView(loadingState: .constant(.empty))
        }
    }
    
    private func title(for route: AppRoute?) -> String {
        switch route {
        case .products:
            return "Товары"
        case .pricesAndDiscounts:
            return "Цены и скидки"
        case .none:
            return "Главная"
        }
    }
}

//#Preview {
//    ContentView()
//}
