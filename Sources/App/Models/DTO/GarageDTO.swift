//
//  GarageDTO.swift
//  
//
//  Created by Robbe on 21/12/2020.
//

import Vapor

final class GarageDTO : Content {
    
    var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var city: String
    var user: User
    var bookings: [Booking]
    var favorite: Bool
    
    init(id: UUID, name: String, latitude: Double, longitude: Double, city: String, user: User, bookings: [Booking], favorite: Bool) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.user = user
        self.bookings = bookings
        self.favorite = favorite
    }
    
    struct Create : Content {
        var id: UUID
        var name: String
        var latitude: Double
        var longitude: Double
        var city: String
        var user: User
        var bookings: [Booking]
        var favorite: Bool
    }
}

