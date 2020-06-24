//
//  ToDoViewModel.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

class ToDoViewModel {
    
    let title: String?
    let description: String?
    
    init(title: String?, description: String?) {
        self.title = title
        self.description = description
    }
}
