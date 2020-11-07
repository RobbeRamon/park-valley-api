//
//  File.swift
//  
//
//  Created by Robbe on 07/11/2020.
//

import Fluent

struct CreateGarage: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("garages")
            .id()
            .field("name", .string, .required)
            .field("longitude", .double, .required)
            .field("latitude", .double, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("todos").delete()
    }
}
