//
//  LocalRepository.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol LocalRepository {
    
    associatedtype Entity
    
    func insert(onCompletion: @escaping (Result<Entity, Error> ) -> ())
    
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, onCompletion: @escaping (Result<[Entity], Error>) -> ())
    
    func save() throws
}
