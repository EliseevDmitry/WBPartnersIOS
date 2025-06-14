//
//  WBPartnersIOSApp.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

@main
struct WBPartnersIOSApp: App {
    @Environment(\.scenePhase) private var scenePhase
    init() {
        configureNavigationBarAppearance()
    }
    @StateObject private var router = Router(startAt: .pricesAndDiscounts(.error))
    var body: some Scene {
        WindowGroup {
            RoutingView()
                .environmentObject(router)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                removeCopiedID()
                Dependency.shared.imageCacheManager.clear()
            }
        }
    }
    
    private func configureNavigationBarAppearance() {
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
    
    private func removeCopiedID() {
        UIPasteboard.general.string = nil
    }
}
