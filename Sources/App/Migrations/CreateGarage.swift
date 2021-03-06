import Fluent

struct CreateGarage: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("garages")
            .id()
            .field("name", .string, .required)
            .field("user_id", .string)
            .field("longitude", .double, .required)
            .field("latitude", .double, .required)
            .field("city", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("garages").delete()
    }
}
