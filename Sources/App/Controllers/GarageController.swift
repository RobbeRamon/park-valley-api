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
        }
    }

    
    func index(req: Request) throws -> EventLoopFuture<[Garage]> {
        
        try req.auth.require(User.self)
        
        if let city = (try? req.query.get(String.self, at: "city")) {
            print("test")
            return Garage.query(on: req.db).filter(\.$city == city ).all()

        }
        
        return Garage.query(on: req.db).all()
    }
    
    func getById(req: Request) throws -> EventLoopFuture<Garage> {
        return Garage.find(req.parameters.get("garageID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

//    func getByCity(req: Request) throws -> EventLoopFuture<[Garage]> {
//        return Garage.query(on: req.db).filter(\.$city == req.parameters.get("city")! ).all()
//    }
    
    func create(req: Request) throws -> EventLoopFuture<Garage> {
        let user = try req.auth.require(User.self)
        let create = try req.content.decode(Garage.Create.self)
        
        let garage = Garage (name: create.name, latitude: create.latitude, longitude: create.longitude, city: create.city)
        
        garage.$user.id = user.id!
        
        return garage.save(on: req.db).map { garage }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Garage.find(req.parameters.get("garageID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func getAvailableDays(req: Request) throws -> EventLoopFuture<[String]> {
        
        let result5 =  Garage.find(req.parameters.get("garageID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        let dateRange = try req.content.decode(DateRange.Create.self)
        
        
        let result = Garage.query(on:req.db).filter(\.$name == dateRange.name).with(\.$bookings).first()
        
        
//        result.whenSuccess({(garage: Garage) -> Void in
//            let dates = garage.getAvailableDaysWithinRange(startDate: dateRange.startDate, endDate: dateRange.endDate)
//        })
//
//        let result6 = result.map({(garage: Garage?) -> [String] in
//
//
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
//
//            print( garage!.getAvailableDaysWithinRange(startDate: dateRange.startDate, endDate: dateRange.endDate)
//                    .map{dateFormatter.string(from: $0)})
//
//            return [String]()
//        })
        
        let result2 = result.map({(garage: Garage?) -> [String] in
            

            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

            return garage!.getAvailableDaysWithinRange(startDate: dateRange.startDate, endDate: dateRange.endDate)
                    .map{dateFormatter.string(from: $0)}
        })
        
        return result2
        
        
//        return result.map({(garage:Garage) -> EventLoopFuture<[Date]> inE
//            let dates = garage.getAvailableDaysWithinRange(startDate: dateRange.startDate, endDate: dateRange.startDate)
//        })
        
       
        

    
        

        
        
        //return garage.getAvailableDaysWithinRange(startDate: dateRange.startDate, endDate: dateRange.endDate);
    }
}
