//
//  ToDoCreateViewController.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

class ToDoCreateViewController: UIViewController {

    var viewModel: ToDoCreateViewModelInterface?
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func resignKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction private func cancel() {
        self.resignKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func ok() {
        
        func handleResult(result: Result<Void, Error>) {
            switch result {
            case .success:
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                guard let displayableError = error as? DisplayError else { return }
                let alertViewController = UIAlertController(title: displayableError.title, message: displayableError.message, preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertViewController, animated: true, completion: nil)
            }
        }
        
        self.viewModel?.addItem(ToDoViewModel(title: self.titleTextField.text, description: self.descriptionTextView.text),
                                completion: { [weak self] result in
            guard self != nil else { return }
            handleResult(result: result)
        })
    }
}

extension ToDoCreateViewController: StoryboardInstantiable {}