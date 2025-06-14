//
//  ProductManager.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

import Foundation

enum URLProducts: String {
    case products = "https://dummyjson.com/products"
}

protocol IProductManager {
    func fetchData() async throws -> Data
    func getProducts<T: Decodable>(of type: T.Type, data: Data) throws -> T
    func validateResponse(_ response: URLResponse) throws
}

final class ProductManager: IProductManager {

    func fetchData() async throws -> Data {
        guard let url = URL(string: URLProducts.products.rawValue) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        try validateResponse(response)
        return data
    }

    func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

}

extension ProductManager {
    func getProducts<T: Decodable>(of type: T.Type, data: Data) throws -> T {
        do {
            let objects = try JSONDecoder().decode(T.self, from: data)
            return objects
        } catch {
            throw error
        }
    }
}
