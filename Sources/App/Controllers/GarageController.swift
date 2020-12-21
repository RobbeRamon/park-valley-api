//
//  File.swift
//  
//
//  Created by Robbe on 07/11/2020.


import Fluent
import Vapor


struct GarageController: RouteCollection {
    
    
    func boot(routes: RoutesBuilder) throws {
        let garages = routes.grouped("garages")
        
        garages.get(use: index)
        garages.post(use: create)
        
        garages.group(":garageID") { garage in
            garage.delete(use: delete)
            garage.get(use: getById)
            
            garage.group("availableDays") { day in
                day.post(use: getAvailableDays)
            }
            
            garage.group("addBooking") { booking in
                booking.post(use: addBooking)
            }
            
            garage.group("favor") { garage in
                garage.get(use: favorGarage)
            }
            
            garage.group("defavor") { garage in
                garage.get(use: defavorGarage)
            }
        }
    }

    /*
    func index(req: Request) throws -> EventLoopFuture<[Garage]> {
        
        try req.auth.require(User.self)
        
        if let city = (try? req.query.get(String.self, at: "city")) {
            print("test")
            return Garage.query(on: req.db).filter(\.$city == city ).all()

        }
        
        return Garage.query(on: req.db).all()
    }*/
    
    func index(req: Request) throws -> [GarageDTO] {
        
        let user = try req.auth.require(User.self)
        
        if let city = (try? req.query.get(String.self, at: "city")) {
            return Garages.getGaragesByCity(user: user, city: city).map({
                transformGarageToGarageDTO(garage: $0, user: user)
            })
            //return Garage.query(on: req.db).filter(\.$city == city ).all()
        }
        
        //return Garage.query(on: req.db).all()
        
        return []
    }
    
    func getById(req: Request) throws -> GarageDTO {
        
        let user = try req.auth.require(User.self)
        let garageId = req.parameters.get("garageID")
    
        
        let garage = Garages.getGarageById(user: user, id: UUID(uuidString: garageId!)!)
        
        
        return transformGarageToGarageDTO(garage: garage!, user: user)
    }
    
    func create(req: Request) throws -> [Garage] {
//        let user = try req.auth.require(User.self)
//        let create = try req.content.decode(Garage.Create.self)
//
//        let garage = Garage (name: create.name, latitude: create.latitude, longitude: create.longitude, city: create.city)
//
//        garage.$user.id = user.id!
//
//        return garage.save(on: req.db).map { garage }
        
        return []
    }
    
    func delete(req: Request) throws -> HTTPStatus {
        let garageId = req.parameters.get("garageID")
        
        let result = Garages.deleteGarage(id: UUID(uuidString: garageId!)!)
        
        if !result {
            return HTTPStatus.badRequest
        }
        
        return HTTPStatus.ok
    }
    
    func addBooking(req: Request) throws -> Booking {
        
        let user = try req.auth.require(User.self)
        let create = try req.content.decode(BookingDTO.Create.self)
        
        let garage = Garages.getGarageByName(user: user, name: create.name)
        
        var booking = Booking(date: create.date, user: user)
        
        booking = Garages.addBookingToGarage(user: user, garage: garage!, booking: booking)
        return booking

    }
    
    
    func getAvailableDays(req: Request) throws -> [String] {
        
        let user = try req.auth.require(User.self)
        let dateRange = try req.content.decode(DateRange.Create.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        
        let garage = Garages.getGarageByName(user: user, name: dateRange.name)
        return (garage?.getAvailableDaysWithinRange(startDate: dateRange.startDate, endDate: dateRange.endDate).map{
            dateFormatter.string(from: $0)
        }) ?? []
        
    }
    
    func favorGarage(req: Request) throws -> HTTPStatus {
        
        let user = try req.auth.require(User.self)
        let garageId = req.parameters.get("garageID")
        
        let result = Garages.favorGarage(user: user, garageId: UUID(uuidString: garageId!)!)
        
        if !result {
            return HTTPStatus.badRequest
        }
        
        return HTTPStatus.ok
    }
    
    func defavorGarage(req: Request) throws -> HTTPStatus {
        
        let user = try req.auth.require(User.self)
        let garageId = req.parameters.get("garageID")
        
        let result = Garages.defavorGarage(user: user, garageId: UUID(uuidString: garageId!)!)
        
        
        if !result {
            return HTTPStatus.badRequest
        }
        
        return HTTPStatus.ok
        
    }
    
    private func transformGarageToGarageDTO(garage: Garage, user: User) -> GarageDTO {
        var favorite = false
        
        if garage.favoredBy.first(where: {$0.id == user.id}) != nil {
            favorite = true
        }
        
        return GarageDTO(id: garage.id!, name: garage.name, latitude: garage.latitude, longitude: garage.longitude, city: garage.city, user: garage.user, bookings: garage.bookings, favorite: favorite)
    }
}
