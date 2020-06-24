//
//  StoryboardInstantiable.swift
//  Todo
//
//  Created by Arjun P A on 23/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInstantiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
