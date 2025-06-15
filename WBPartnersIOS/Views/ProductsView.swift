//
//  ProductsView.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUI

/*
 Требование: "Интерфейс должен маĸсимально точно соответствовать маĸету"
 Использование - magic numbers - плохая практика, старался не прибегать,
 или минимизировать их использование (сложно было понять термин - маĸсимально точно).
 Теоретически можно было - перенести всю геометрию Figma в текущих размерах в уравнения,
 через GR при старте приложения считать wight и height (конкретного устройства)
 и через систему уравнений - пересчитывать интерфейс (максимальное масштабирование под устройство).
 */

enum LocalizeProducts: String {
    case all = "Все"
    case withoutPrice = "Без цены"
    case copyItem = "Скопировать артикул"
    case copyWBItem = "Скопировать артикул WB"
    case cancel = "Отмена"
}

enum PickerSegment: Int {
    case zero = 0
    case one = 1
}


final class ProductViewModel: ObservableObject {
    private var productManager: IProductManager
    @Published var products: [Product] = []
    @Published var selectedProduct: Product? = nil
    @Published var showDialog = false
    @Published var selectedSegment: PickerSegment {
            didSet {
                handleSegmentChange()
            }
        }

    init(manager: IProductManager, selectedSegment: PickerSegment) {
        self.productManager = manager
        self.selectedSegment = selectedSegment
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
    
    private func handleSegmentChange() {
        switch selectedSegment {
        case PickerSegment.zero:
            print("сегмент 0")
        case PickerSegment.one:
            print("сегмент 1")
        }
    }
}

struct ProductsView: View {
    @StateObject private var viewModel: ProductViewModel
    init(selectedSegment: PickerSegment) {
        switch selectedSegment {
        case .zero:
            _viewModel = StateObject(wrappedValue: ProductViewModel(manager: Dependency.shared.productManager, selectedSegment: selectedSegment))
        case .one:
            _viewModel = StateObject(wrappedValue: ProductViewModel(manager: Dependency.shared.dataManager, selectedSegment: selectedSegment))
        }  
    }
    var body: some View {
        /*
         Использую GeometryReader, чтобы передать ширину экрана через EnvironmentValues.
         Это значение потом применяю при отрисовке пунктирной линии.
         Сделано для оптимизации: ширина вычисляется один раз на общий экран.
         */
        GeometryReader{ geometry in
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]){
                    Section(header: stickyHeader) {bodyProducts}
                }
                .confirmationDialog("", isPresented: $viewModel.showDialog, titleVisibility: .hidden) {copyIDDialog}
            }
            .environment(\.screenWidth, geometry.size.width)
        }
        .background(Color.wbColor.background)
        .dynamicTypeSize(.xLarge)
        .onAppear{
            
            viewModel.getProducts()
        }
    }
    
    //sticky header UI
    private var stickyHeader: some View {
        ZStack {
            Color.wbColor.wBackground
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Picker("", selection: $viewModel.selectedSegment) {
                Text(LocalizeProducts.all.rawValue).tag(PickerSegment.zero)
                Text(LocalizeProducts.withoutPrice.rawValue).tag(PickerSegment.one)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }
    
    //scroll products UI
    private var bodyProducts: some View {
        ForEach(Array(viewModel.products.enumerated()), id: \.element.id) { index, product in
            ProductCardView(product: product)
                .padding(.top, index == 0 ? 5 : 0)
                .onTapGesture {
                    viewModel.selectedProduct = product
                    viewModel.showDialog = true
                }
        }
    }
    
    //confirmationDialog UI
    private var copyIDDialog: some View {
        Group{
            Button(LocalizeProducts.copyItem.rawValue) {
                if let id = viewModel.selectedProduct?.id {
                    viewModel.copyID(id: id)
                }
            }
            Button(LocalizeProducts.copyWBItem.rawValue) {
                if let wbId = viewModel.selectedProduct?.wbId {
                    viewModel.copyID(id: wbId)
                }
            }
            Button(LocalizeProducts.cancel.rawValue, role: .cancel) {}
        }
    }
    
}

#Preview {
    NavigationView(content: {
        ProductsView(selectedSegment: PickerSegment.one)
            .navigationTitle(LocalizeRouting.title.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
    })
}
