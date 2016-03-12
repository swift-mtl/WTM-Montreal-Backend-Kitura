import KituraRouter
import KituraNet

import LoggerAPI
import SwiftyJSON


class AllRemoteOriginMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        response.setHeader("Access-Control-Allow-Origin", value: "*")
        response.setHeader("Access-Control-Allow-Methods", value:"accept, content-type")
        response.setHeader("Access-Control-Allow-Methods", value: "GET, HEAD, POST, DELETE, OPTIONS, PUT")
        next()
    }
}

func setupRoutes(router: Router, users: UserDAOProtocol) {

    router.use("/*", middleware: BodyParser())
    router.use("/*", middleware: AllRemoteOriginMiddleware())
    
    router.all("/") {
        _, _, next in
        
        next()
    }
    
    router.get("/") {
        request, response, next in
        /// SwiftyJSON is used
        let json = JSON(UserCollection.serialize(users.getAll()))
        response.status(HttpStatusCode.OK).sendJson(json)
        next()
    }
    
    router.get("/:id") {
        request, response, next in
        
        next()
    }
    
    /// Add a users
    router.post("/") { request, response, next in
        
        if let body = request.body {
            if let json = body.asJson() {
                let name = json["name"].stringValue
                let address = json["address"].stringValue
                let score = json["score"].intValue
                let isAdmin = json["isAdmin"].boolValue
                
                let newItem = users.add(name, address: address, score: score, isAdmin: isAdmin)
                let result = JSON(newItem.serialize())
                
                response.status(HttpStatusCode.OK).sendJson(result)
                
            }
        } else {
//            Log.warning("No body")
            response.status(HttpStatusCode.BAD_REQUEST)
        }
    }
    
    router.post("/users/:id") {
        request, response, next in
        
        let id: String? = request.params["id"]
        
        if let body = request.body {
            
            if let json = body.asJson() {
                
                let name = json["name"].stringValue
                let address = json["address"].stringValue
                let score = json["score"].intValue
                let isAdmin = json["isAdmin"].boolValue
                
                let newItem = users.update(id!, name: name, address: address, score: score, isAdmin: isAdmin)
                
                let result = JSON(newItem!.serialize())
                
                response.status(HttpStatusCode.OK).sendJson(result)
                
            }
        } else {
            Log.warning("No body")
            response.status(HttpStatusCode.BAD_REQUEST)
        }
    }
    
    ///
    /// TODO:
    ///
    router.put("/users/:id") {
        request, response, next in
        
        // next()
        
    }
    
    
    
    ///
    /// Delete an individual todo item
    ///
    router.delete("/users/:id") {
        request, response, next in
        
        Log.info("Requesting a delete")
        
        let id: String? = request.params["id"]
        
        if let id = id {
            users.delete(id)
        } else {
            Log.warning("Could not parse ID")
        }
        
        do {
            try response.status(HttpStatusCode.OK).end()
        } catch {
            
        }
        // next()
        
    }
    
    ///
    /// Delete all the todo items
    ///
    router.delete("/users/") {
        request, response, next in
        Log.info("Requested clearing the entire list")
        
        users.clear()
        //next()
    }

}
