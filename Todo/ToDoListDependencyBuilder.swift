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
        let viewModel = ToDoListViewModel(repository: repository)
        let listViewController: ToDoListViewController = UIStoryboard(storyboardName: .main).instantiateViewController()
        listViewController.listViewModel = viewModel
        viewModel.viewDelegate = listViewController
        return listViewController
    }
}
