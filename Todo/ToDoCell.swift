//
//  ToDoCell.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

protocol ToDoCellViewDelegate: class {
    func didSelectCell(_ cell: ToDoCell, with selection: Bool)
}

class ToDoCell: UITableViewCell {
    
    private enum Constants {
        static let checkBoxSelectedImage = "checkbox_checked"
        static let checkBoxUnSelectedImage = "checkbox_unchecked"
    }
    
    @IBOutlet private weak var titleTextLabel: UILabel!
    @IBOutlet private weak var descriptionTextLabel: UILabel!
    @IBOutlet private weak var checkMarkButton: UIButton! {
        didSet {
            self.checkMarkButton.setImage(UIImage(named: Constants.checkBoxSelectedImage), for: .selected)
            self.checkMarkButton.setImage(UIImage(named: Constants.checkBoxUnSelectedImage), for: .normal)
        }
    }
    
    weak var viewDelegate: ToDoCellViewDelegate?

    var titleText: String? {
        get {
            return self.titleTextLabel.text
        }
        set {
            self.titleTextLabel.text = newValue
        }
    }
    
    var descriptionText: String? {
        get {
            return self.descriptionTextLabel.text
        }
        set {
            self.descriptionTextLabel.text = newValue
        }
    }
    
    var isCheckBoxSelected: Bool {
        get {
            return self.checkMarkButton.isSelected
        }
        set {
            self.checkMarkButton.isSelected = newValue
        }
    }
    
    func configure(with viewModel: ToDoViewModel) {
        self.titleText = viewModel.title
        self.descriptionText = viewModel.description
        self.isCheckBoxSelected = viewModel.completed
    }
    
    @IBAction private func checkboxSelected() {
        self.checkMarkButton.isSelected = !self.checkMarkButton.isSelected
        self.viewDelegate?.didSelectCell(self, with: self.checkMarkButton.isSelected)
    }
}
