import Fluent
import FluentSQLiteDriver
import Vapor
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    //app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "host",
        username: Environment.get("DATABASE_USERNAME") ?? "username",
        password: Environment.get("DATABASE_PASSWORD") ?? "password",
        database: Environment.get("DATABASE_NAME") ?? "name"
    ), as: .psql)

    app.migrations.add(CreateTodo())
    app.migrations.add(CreateGarage())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateUserToken())
    app.migrations.add(CreateBooking())
    
    try app.autoMigrate().wait()

    // register routes
    try routes(app)
}
