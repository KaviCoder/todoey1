//
//  ViewController.swift
//  todoey
//
//  Created by Kavya Joshi on 13/02/19.
//  Copyright © 2019 Kavya Joshi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    //Array of Item Objects
    var itemArray = [Item]()
    
    let fileDataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Filemanager- interface to connect with file system
        //default- singleton --shared urls--search for document directory in user location
        //Since it is an array,fetching the first time from that array
        //add a path component--for encoding
      
        
        let newItem = Item()
        newItem.title = "Discussion"
        itemArray.append(newItem)

        let newItem1 = Item()
        newItem1.title = "Discussion1"
        itemArray.append(newItem1)

        let newItem2 = Item()
        newItem2.title = "Discussion2"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Discussion3"
        itemArray.append(newItem3)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //typecating the value for key- "toDoList" as array of String making it optional
        
//       if let items = defaults.array(forKey: "toDoList") as? [Item]
//        {
//           itemArray = items
//        }
        
        
        loaditems()
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
            print(textField.text)
            
            let newItem = Item()
            newItem.title = textField.text!
            
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
    
    let encoder = PropertyListEncoder()
    do {
     let data = try encoder.encode(itemArray)
        try data.write(to: fileDataPath! )
    }
    catch{
        print("Error: \(error)")
    }
        tableView.reloadData()
    }
    
    //decoding at viewdidload
    func loaditems()
    {
        //unwrap the data first
        if let data = try? Data(contentsOf: fileDataPath!) {
        
        //Use decorder
        let decoder = PropertyListDecoder()
            
        //tell swift the type of data to be fetch
        do{
            itemArray = try decoder.decode([Item].self, from: data)
        }
        catch{
            print("Errors:\(error)")
        }
    }
    }
}

