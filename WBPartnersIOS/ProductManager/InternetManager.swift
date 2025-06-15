//
//  InternetManager.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import Foundation
import Network

protocol IInternetManager {
    func isInternetReallyAvailable() async -> Bool
}


final class InternetManager: IInternetManager {
    
    //функция проверки доступности backend даже при включенном VPN
    func isInternetReallyAvailable() async -> Bool {
        let monitorStatus = await checkInternetConnection()
        if !monitorStatus { return false }
        guard let url = URL(string: URLProducts.products.rawValue) else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 5
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            try response.validate()
            return true
        } catch {
            return false
        }
    }
    
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
}
