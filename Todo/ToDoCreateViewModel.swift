//
//  ToDoCreateViewModel.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol ToDoCreateViewModelInterface {
    func addItem(_ item: ToDoViewModel, completion: @escaping (Result<Void, Error>) -> ())
}

class ToDoCreateViewModel: ToDoCreateViewModelInterface {
    
    private let repository: ToDoCreateRepository
    
    init(repository: ToDoCreateRepository) {
        self.repository = repository
    }
    
    func addItem(_ item: ToDoViewModel, completion: @escaping (Result<Void, Error>) -> ()) {
        guard let title = item.title, let description = item.description else { return }
        self.repository.addItem(with: title, description: description) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure:
                completion(.failure(DisplayError.general))
            }
        }
    }
}
