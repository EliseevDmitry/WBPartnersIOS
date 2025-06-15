//
//  Extension+Color.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUICore
import UIKit

extension Color {
    static let wbColor = ColorTheme()
}

struct ColorTheme {
    let uiWhite = UIColor.white
    let uiBlack = UIColor.black
    let background = Color("background")
    let textPrimary = Color("textPrimary")
    let buttons = Color("buttons")
    let burgerButton = Color("burgerButton")
    let titlePriceSummary = Color("titlePriceSummary")
    let dashesLine = Color("dashesLine")
}

extension ColorTheme {
    var text: Color {
        Color(uiBlack)
    }
    
    var wBackground: Color {
        Color(uiWhite)
    }
}
