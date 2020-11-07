//
//  File.swift
//  
//
//  Created by Robbe on 07/11/2020.
//

import Fluent
import Vapor

final class User: Model, Content, Authenticatable {
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
}
