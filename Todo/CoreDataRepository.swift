//
//  CoreDataRepository.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import CoreData

class CoreDataRepository<T: NSManagedObject>: LocalRepository {
    
    enum ReadyState {
        case ready
        case failure(Error)
    }
    
    typealias OnReady = (ReadyState) -> ()
    
    typealias Entity = T
    
    enum DataError: Error {
        case storeError
    }
    
    let contextStore: CoreDataContext
    
    var onReady: OnReady? {
        didSet {
            self.contextStore.onLoad = { [weak self] loadState in
                switch loadState {
                case .success:
                    self?.onReady?(.ready)
                case .failed(_):
                    self?.onReady?(.failure(DataError.storeError))
                }
            }
        }
    }
    
    init(contextStore: CoreDataContext) {
        self.contextStore = contextStore
    }
}

extension CoreDataRepository {
    
    func insert(onCompletion: @escaping (Result<Entity, Error> ) -> ()) {
        
        self.contextStore.onLoad = { [weak self] loadState in
            if case CoreDataContext.ContextStoreLoadState.failed(_) = loadState {
                onCompletion(.failure(DataError.storeError))
                return
            }
            guard let backgroundContext = self?.contextStore.backgroundContext else { return }
            guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: Entity.self), into: backgroundContext) as? Entity else {
                onCompletion(.failure(DataError.storeError))
                return
            }
            return onCompletion(.success(managedObject))
        }
    }
    
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, onCompletion: @escaping (Result<[Entity], Error>) -> ()) {
        self.contextStore.onLoad = { [weak self] loadState in
            if case CoreDataContext.ContextStoreLoadState.failed(_) = loadState {
                onCompletion(.failure(DataError.storeError))
                return
            }
            let fetchRequest = Entity.fetchRequest()
            fetchRequest.sortDescriptors = sortDescriptors
            fetchRequest.predicate = predicate
            do {
                if let results = try self?.contextStore.backgroundContext.fetch(fetchRequest) as? [Entity] {
                    onCompletion(.success(results))
                } else {
                    onCompletion(.failure(DataError.storeError))
                }
            } catch let error {
                 onCompletion(.failure(error))
            }
        }
    }
    
    func performUpdates(with objectID: NSManagedObjectID, updates: (T) -> (), onError: (Error) -> ()) {
        guard let toDo = self.contextStore.backgroundContext.object(with: objectID) as? T else { return }
        updates(toDo)
        do {
            try self.save()
        } catch let error {
            onError(error)
        }
    }
    
    func save() throws {
        if self.contextStore.backgroundContext.hasChanges {
            do {
                try self.contextStore.backgroundContext.save()
            } catch let error {
                throw error
            }
        }
    }
}
