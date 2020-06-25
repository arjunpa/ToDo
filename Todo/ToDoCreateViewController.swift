//
//  ToDoCreateViewController.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

class ToDoCreateViewController: DismissOnTapViewController {

    var viewModel: ToDoCreateViewModelInterface?
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var addPhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func ok() {
        
        self.viewModel?.title = self.titleTextField.text
        self.viewModel?.description = self.descriptionTextView.text
        self.viewModel?.addItem()
    }
    
    @IBAction private func addPhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension ToDoCreateViewController: ToDoCreateViewModelViewDelegate {
    
    func didSucceed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayError(error: Error) {
        guard let displayableError = error as? DisplayError else { return }
        let alertViewController = UIAlertController(title: displayableError.title, message: displayableError.message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension ToDoCreateViewController: UINavigationControllerDelegate {}

extension ToDoCreateViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.viewModel?.imagePickInfo = info
        self.addPhotoButton.setImage(info[.originalImage] as? UIImage, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ToDoCreateViewController: StoryboardInstantiable {}
