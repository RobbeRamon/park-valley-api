//
//  Garages.swift
//  The persistence layer is for development only, on production this can be replaced by a database
//
//  Created by Robbe on 21/12/2020.
//

import Foundation

class Garages {
    static var garages: [Garage] = []
    static var isInitialized = false
    
    
    static func initializeData(user: User) -> Void {
        let garage: Garage = Garage(id: UUID(), name: "Garage near city center", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", latitude: 40.715756, longitude: -74.045202, city: "New York", user: user)
        
        garages.append(garage)
    }
    
    static func getGaragesByCity(user: User, city: String) -> [Garage] {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        return garages.filter({
            $0.city == city
        })
    }
    
    static func getGarageByName(user: User, name: String) -> Garage? {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        return garages.first(where: {
            $0.name == name
        })
    }
    
    static func getGarageById(user: User, id: UUID) -> Garage? {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        return garages.first(where: {
            $0.id == id
        })
    }
    
    static func addGarage(user: User, garage: Garage) -> Void {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        garage.id = UUID()
        garages.append(garage)
    }
    
    static func getGaragesByUser(user: User) -> [Garage] {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        return garages.filter({
            $0.user.username == user.username
        })
    }
    
    static func addBookingToGarage(user: User, garage: Garage, booking: Booking) -> Booking {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        booking.id = UUID()
        garage.bookings.append(booking)
        return booking
    }
    
    static func deleteGarage(id: UUID) -> Bool {
        let garage = garages.first(where: {
            $0.id == id
        })
        
        if let garage = garage, let index = garages.firstIndex(of: garage) {
            garages.remove(at: index)
            return true
        } else {
            return false
        }
    }
    
    static func favoredGaragesByUser(user: User) -> [Garage] {
        
        return garages.filter({ (garage: Garage) -> Bool in
            garage.favoredBy.contains { $0.id == user.id }
        })
        
    }
    
    static func favorGarage(user: User, garageId: UUID) -> Bool {
        
        let garage = garages.first(where: {
            $0.id == garageId
        })
        
        if let garage = garage {
            
            if garage.favoredBy.first(where: {$0.id == user.id}) == nil {
                garage.favoredBy.append(user)
            }
            
        } else {
            return false
        }
        
        return true
        
    }
    
    static func defavorGarage(user: User, garageId: UUID) -> Bool {
        
        let garage = garages.first(where: {
            $0.id == garageId
        })
        
        if let garage = garage {
            
            if let index = garage.favoredBy.firstIndex(of: user) {
                garage.favoredBy.remove(at: index)
            }
            
        } else {
            return false
        }
        
        return true
    }
    
    static func getBookingsFromUser(user: User) -> [BookingDTO] {
        //let allBookings = garages.flatMap({$0.bookings})
        //var bookings = allBookings.filter({$0.user.id == user.id})
        
        var bookings : [BookingDTO] = []
        
        for garage in garages {
            for booking in garage.bookings {
                if booking.user.id == user.id {
                    bookings.append(BookingDTO(name: garage.name, date: booking.date))
                }
            }
        }
        
        return bookings
    }
    

    
    
    
}
