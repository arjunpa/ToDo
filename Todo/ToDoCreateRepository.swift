//
//  ToDoCreateRepository.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

final class ToDoCreateRepository {
    
    private let repository: CoreDataRepository<ToDo>
    
    init(coreDataRepository: CoreDataRepository<ToDo>) {
        self.repository = coreDataRepository
    }
    
    func addItem(with title: String, description: String, imagePath: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        self.repository.insert { result in
            switch result {
            case .success(let toDo):
                toDo.toDoTitle = title
                toDo.toDoDescription = description
                toDo.uuid = UUID().uuidString
                toDo.dateTime = Date()
                toDo.imagePath = imagePath
                toDo.completed = false
                do {
                    try self.repository.save()
                    completion(.success(()))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
