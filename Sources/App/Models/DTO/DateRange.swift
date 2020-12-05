import Vapor

final class DateRange : Content {
    
    var name: String
    var startDate: Date
    var endDate: Date
    
    init(name: String, startDate: Date, endDate: Date) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
    
    struct Create : Content {
        var name: String
        var startDate: Date
        var endDate: Date
    }
}
