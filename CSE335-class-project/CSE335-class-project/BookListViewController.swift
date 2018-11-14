//
//  BookListViewController.swift
//  CSE335-class-project
//
//  Created by Jake Anderson on 11/14/18.
//  Copyright © 2018 Jake Anderson. All rights reserved.
//


import UIKit
import CoreData

class BookListViewController: UIViewController {
    @IBOutlet weak var list_title: UILabel!
    @IBOutlet weak var bookListTable: UITableView!
    var bModel: BookListModel = BookListModel();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func add_book_list(_ sender: UIBarButtonItem) {
        
        bModel.addBookList()
        // reload the table with added row
        bookListTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // number of rows based on the coredata storage
        return bModel.fetchRecord()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // add each row from coredata fetch results
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.layer.borderWidth = 1.0
        
        let rowdata = bModel.getFruitObject(row: indexPath.row)
        
        cell.textLabel?.text = rowdata.listTitle
        
        
        
        return cell
    }
    
    // delete table entry
    // this method makes each row editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    // return the table view style as deletable
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell.EditingStyle { return UITableViewCell.EditingStyle.delete }
    
    
    // implement delete function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if editingStyle == .delete
        {
            
            bModel.removeBookList(row: indexPath.row)
            // reload the table after deleting a row
            bookListTable.reloadData()
        }
        
    }
    
    
    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        
        bModel.deleteAll()
        bookListTable.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
