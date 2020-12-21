import Fluent
import Vapor

final class Booking : Content {
    static let schema = "bookings"
    var id: UUID?
    var date: Date
    var user: User
    
    
    init(id: UUID? = nil, date: Date, user: User) {
        self.id = id
        self.date = date
        self.user = user
    }
    
    struct Create : Content {
        var id: UUID
        var date: Date
    }
}
