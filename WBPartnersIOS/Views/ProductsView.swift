//
//  ProductsView.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUI


final class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var selectedSegment: Int
    @Published var selectedProduct: Product? = nil
    @Published var showDialog = false
    private var productManager: IProductManager
    
    init(manager: IProductManager, selectedSegment: Int) {
        self.productManager = manager
        self.selectedSegment = selectedSegment
       // self.products.append(MocData.testProduct)
    }
    
    func copyID(id: String){
        UIPasteboard.general.string = id
    }
    
    func getProducts() {
        Task {
            do {
                let data = try await productManager.fetchData()
                let decoded = try productManager.getProducts(of: ProductsResponse.self, data: data)
                
                await MainActor.run {
                    self.products = decoded.products
                }
            } catch {
                print("Ошибка получения данных: \(error)")
            }
        }
    }
    
}

struct ProductsView: View {
    @StateObject private var viewModel: ProductViewModel
    init(selectedSegment: Int) {
        _viewModel = StateObject(wrappedValue: ProductViewModel(manager: Dependency.shared.productManager, selectedSegment: selectedSegment))
        }
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]){
                Section(header: stickyHeader) {bodyProducts}
            }
            .confirmationDialog("", isPresented: $viewModel.showDialog, titleVisibility: .hidden) {copyIDDialog}
        }
        .background(Color.wbColor.background)
        .onAppear{
            viewModel.getProducts()
        }
    }
    
    //sticky header UI
    private var stickyHeader: some View {
        ZStack {
            Color.wbColor.wBackground
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Picker("Сегмент", selection: $viewModel.selectedSegment) {
                Text("Все").tag(0)
                Text("Без цены").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }
    
    //scroll products UI
    private var bodyProducts: some View {
        ForEach(viewModel.products) { product in
            ProductCardView(product: product)
                .onTapGesture {
                    viewModel.selectedProduct = product
                    viewModel.showDialog = true
                }
        }
    }

    //confirmationDialog UI
    private var copyIDDialog: some View {
        Group{
            Button("Скопировать артикул") {
                if let id = viewModel.selectedProduct?.id {
                    viewModel.copyID(id: id)
                }
            }
            Button("Скопировать артикул WB") {
                if let wbId = viewModel.selectedProduct?.wbId {
                    viewModel.copyID(id: wbId)
                }
            }
            Button("Отмена", role: .cancel) {}
        }
    }
  
}

#Preview {
    NavigationView(content: {
        ProductsView(selectedSegment: 0)
    })
}
