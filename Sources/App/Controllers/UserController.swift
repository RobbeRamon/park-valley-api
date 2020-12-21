//
//  File.swift
//  
//
//  Created by Robbe on 07/11/2020.
//

import Fluent
import Vapor


struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: create)
        users.group(":userID") { user in
            user.delete(use: delete)
            
            user.group("bookings") { booking in
                booking.get(use: getBookings)
            }
            
            user.group("garages") { garage in
                garage.get(use: getGarages)
                
                
                garage.group("favourite") { favor in
                    favor.get(use: getFavouriteGarages)
                }
            }
        }
    }
    
    func index(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<User> {
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        
        let user = try User(
            username: create.username,
            email: create.email,
            passwordHash: Bcrypt.hash(create.password)
        )
        
        return user.save(on: req.db).map { user }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func getBookings(req: Request) throws -> [BookingDTO] {
        let user = try req.auth.require(User.self)
        return Garages.getBookingsFromUser(user: user)
    }
    
    func getGarages(req: Request) throws -> [GarageDTO] {
        
        
        let user = try req.auth.require(User.self)
        
        return Garages.getGaragesByUser(user: user).map({
            transformGarageToGarageDTO(garage: $0, user: user)
        })
        
    }
    
    func getFavouriteGarages(req: Request) throws -> [GarageDTO] {
        let user = try req.auth.require(User.self)
        
        return Garages.favoredGaragesByUser(user: user).map({
            transformGarageToGarageDTO(garage: $0, user: user)
        })
    }
    
    private func transformGarageToGarageDTO(garage: Garage, user: User) -> GarageDTO {
        var favorite = false
        
        if garage.favoredBy.first(where: {$0.id == user.id}) != nil {
            favorite = true
        }
        
        return GarageDTO(id: garage.id!, name: garage.name, description: garage.description, latitude: garage.latitude, longitude: garage.longitude, city: garage.city, user: garage.user, bookings: garage.bookings, favorite: favorite)
    }
}


