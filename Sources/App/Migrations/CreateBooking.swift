import Foundation


import Fluent

struct CreateBooking: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("bookings")
            .id()
            .field("date", .date, .required)
            .field("garage_id", .string)
            .field("user_id", .double, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("bookings").delete()
    }
}
