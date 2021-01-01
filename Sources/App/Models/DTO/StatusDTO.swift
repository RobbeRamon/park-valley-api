//
//  StatusDTO.swift
//  
//
//  Created by Robbe on 01/01/2021.
//

import Vapor

final class StatusDTO : Content {
    
    var success: Bool
    
    init(success: Bool) {
        self.success = success
    }
    
    struct Create : Content {
        var success: Bool
    }
}

