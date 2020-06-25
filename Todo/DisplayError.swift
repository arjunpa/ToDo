//
//  DisplayError.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

enum DisplayError: Error {
    
    case general
    case validation
    
    var title: String {
        switch self {
        case .general, .validation:
            return "Error"
        }
    }
    
    var message: String {
        switch self {
        case .general:
            return "Something went wrong."
        case .validation:
            return "Validation failure. Please make sure mandatory fields are filled."
        }
    }
}
