//
//  DbHelper.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 28/01/2021.
//  Copyright © 2021 Adrian Oleszczak. All rights reserved.
//

import Foundation
import SQLite3
import Firebase

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS myspot(Id INTEGER PRIMARY KEY,content TEXT,imageURL TEXT, timestamp TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("myspot table created.")
            } else {
                print("myspot table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id:Int, content:String, imageURL:String, timestamp:String)
    {
        let myspots = read()
        for spot in myspots
        {
            if spot.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO myspot (Id, content, imageURL, timestamp) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (content as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (imageURL as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (timestamp as NSString).utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [CardContent] {
        let queryStatementString = "SELECT * FROM myspots;"
        var queryStatement: OpaquePointer? = nil
        var psns : [CardContent] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let content = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let imageURL = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let timestamp = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))

                let dateFormatter = ISO8601DateFormatter()
                let date = dateFormatter.date(from:timestamp)!
                
                psns.append(CardContent(id: Int(id), content: content, imageUrl: imageURL, timestamp: Timestamp(date: date)))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
