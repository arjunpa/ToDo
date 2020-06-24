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
    func fetch()
}

protocol ToDoListViewDelegate: class {
    func updateView()
    func displayError(error: Error)
}

class ToDoListViewModel: NSObject {
    
    private let repository: CoreDataRepository<ToDo>
    private var fetchResultsController: NSFetchedResultsController<ToDo>?
    
    weak var viewDelegate: ToDoListViewDelegate?
    
    init(repository: CoreDataRepository<ToDo>) {
        self.repository = repository
        super.init()
    }
}

extension ToDoListViewModel: ToDoListViewInterface {
    
    var numberOfItems: Int {
        return self.fetchResultsController?.fetchedObjects?.count ?? 0
    }
    
    func item(at index: Int) -> ToDoViewModel? {
        guard let toDoManagedObject = self.fetchResultsController?.object(at: IndexPath(row: index, section: 0)) else { return nil }
        return ToDoViewModel(title: toDoManagedObject.toDoTitle, description: toDoManagedObject.toDoDescription)
    }
    
    func fetch() {
        self.repository.onReady = { [weak self] readyState in
            switch readyState {
            case .ready:
                self?.configureFetchController()
                try? self?.fetchResultsController?.performFetch()
            case .failure:
                self?.viewDelegate?.displayError(error: DisplayError.general)
            }
        }
    }
    
    private func configureFetchController() {
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateTime", ascending: false)]
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: repository.contextStore.viewContext,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        self.fetchResultsController?.delegate = self
    }
}

extension ToDoListViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.viewDelegate?.updateView()
    }
}
