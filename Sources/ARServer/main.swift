// docker run -p 8080:8080 -it --name ARServer -v ~/ARServer:/ARServer -w/ARServer swift:4.0 /bin/bash

import Foundation
import Kitura
import KituraNet
import HeliumLogger
import LoggerAPI

HeliumLogger.use(.debug)

let router = Router()
initRoots()

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
