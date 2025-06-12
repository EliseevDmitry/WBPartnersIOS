//
//  Model.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import Foundation

enum ProductCategory: String, Codable {
    case phones
    case laptops
}

//Размер структуры 106 байт - с точки зрения выравнивания
struct Product: Codable {
    let name: String
    let id: String
    let wbId: String
    let price: Decimal
    let currency: String
    let image: String
    let category: ProductCategory
    let discount: UInt8
}
