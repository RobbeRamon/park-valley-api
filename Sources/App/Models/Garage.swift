//
//  File.swift
//  
//
//  Created by Robbe on 07/11/2020.
//

import Fluent
import Vapor

final class Garage : Model, Content {
    static let schema = "garages"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "latitude")
    var latitude: Double
    
    @Field(key: "longitude")
    var longitude: Double
    
    @Parent(key: "user_id")
    var user: User
    
    init() {}
    
    init(id: UUID? = nil, name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    struct Create : Content {
        var name: String
        var latitude: Double
        var longitude: Double
    }
}
