//
//  ToDoCreateViewModel.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol ToDoCreateViewModelViewDelegate: class {
    func didSucceed()
    func displayError(error: Error)
}

protocol ToDoCreateViewModelInterface {
    var title: String? { get set }
    var description: String? { get set }
    var imagePickInfo: Any? { get set }
    func addItem()
}

struct ToDoItem {
    let title: String?
    let description: String?
}

final class ToDoCreateViewModel: ToDoCreateViewModelInterface {
    
    var title: String?
    
    var description: String?
    
    var imagePickInfo: Any?
    
    weak var viewDelegate: ToDoCreateViewModelViewDelegate?
    
    private var imageRelativePath: String?
    
    private let repository: ToDoCreateRepository
    
    private let imageHandler: ImagePickHandler
    
    init(repository: ToDoCreateRepository, imageHandler: ImagePickHandler) {
        self.repository = repository
        self.imageHandler = imageHandler
    }
    
    func addItem() {
        
        let completion: (Result<Void, Error>) -> () = { result in
            switch result {
            case .success(()):
                self.viewDelegate?.didSucceed()
            case .failure:
                self.viewDelegate?.displayError(error: DisplayError.general)
            }
        }
        
        if let imageInfo = self.imagePickInfo {
            self.imageHandler.handleImage(from: imageInfo) { result in
                switch result {
                case .success(let relativePath):
                    self.imageRelativePath = relativePath
                case .failure:
                    self.viewDelegate?.displayError(error: DisplayError.general)
                }
                self.add(completion: completion)
            }
        } else {
            self.add(completion: completion)
        }
    }
    
    private func add(completion: @escaping (Result<Void, Error>) -> ()) {
        guard let title = self.title, let description = self.description else {
            self.viewDelegate?.displayError(error: DisplayError.general)
            return
        }
        self.repository.addItem(with: title, description: description, imagePath: self.imageRelativePath) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure:
                completion(.failure(DisplayError.general))
            }
        }
    }
}
