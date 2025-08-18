//
//  FilterItem.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import SwiftUI

//Category UI handling
enum CategoryContext: String, CaseIterable, Identifiable {
    case asian, italien, czech, indian, cheap, drink
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .asian: return "Asian"
        case .italien: return "Italien"
        case .czech: return "Czech"
        case .indian: return "Indian"
        case .cheap: return "Cheap"
        case .drink: return "Drink"
        }
    }
    
    var iconName: String {
        switch self {
        case .asian: return "chopsticks"
        case .italien: return "pizza"
        case .czech: return "beer"
        case .indian: return "leaf"
        case .cheap: return "dollarsign"
        case .drink: return "cup"
        }
    }
}
