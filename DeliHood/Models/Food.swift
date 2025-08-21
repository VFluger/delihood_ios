//
//  Food.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import Foundation

struct Food: Identifiable, Codable {
    var id: Int
    var name: String
    var description: String
    var category: String
    var price: Int
    var imageUrl: String
}
