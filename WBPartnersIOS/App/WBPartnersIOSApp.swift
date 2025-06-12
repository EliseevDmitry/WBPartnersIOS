//
//  WBPartnersIOSApp.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

@main
struct WBPartnersIOSApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = Color.wbColor.uiWhite
        appearance.backgroundColor = Color.wbColor.uiWhite
        appearance.titleTextAttributes = [
            .foregroundColor: Color.wbColor.uiBlack,
            .font: Font.aBeeZeeRegular
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    @StateObject private var router = Router(startAt: .pricesAndDiscounts(loadingState: .empty))
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
        }
    }
}
