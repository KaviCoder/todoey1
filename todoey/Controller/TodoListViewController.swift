//
//  ViewController.swift
//  todoey
//
//  Created by Kavya Joshi on 13/02/19.
//  Copyright © 2019 Kavya Joshi. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    //Array of Item Objects
    var itemArray = [Item]()
    
    //If there is a selected category
    var selectedCategory :Category?
    {
        didSet{
             loaditems()
            
        }
    }
    
   
    
    //Item is object of type NSobject and define the context where the data will be saved
    //singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Filemanager- interface to connect with file system
        //default- singleton --shared urls--search for document directory in user location
        //Since it is an array,fetching the first time from that array
        //add a path component--for encoding
      
    
         let fileDataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(fileDataPath)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //typecating the value for key- "toDoList" as array of String making it optional
        
//       if let items = defaults.array(forKey: "toDoList") as? [Item]
//        {
//           itemArray = items
//        }
        
//        loaditems()
    }
//Mark - Tableview Datasource Methods
    
  //  1) cellFowRow at index path--called initially
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        //Ternary operator
        // value = condition? ValueOfTrue : ValueOfFalse
        
        
        cell.accessoryType =  item.done ? .checkmark : .none
        
    
//        if   item.done == false
//        {
//            cell.accessoryType = .none
//        }
//
//        else {
//            cell.accessoryType = .checkmark
//        }
        
        
        return cell
    }

//  2) number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
 // 3) didselectRow at index path
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //  print(itemArray[indexPath.row])
        
//       if itemArray[indexPath.row].done == false
//       {
//        itemArray[indexPath.row].done = true
//        }
//       else{
//        itemArray[indexPath.row].done = false
//        }
        
       // since the value is boolean
        
        //for deleting in core data, first delete from context and then delete from itemarray and then call context.save
//
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at : indexPath.row)
        
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        
       //Again call delegate methods--cellforrow sat for table
    
        savedata()
        
        //select krke check mark n deselect bhi sona chahie colour
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
  //Mark- Add new Items
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        
        //local variable
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //Add code for for what will happen when user clicks the Add Item buttons
          //  print(textField.text)
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            //Due to relationship created
            newItem.parentCategory = self.selectedCategory
            
            
            self.itemArray.append(newItem)
            
            //Set array values in "defaults" so that they are available between the sessions.
            
//            self.defaults.set(self.itemArray, forKey: "toDoList")
            //03062019-comented the old way and added a new way of NScoding
            self.savedata()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
           alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }

    //It will encode item Arry into and then write the data to the new datafilepath
   func savedata()
   {
    
//    let encoder = PropertyListEncoder()
//    do {
//     let data = try encoder.encode(itemArray)
//        try data.write(to: fileDataPath! )
//    }
//    catch{
//        print("Error: \(error)")
//    }
    
    do{
        try context.save()
    }
    catch {
        print("Error saving context \(error)")
    }
    
        tableView.reloadData()
    }
    
    //decoding at viewdidload
//    func loaditems()
//    {
//        //unwrap the data first
//        if let data = try? Data(contentsOf: fileDataPath!) {
//
//        //Use decorder
//        let decoder = PropertyListDecoder()
//
//        //tell swift the type of data to be fetch
//        do{
//            itemArray = try decoder.decode([Item].self, from: data)
//        }
//        catch{
//            print("Errors:\(error)")
//        }
//    }
    
    
    
//    func loaditems()
//    {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        do{
//            itemArray = try context.fetch(request)
//
//        }
//        catch{
//            print("Error: \(error)")
//        }
    //}

    /*external parameter: with , internal parameters: request, type of rquest is nsfetchrequest to fetch Items from core data through context,default vaue of request when not passed as parametr will be item.fetchrequest...all items will be fetched  */
    
    func loaditems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil )
    {
        
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate,additionalPredicate])
        }
        else
        {
        request.predicate = categorypredicate
        }
        do{
                  itemArray = try context.fetch(request)
            tableView.reloadData()
        }
        catch{
            print("Error: \(error)")
            
        }
    }

}

//todolist class conform to protocols of uisearch

//Mark:- Search button

extension TodoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //make a reqest to fetch items
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        
        
        //query data to retrieve value based on the search
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //Sort data
//        let sortdescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortdescriptor]
        request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
        
        //fetch data from context to itemarray
//        do{
//            itemArray = try context.fetch(request)
//
//        }
//        catch{
//            print("Error fetching data from context \(error)")
//        }
//        tableView.reloadData()
        print(searchBar.text!)
        
        loaditems(with: request, predicate: predicate )
    }
    
    //newdelegate method--if any changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //cross button or clear
        if searchBar.text?.count == 0{
            loaditems()
            
            //notify the object that it has been asked to not to be the first responder of the app
            //cursor from the search bar will be removed,keyboard should go away
            
            //calling the function on foreground--on the main queue.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }

        }
    }
    
    
    
}
