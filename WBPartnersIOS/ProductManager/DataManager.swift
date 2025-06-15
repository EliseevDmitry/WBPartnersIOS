//
//  DataManader.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import Foundation

final class DataManager: IProductManager {
    func fetchData() async throws -> Data {
        let data = Data()
        return data
    }
    
    func getProducts<T>(of type: T.Type, data: Data) throws -> T where T : Decodable {
        do {
            let objects = try JSONDecoder().decode(T.self, from: data)
            return objects
        } catch {
            throw error
        }
    }
    
    
}
