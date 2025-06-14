//
//  PricesAndDiscountsView.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI
import Network

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

final class PricesAndDiscountsViewModel: ObservableObject {
    @Published var isAnimating = false
    
    
    //проверка интернет соединения
    //Проверка selectedSegment при переходе на страницу "Все товары" или "Товары без цены"
    //В логике моего приложения "Все товары" -> сетевой запрос (true)
    //"Товары без цены" -> загрузка из локального хранилища (false)
    private func checkInternetConnection() async -> Bool {
           return await withCheckedContinuation { continuation in
               let monitor = NWPathMonitor()
               let queue = DispatchQueue(label: "InternetCheck")
               monitor.pathUpdateHandler = { path in
                   continuation.resume(returning: path.status == .satisfied)
                   monitor.cancel()
               }
               monitor.start(queue: queue)
           }
    }
    
    //дополнительная проверка доступа к ресурсу
    //функция checkInternetConnection() не отрабатывает при включенном VPN
    func isInternetReallyAvailable() async -> Bool {
        let monitorStatus = await checkInternetConnection()
        if !monitorStatus { return false }
        
        guard let url = URL(string: "https://apple.com") else { return false }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, 200..<400 ~= httpResponse.statusCode {
                return true
            }
        } catch {
            // Ошибка запроса — интернет, вероятно, недоступен
        }
        return false
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
        LoadingCircleView(isAnimating: $viewModel.isAnimating)
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
                router.push(.pricesAndDiscounts(.loading))
                Task {
                    switch await viewModel.isInternetReallyAvailable() {
                    case true:
                        router.push(.productsInternet)
                    case false:
                        router.push(.productsLocal)
                    }
                }
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
