import Fluent
import Vapor

final class Booking : Content {
    static let schema = "bookings"
    var id: UUID?
    var date: Date
    //var garage: Garage?
    //var user: User
    
    
    init(id: UUID? = nil, date: Date) {
        self.id = id
        self.date = date
        //self.garage = garage
        //self.user = user
    }
    
    struct Create : Content {
        var id: UUID
        var date: Date
    }
}
