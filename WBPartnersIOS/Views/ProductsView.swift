//
//  ProductsView.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUI

protocol IProductView {
    func copyID(id: String)
    func removeCopiedID()
}

final class ProductViewModel: ObservableObject, IProductView {
    @Published var products: [Product] = []
    @Published var selectedSegment = 0
    @Published var selectedProduct: Product? = nil
    @Published var showDialog = false
    
    init() {
        self.products.append(MocData.testProduct)
        self.products.append(MocData.testProduct1)
        self.products.append(MocData.testProduct2)
    }
    
    func copyID(id: String){
        UIPasteboard.general.string = id
    }
    
    func removeCopiedID() {
        UIPasteboard.general.string = nil
    }
}

struct ProductsView: View {
    @StateObject private var viewModel = ProductViewModel()
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]){
                Section(header: stickyHeader) {bodyProducts}
            }
            .confirmationDialog("", isPresented: $viewModel.showDialog, titleVisibility: .hidden) {copyIDDialog}
        }
        .background(Color.wbColor.background)
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Цены и скидки")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear{
            viewModel.removeCopiedID()
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
        ForEach(viewModel.products, id: \.id) { product in
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
        ProductsView()
    })
}
