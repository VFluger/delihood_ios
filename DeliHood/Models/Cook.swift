//
//  Food.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import Foundation

struct Cook: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String
    let imageUrl: String?
    let location_lat: Double
    let location_lng: Double
    let foods: [Food]
}
