//
//  Location.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import Foundation
import SwiftData

@Model
class Location {
    var id: UUID
    var address: String
    var locationLat: Double
    var locationLng: Double
    
    init(id: UUID, address: String, locationLat: Double, locationLng: Double) {
        self.id = id
        self.address = address
        self.locationLat = locationLat
        self.locationLng = locationLng
    }
}
