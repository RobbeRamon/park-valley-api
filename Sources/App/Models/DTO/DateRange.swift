import Vapor

final class DateRange : Content {
    
    var startDate: Date
    var endDate: Date
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    struct Create : Content {
        var startDate: Date
        var endDate: Date
    }
}
