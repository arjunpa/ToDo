//
//  ToDoListDependencyBuilder.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit
import CoreData

class ToDoListDependencyBuilder {
    
    static func buildDependencies() -> ToDoListViewController {
        let repository = CoreDataRepository<ToDo>(contextStore: CoreDataContext.shared)
        let viewModel = ToDoListViewModel(repository: repository, directoryPathGenerator: DirectoryPathGenerator(directory: .document))
        let listViewController: ToDoListViewController = UIStoryboard(storyboardName: .main).instantiateViewController()
        listViewController.listViewModel = viewModel
        viewModel.viewDelegate = listViewController
        return listViewController
    }
}

class ToDoCreateDependencyBuilder {
    
    static func buildDependencies() -> ToDoCreateViewController {
        let todoCreateViewController: ToDoCreateViewController = UIStoryboard(storyboardName: .main).instantiateViewController()
        let repository = ToDoCreateRepository(coreDataRepository: CoreDataRepository<ToDo>(contextStore: CoreDataContext.shared))
        let imageHandler = ImagePickHandler.init(pathGenerator: DirectoryPathGenerator(directory: .document), quality: 0.8)
        let viewModel = ToDoCreateViewModel(repository: repository,
                                            imageHandler: imageHandler)
        todoCreateViewController.viewModel = viewModel
        viewModel.viewDelegate = todoCreateViewController
        return todoCreateViewController
    }
}
