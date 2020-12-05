import Foundation


import Fluent

struct CreateBooking: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("bookings")
            .id()
            .field("date", .date, .required)
            .field("garage_id", .uuid, .references("garages", "id"))
            .field("user_id", .uuid, .required, .references("users", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("bookings").delete()
    }
}
