import Fluent
import Vapor

final class Booking : Model, Content {
    static let schema = "bookings"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "date")
    var date: Date
    
    @Parent(key: "garage_id")
    var garage: Garage
    
    @Parent(key: "user_id")
    var user: User
    
    
    init() {}
    
    init(id: UUID? = nil, date: Date) {
        self.id = id
        self.date = date
    }
    
    struct Create : Content {
        var date: Date
    }
}
