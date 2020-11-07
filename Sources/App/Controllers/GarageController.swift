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
        }
    }

    
    func index(req: Request) throws -> EventLoopFuture<[Garage]> {
        return Garage.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Garage> {
        let user = try req.auth.require(User.self)
        let create = try req.content.decode(Garage.Create.self)
        
        let garage = Garage (name: create.name, latitude: create.latitude, longitude: create.longitude)
        
        garage.$user.id = user.id!
        
        return garage.save(on: req.db).map { garage }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("garageID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
