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
    
    var title: String {
        switch self {
        case .general:
            return "Error"
        }
    }
    
    var message: String {
        switch self {
        case .general:
            return "Something went wrong."
        }
    }
}
