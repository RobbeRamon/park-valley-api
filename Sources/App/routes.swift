import Fluent
import Vapor

func routes(_ app: Application) throws {
    
//    let protection = app.grouped(UserAuthenticator())
//    protected.get("me") { req -> String in
//        try req.auth.require(User.self).username
//    }
    
    // Authentication
    let passwordProtected = app.grouped(User.authenticator())
    
    passwordProtected.get("login") { req -> EventLoopFuture<UserToken> in
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        return token.save(on: req.db)
            .map { token }
    }
    
    let tokenProtected = app.grouped(UserToken.authenticator())
    tokenProtected.get("me") { req -> User in
        try req.auth.require(User.self)
    }
    
    
    
    //
    
    app.get { req in
        return "It works!"
    }
    
    app.get("reset") { req -> StatusDTO in
        let status = Garages.reset()
        return StatusDTO(success: status)
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    

    try app.register(collection: TodoController())
    try tokenProtected.register(collection: GarageController())
    try tokenProtected.register(collection: UserController())
}

