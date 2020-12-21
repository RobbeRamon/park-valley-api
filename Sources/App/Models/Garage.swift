//
//  File.swift
//  
//
//  Created by Robbe on 07/11/2020.
//

import Fluent
import Vapor

final class Garage :  Content {
    static let schema = "garages"
    

    var id: UUID?

    var name: String

    var latitude: Double

    var longitude: Double

    var city: String
    
    var user: User
    
    var bookings: [Booking]
    
    init(id: UUID? = nil, name: String, latitude: Double, longitude: Double, city: String, user: User) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.user = user
        bookings = []
    }
    
    struct Create : Content {
        var name: String
        var latitude: Double
        var longitude: Double
        var city: String
    }
    
    func getAvailableDaysWithinRange(startDate: Date, endDate: Date) -> [Date] {
        var dates = [Date]()
        
        var currentDate = startDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        
        
        
        while(currentDate < endDate) {
            let filteredBookings: [Booking] = bookings.filter({(booking:Booking) in
                return booking.date == currentDate
            })
            
            print(self.bookings)
            
            print("currentDate \(dateFormatter.string(from: currentDate))")
            print("endDate \(dateFormatter.string(from: endDate))")
            
            if filteredBookings.count < 1 {
                dates.append(currentDate)
            }
            
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
}
