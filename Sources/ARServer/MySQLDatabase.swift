//
//  MySQLDatabase.swift
//  ARServer
//
//  Created by Denis Bystruev on 10.12.2019.
//
import MySQL

func connectToDatabase() throws -> (Database, Connection) {
    let mysql = try Database(
        host: "localhost",
        user: "aruser",
        password: "arpassword",
        database: "ardb"
    )
    
    let connection = try mysql.makeConnection()
    return (mysql, connection)
}
