//
//  UITableViewCell+ReusableIdentifier.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

protocol ReuseIdentifier {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifier where Self: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifier {}
