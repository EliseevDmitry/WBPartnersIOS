//
//  Dependency.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

import Foundation

final class Dependency {
    static let shared = Dependency()
    
    let imageCacheManager: ImageCacheManager
    let productManager: IProductManager
    let internetManager: IInternetManager
    let dataManager: IProductManager
    
    private init(){
        self.imageCacheManager = ImageCacheManager()
        self.productManager = ProductManager()
        self.internetManager = InternetManager()
        self.dataManager = DataManager()
    }
}
