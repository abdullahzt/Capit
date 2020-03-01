//
//  TableViewController.swift
//  Capit
//
//  Created by Abdullah on 28/02/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ClassViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var classArray: Results<Class>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        //        tableView.separatorStyle = .none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
        
        let color = UIColor(hexString: "#5b8c85")!
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance().self
            
            appearance.backgroundColor = color
            appearance.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]
            
            navBar.standardAppearance = appearance
            navBar.compactAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.tintColor = ContrastColorOf(color, returnFlat: true)
            
        } else {
            navBar.barTintColor = color
            navBar.tintColor = ContrastColorOf(color, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Class", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Class", style: .default) { (action) in
            
            let newClass = Class()
            newClass.title = textField.text!
            
            self.save(addedClass: newClass)
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alerTextField) in
            alerTextField.placeholder = "Add new Class"
            textField = alerTextField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
            alert.dismiss(animated: true, completion: nil)
            
            
        }))
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableViewManipulation
    
    func save(addedClass: Class) {
        do {
            try realm.write {
                realm.add(addedClass)
            }
        } catch {
            print("Error saving new class: \(error)")
        }
    }
    
    func loadItems() {
        
        classArray = realm.objects(Class.self)
        
        tableView.reloadData()
    }
    
    //MARK: - DeleteDataFromTable
    
    override func updateModel(at indexPath: IndexPath) {
        //        handle action by updating model with deletion
        do {
            try self.realm.write {
                if let classes = self.classArray {
                    self.realm.delete(classes[indexPath.row])
                    //                    self.animatedTableViewReload()
                }
                
            }
        } catch {
            print("Error deleting data \(error)")
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let classToDisplay = classArray?[indexPath.row]
        cell.textLabel?.font = UIFont(name: "RobotoMono-Medium", size: 30)
        cell.textLabel?.text = classToDisplay?.title ?? "No class added yet"
        
        return cell
    }
}
