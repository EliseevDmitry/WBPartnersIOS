//
//  PricesAndDiscountsView.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI
import Network

enum LocalizePrices: String {
    case notFound = "Ничего не найдено"
    case fail = "Что-то пошло не так"
    case tryLater = "Попробуйте позднее"
    case update = "Обновить"
}

enum StatePricesView {
    case error, loading, empty
    
    var imageName: String? {
        switch self {
        case .error:
            CustomImage.errorView.rawValue
        case .empty:
            CustomImage.emptyView.rawValue
        case .loading:
            nil
        }
    }
}

/*
 Требование: "Интерфейс должен маĸсимально точно соответствовать маĸету"
 Использование - magic numbers - плохая практика, старался не прибегать,
 или минимизировать их использование (сложно было понять термин - маĸсимально точно).
 Теоретически можно было - перенести всю геометрию Figma в текущих размерах в уравнения,
 через GR при старте приложения считать wight и height (конкретного устройства)
 и через систему уравнений - пересчитывать интерфейс (максимальное масштабирование под устройство).
 */

final class PricesAndDiscountsViewModel: ObservableObject {
    
    @Published var isAnimating = false
    
    func isInternetReallyAvailable() async -> Bool {
        await Dependency.shared.internetManager.isInternetReallyAvailable()
    }
    
}

struct PricesAndDiscountsView: View {
    @EnvironmentObject var router: Router
    @Binding var loadingState: StatePricesView
    @StateObject private var viewModel = PricesAndDiscountsViewModel()
    var body: some View {
        VStack {
            Color.wbColor.background
                .overlay {
                    VStack {
                        /*
                         решение аппроксимированного центра экрана без без вычислений GR
                         без .offset(y:)
                         */
                        Spacer()
                        Spacer()
                        Spacer()
                        switch loadingState {
                        case .error:
                            errorStateView
                        case .loading:
                            loadingStateView
                        case .empty:
                            emptyStateView
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
        }
        .dynamicTypeSize(.xLarge)
    }
    
    private var loadingStateView: some View {
        LoadingCircleView(isAnimating: $viewModel.isAnimating)
    }
    
    private var emptyStateView: some View {
        Group {
            if let name = loadingState.imageName {
                Image(name)
            }
            Text(LocalizePrices.notFound.rawValue)
                .font(.titleSFProRegular18())
        }
    }
    
    private var errorStateView: some View {
        Group {
            if let name = loadingState.imageName {
                Image(name)
            }
            VStack{
                VStack {
                    Text(LocalizePrices.fail.rawValue)
                        .font(.titleABeeZeeRegular18())
                        .foregroundStyle(Color.wbColor.text)
                        .frame(height: 24)
                    Spacer()
                    Text(LocalizePrices.tryLater.rawValue)
                        .font(.titleABeeZeeRegular18())
                        .foregroundStyle(Color.wbColor.textPrimary)
                }
                .frame(height: 52)
                Spacer()
                Button {
                    goToProductsView()
                } label: {
                    HStack {
                        Image(CustomImage.button.rawValue)
                        Text(LocalizePrices.update.rawValue)
                            .tint(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.wbColor.buttons)
                .clipShape(.rect(cornerRadius: 10))
            }
            .frame(height: 108)
        }
    }
    
    private func goToProductsView(){
        router.push(.pricesAndDiscounts(.loading))
        Task {
            switch await viewModel.isInternetReallyAvailable() {
            case true:
                router.push(.productsInternet)
            case false:
                router.push(.productsLocal)
            }
        }
    }
}

//navigationTitle и ignoresSafeArea - настраиваются для всех в RoutingView
#Preview {
    NavigationView(content: {
        //три состояния экрана PricesAndDiscountsView() - .empty, .error, .loading
        PricesAndDiscountsView(loadingState: .constant(.error))
            .navigationTitle(LocalizeRouting.title.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
    })
}
