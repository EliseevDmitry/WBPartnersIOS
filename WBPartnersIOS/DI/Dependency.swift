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
    
    private init(){
        self.imageCacheManager = ImageCacheManager()
        self.productManager = ProductManager()
    }
}
