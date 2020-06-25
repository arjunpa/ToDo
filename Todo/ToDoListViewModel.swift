//
//  ToDoListViewModel.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import CoreData

protocol ToDoListViewInterface {
    var numberOfItems: Int { get }
    func item(at index: Int) -> ToDoViewModel?
    func fetch(with queryString: String?)
    func updateSelection(_ selection: Bool, at index: Int)
}

protocol ToDoListViewDelegate: class {
    func updateView()
    func displayError(error: Error)
}

class ToDoListViewModel: NSObject {
    
    private let repository: CoreDataRepository<ToDo>
    private let directoryPathGenerator: DirectoryPathGenerator
    private var fetchResultsController: NSFetchedResultsController<ToDo>?
    
    weak var viewDelegate: ToDoListViewDelegate?
    
    init(repository: CoreDataRepository<ToDo>, directoryPathGenerator: DirectoryPathGenerator) {
        self.repository = repository
        self.directoryPathGenerator = directoryPathGenerator
        super.init()
    }
}

extension ToDoListViewModel: ToDoListViewInterface {
    
    var numberOfItems: Int {
        return self.fetchResultsController?.fetchedObjects?.count ?? 0
    }
    
    func item(at index: Int) -> ToDoViewModel? {
        guard let toDoManagedObject = self.fetchResultsController?.object(at: IndexPath(row: index, section: 0)) else { return nil }
        var path: String? = nil
        if  let imagePath = toDoManagedObject.imagePath {
            path = self.directoryPathGenerator.buildPath(for: imagePath)
        }
        return ToDoViewModel(title: toDoManagedObject.toDoTitle,
                             description: toDoManagedObject.toDoDescription,
                             imagePath: path,
                             uuid: toDoManagedObject.uuid,
                             completed: toDoManagedObject.completed)
    }
    
    func fetch(with queryString: String?) {
        self.repository.onReady = { [weak self] readyState in
            switch readyState {
            case .ready:
                self?.configureFetchController(with: self?.predicate(with: queryString))
                try? self?.fetchResultsController?.performFetch()
                self?.viewDelegate?.updateView()
            case .failure:
                self?.viewDelegate?.displayError(error: DisplayError.general)
            }
        }
    }
    
    func updateSelection(_ selection: Bool, at index: Int) {
        guard let toDo = self.fetchResultsController?.object(at: IndexPath(row: index, section: 0)) else { return }
        self.repository.performUpdates(with: toDo.objectID, updates: { toDoToBeUpdated in
            toDoToBeUpdated.completed = selection
        }) { [weak self] error in
            self?.viewDelegate?.displayError(error: DisplayError.general)
        }
    }
    
    private func predicate(with queryString: String?) -> NSPredicate? {
        guard let queryString = queryString?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), !queryString.isEmpty else {
            return nil
        }
        return NSPredicate(format: "toDoTitle CONTAINS[cd] %@", queryString)
    }
    
    private func configureFetchController(with predicate: NSPredicate?) {
        if self.fetchResultsController == nil {
            let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "completed", ascending: true),
                                            NSSortDescriptor(key: "dateTime", ascending: false)]
            self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                     managedObjectContext: repository.contextStore.viewContext,
                                                                     sectionNameKeyPath: nil,
                                                                     cacheName: nil)
            self.fetchResultsController?.delegate = self
        } else {
            self.fetchResultsController?.fetchRequest.predicate = predicate
        }
    }
}

extension ToDoListViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.viewDelegate?.updateView()
    }
}
