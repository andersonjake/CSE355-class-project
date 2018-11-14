//
//  BookListModel.swift
//  CSE335-class-project
//
//  Created by Jake Anderson on 11/14/18.
//  Copyright © 2018 Jake Anderson. All rights reserved.
//
import UIKit
import CoreData
import Foundation
public class BookListModel
{
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var   fetchResults =   [BookList]()
    
    func fetchRecord() -> Int {
        // Create a new fetch request using the BookList
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookList")
        var x   = 0
        // Execute the fetch request, and cast the results to an array of FruitEnity objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [BookList])!
        
        print(fetchResults)
        
        x = fetchResults.count
        
        print(x)
        
        // return howmany entities in the coreData
        return x
        
        
    }
    
    func addBookList()
    {
        // create a new entity object
        let ent = NSEntityDescription.entity(forEntityName: "BookList", in: self.managedObjectContext)
        //add to the manege object context
        let newBookList = BookList(entity: ent!, insertInto: self.managedObjectContext)
        newBookList.listTitle = "Banana"
        
        // save the updated context
        do {
            try self.managedObjectContext.save()
        } catch _ {
        }
        
        print(newBookList)
    }
    
    func removeBookList(row:Int)
    {
        managedObjectContext.delete(fetchResults[row])
        // remove it from the fetch results array
        fetchResults.remove(at:row)
        
        do {
            // save the updated managed object context
            try managedObjectContext.save()
        } catch {
            
        }
        
    }
    
    func getFruitObject(row:Int) -> BookList
    {
        return fetchResults[row]
    }
    
    func deleteAll()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookList")
        
        // whole fetchRequest object is removed from the managed object context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
            
            
        }
        catch let _ as NSError {
            // Handle error
        }
        
    }
    
    
    
    
}
