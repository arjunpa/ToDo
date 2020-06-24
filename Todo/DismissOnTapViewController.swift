//
//  DismissOnTapViewController.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

class DismissOnTapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func resignKeyboard() {
        self.view.endEditing(true)
    }
}
