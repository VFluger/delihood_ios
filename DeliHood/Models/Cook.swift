//
//  Food.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import Foundation

struct Cook: Identifiable, Decodable {
    var id: Int
    var name: String
    var imageUrl: String?
    var location_lat: Double
    var location_lng: Double
    var foods: [Food]
}
