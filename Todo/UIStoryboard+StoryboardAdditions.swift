//
//  UIStoryboard+StoryboardAdditions.swift
//  Todo
//
//  Created by Arjun P A on 23/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum NamedStoryboard: String {
        case main
        
        var fileName: String {
            return self.rawValue.capitalized
        }
    }
    
    convenience init(storyboardName: NamedStoryboard, bundle: Bundle? = nil) {
        self.init(name: storyboardName.fileName, bundle: bundle)
    }
    
    func instantiateViewController<ViewController: UIViewController>() -> ViewController where ViewController: StoryboardInstantiable {
        guard let viewController = self.instantiateViewController(identifier: ViewController.storyboardIdentifier) as? ViewController else {
            fatalError()
        }
        return viewController
    }
}
