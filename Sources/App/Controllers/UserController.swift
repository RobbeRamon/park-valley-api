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
    
    func getBookings(req: Request) throws -> EventLoopFuture<[Booking]> {
        let user = try req.auth.require(User.self)
        
        let result = User.query(on: req.db).filter(\.$username == user.email).with(\.$bookings).with(\.$garages).first()
        return result.map({(user: User?) -> [Booking] in
            
            if let user = user {
                return user.bookings
            }
            
            return []
            
        })
    }
    
    func getGarages(req: Request) throws -> EventLoopFuture<[Garage]> {
        
        
        
        
    }
}


