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
        }
        
//        garages.group("city") { garage in
//            garage.get(use: getByCity)
//        }
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
}
