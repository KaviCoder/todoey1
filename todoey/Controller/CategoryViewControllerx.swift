//
//  CategoryViewControllerx.swift
//  todoey
//
//  Created by Kavya Joshi on 20/03/19.
//  Copyright © 2019 Kavya Joshi. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewControllerx: UITableViewController {
    
    //Item is object of type NSobject and define the context where the data will be saved
    //singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
       var CategoryArray = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()

        loaditems()
    }

    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //alertcontroller
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        
        // alertaction
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            self.CategoryArray.append(newCategory)
            self.savedata()
            
            
        }
        
        // Add text field on alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        // Add action on alert
        alert.addAction(action)
        present(alert, animated: true,completion: nil)

        
    }
    //Mark :- Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        let cat = CategoryArray[indexPath.row]
        cell.textLabel?.text = cat.name
      
        return cell
    }
    func savedata()
    {
  
        
        do{
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    //Mark :- Tableview Delegate Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryArray.count
    }
    //Mark :- Data Manipulation Methods
    
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //optional index path hence wrap inside let
       if  let indexpath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = CategoryArray[indexpath.row]
        }
    }
    
    
    func loaditems(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do{
            CategoryArray = try context.fetch(request)
            tableView.reloadData()
        }
        catch{
            print("Error: \(error)")

        }
    }
}

