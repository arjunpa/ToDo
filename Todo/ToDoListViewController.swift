//
//  ToDoListViewController.swift
//  Todo
//
//  Created by Arjun P A on 23/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

private class ToDoCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class ToDoListViewController: UIViewController {
    
    var listViewModel: ToDoListViewInterface?
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.configureTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationItems()
        self.listViewModel?.fetch()
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
        self.tableView.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.reuseIdentifier)
    }
}

extension ToDoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listViewModel?.numberOfItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemViewModel = self.listViewModel?.item(at: indexPath.row) else { return UITableViewCell() }
        let toDoCell = self.tableView.dequeueReusableCell(withIdentifier: ToDoCell.reuseIdentifier, for: indexPath)
        toDoCell.textLabel?.text = itemViewModel.title
        toDoCell.detailTextLabel?.text = itemViewModel.description
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

extension ToDoListViewController: StoryboardInstantiable {}
