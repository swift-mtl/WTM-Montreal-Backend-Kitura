import KituraRouter
import KituraNet
import KituraSys

import HeliumLogger
import LoggerAPI

import Foundation

/// The Kitura Router
let router = Router()

Log.logger = HeliumLogger()


/// Setup database
let users: UserDAOProtocol = UserCollection(baseURL:"http://localhost:8090/users")

/// Add some example data to the database
users.add("John Appleseed", address: "Montreal", score: 4, isAdmin: true)
users.add("Bill Gates", address: "Seatle", score: 4, isAdmin: true)
users.add("Eric Gamma", address: "San Fransisco", score: 3, isAdmin: false)
users.add("Steve Jobs", address: "Palo Alto", score: 3, isAdmin: false)
users.add("Alan Turing", address: "Seatle", score: 4, isAdmin: true)
users.add("John Doe", address: "New york", score: 3, isAdmin: false)
users.add("Ada Byron", address: "Washington", score: 3, isAdmin: false)

/// Call a helper function to create routes in App.swift
/// Set up middleware to parse incoming JSON in the body of client requests
setupRoutes(router, users: users)

/// Set up an HTTP server that listens to port 8090
let server = HttpServer.listen(8090, delegate: router)
Server.run()
