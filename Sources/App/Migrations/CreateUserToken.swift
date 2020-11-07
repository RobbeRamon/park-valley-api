//
//  File.swift
//  
//
//  Created by Robbe on 07/11/2020.
//

import Fluent

struct CreateUserToken: Migration {
    var name: String { "CreateUserToken" }

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user_tokens")
            .id()
            .field("value", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .unique(on: "value")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user_tokens").delete()
    }
}
