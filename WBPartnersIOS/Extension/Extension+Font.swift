//
//  Extension+Font.swift
//  WBPartnersIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUICore
import UIKit

extension Font {
    static let aBeeZeeRegular = UIFont(name: "ABeeZee-Regular", size: 18) ?? .systemFont(ofSize: 18)
    
    static func titleABeeZeeRegular() -> Font {
        return Font(aBeeZeeRegular)
    }

    static func titleSFProRegular() -> Font {
        return Font.custom("SFProDisplay-Regular", size: 18)
    }
    
    
}
