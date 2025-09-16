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
    let image_url: String?
    let distance_meters: Double
    let foods: [Food]
}
