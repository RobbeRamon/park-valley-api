//
//  Garages.swift
//  The persistence layer is for development only, on production this can be replaced by a database
//
//  Created by Robbe on 21/12/2020.
//

import Foundation

class Garages {
    var garages: [Garage]
    private var isInitialized = false
    
    init() {
        garages = []
    }
    
    func initializeData(user: User) -> Void {
        let garage: Garage = Garage(id: UUID(), name: "Garage near city center", latitude: 40.715756, longitude: -74.045202, city: "New York", user: user)
        
        garages.append(garage)
    }
    
    func getGaragesByCity(user: User, city: String) -> [Garage] {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        return garages.filter({
            $0.city == city
        })
    }
    
    func getGarageByName(user: User, name: String) -> Garage? {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        return garages.first(where: {
            $0.name == name
        })
    }
    
    func getGarageById(user: User, id: UUID) -> Garage? {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        return garages.first(where: {
            $0.id == id
        })
    }
    
    func addGarage(user: User, garage: Garage) -> Void {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        garage.id = UUID()
        garages.append(garage)
    }
    
    func getGaragesByUser(user: User) -> [Garage] {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        return garages.filter({
            $0.user.username == user.username
        })
    }
    
    func addBookingToGarage(user: User, garage: Garage, booking: Booking) -> Booking {
        if isInitialized == false {
            initializeData(user: user)
            isInitialized = true
        }
        
        booking.id = UUID()
        garage.bookings.append(booking)
        
        return booking
    }
    
    
    
}
