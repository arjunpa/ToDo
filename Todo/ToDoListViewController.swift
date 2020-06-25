//
//  ToDoListViewController.swift
//  Todo
//
//  Created by Arjun P A on 23/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

final class ToDoListViewController: DismissOnTapViewController {
    
    var listViewModel: ToDoListViewInterface?
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.configureTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationItems()
        self.listViewModel?.fetch(with: nil)
    }
    
    private func setupNavigationItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
    }
    
    @objc private func addItem() {
        self.present(ToDoCreateDependencyBuilder.buildDependencies(), animated: true, completion: nil)
    }
    
    private func configureTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 40.0
        self.tableView.register(UINib(nibName: ToDoCell.nibName, bundle: nil), forCellReuseIdentifier: ToDoCell.reuseIdentifier)
    }
}

extension ToDoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listViewModel?.numberOfItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemViewModel = self.listViewModel?.item(at: indexPath.row),
              let toDoCell = self.tableView.dequeueReusableCell(withIdentifier: ToDoCell.reuseIdentifier, for: indexPath) as? ToDoCell
              else { return UITableViewCell() }
        toDoCell.viewDelegate = self
        toDoCell.configure(with: itemViewModel)
        return toDoCell
    }
}

extension ToDoListViewController: ToDoListViewDelegate {
    
    func updateView() {
        self.tableView.reloadData()
    }
    
    func displayError(error: Error) {
        // Handle error here
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.listViewModel?.fetch(with: searchText)
    }
}

extension ToDoListViewController: ToDoCellViewDelegate {
    
    func didSelectCell(_ cell: ToDoCell, with selection: Bool) {
        guard let row = self.tableView.indexPath(for: cell)?.row else { return }
        self.listViewModel?.updateSelection(selection, at: row)
    }
}

extension ToDoListViewController: StoryboardInstantiable {}
