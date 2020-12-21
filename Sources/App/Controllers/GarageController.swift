//
//  File.swift
//  
//
//  Created by Robbe on 07/11/2020.


import Fluent
import Vapor


struct GarageController: RouteCollection {
    
    var garages: Garages = Garages()
    
    
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
    
    func index(req: Request) throws -> [Garage] {
        
        let user = try req.auth.require(User.self)
        
        if let city = (try? req.query.get(String.self, at: "city")) {
            return garages.getGaragesByCity(user: user, city: city)
            //return Garage.query(on: req.db).filter(\.$city == city ).all()
        }
        
        //return Garage.query(on: req.db).all()
        
        return []
    }
    
    func getById(req: Request) throws -> Garage {
        
        let user = try req.auth.require(User.self)
        let garageId = req.parameters.get("garageID")
    
        
        let garage = garages.getGarageById(user: user, id: UUID(uuidString: garageId!)!)
        
        
        return garage!
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
//        return Garage.find(req.parameters.get("garageID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { $0.delete(on: req.db) }
//            .transform(to: .ok)
        
        return HTTPStatus.ok
    }
    
    func addBooking(req: Request) throws -> Booking {
        
        let user = try req.auth.require(User.self)
        let create = try req.content.decode(BookingDTO.Create.self)
        
        let garage = garages.getGarageByName(user: user, name: create.name)
        
        var booking = Booking(date: create.date)
        
        booking = garages.addBookingToGarage(user: user, garage: garage!, booking: booking)
        return booking
    }
    
    
    func getAvailableDays(req: Request) throws -> [String] {
        
        let user = try req.auth.require(User.self)
        let dateRange = try req.content.decode(DateRange.Create.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        
        let garage = garages.getGarageByName(user: user, name: dateRange.name)
        return (garage?.getAvailableDaysWithinRange(startDate: dateRange.startDate, endDate: dateRange.endDate).map{
            dateFormatter.string(from: $0)
        }) ?? []
        
    }
}
