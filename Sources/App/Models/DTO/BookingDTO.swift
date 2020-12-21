//
//  File.swift
//  
//
//  Created by Robbe on 21/12/2020.
//

import Vapor

final class BookingDTO : Content {
    
    var name: String
    var date: Date
    
    init(name: String, date: Date) {
        self.name = name
        self.date = date
    }
    
    struct Create : Content {
        var name: String
        var date: Date
    }
}

