//
//  ViewController.swift
//  ToDo
//
//  Created by Arghadeep Chakraborty on 19/08/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var items = [ToDoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do List"
        getAllItems()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
    }
    
    @objc private func addButtonAction() {
        let alert = UIAlertController(title: "New Item", message: "Enter Item Here..", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "ADD", style: .cancel, handler: { [weak self] _ in
            guard let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty else {
                return
            }
            self?.addNewItem(title: text)
            
        }))
        
        present(alert, animated: true)
    }


    //MARK: - Core Data
    func getAllItems() {
        do {
            guard let context = context else {
                return
            }
            items = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //errors
        }
        
    }
    
    func addNewItem(title: String) {
        guard let context = context else {
            return
        }
        let item = ToDoListItem(context: context)
        item.title = title
        item.timeStamp = Date()
        
        do {
            try context.save()
            getAllItems()
        } catch {
            //errors
        }
        
    }
    
    func deleteItem(item: ToDoListItem) {
        guard let context = context else {
            return
        }
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch {
            //errors
        }
    }
    
    func updateItem(item: ToDoListItem, title: String) {
        guard let context = context else {
            return
        }
        item.title = title
        do {
            try context.save()
            getAllItems()
        } catch {
            //errors
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        let sheet = UIAlertController(title: "The Edit Menu", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
            let alert = UIAlertController(title: "Edit your item", message: "Enter New Item Here..", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.title
            alert.addAction(UIAlertAction(title: "SAVE", style: .cancel, handler: { [weak self] _ in
                guard let textField = alert.textFields?.first, let newTitle = textField.text, !newTitle.isEmpty else {
                    return
                }
                self?.updateItem(item: item, title: newTitle)
                
            }))
            
            self?.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        present(sheet, animated: true)
    }
}

