// docker run -p 8080:8080 -it --name ARServer -v ~/ARServer:/ARServer -w/ARServer swift:4.0 /bin/bash

import Cryptor
import Foundation
import Kitura
import KituraNet
import HeliumLogger
import LoggerAPI
import MySQL

HeliumLogger.use()

let router = Router()

router.post("/", middleware: BodyParser())

router.get("/:user/objects") { request, response, next in
    defer { next() }
    
    // Find out which user name is passed
    guard let user  = request.parameters["user"] else { return }
//    let user = "/';drop table objects;--/objects"
    
    // Connect to MySQL
    let (database, connection) = try connectToDatabase()
    
    // Create a query string
    let query = "select id, user, url, date from objects where user = ? order by date desc;"
    
    // Merge query string with a user parameter
    let objects = try database.execute(query, [user], connection)
    
    // Convert result into dictionaries
    var parsedObjects = [[String: Any]]()
    
    for object in objects {
        var objectDictionary = [String: Any]()
        objectDictionary["id"] = object["id"]?.int
        objectDictionary["user"] = object["user"]?.string
        objectDictionary["url"] = object["url"]?.string
        objectDictionary["date"] = object["date"]?.string
        parsedObjects.append(objectDictionary)
    }
    
    var result = [String: Any]()
    result["status"] = "ok"
    result["objects"] = parsedObjects
    
    do {
        try response.status(.OK).send(json: result).end()
    } catch {
        Log.warning("Could not send /:user/objects for \(user): \(error.localizedDescription)")
    }
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
