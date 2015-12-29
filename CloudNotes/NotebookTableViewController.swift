//
//  NotebookTableViewController.swift
//  CloudNotes
//
//  Created by Tim Pryor on 2015-12-15.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

import UIKit
import CoreData


class NotebookTableViewController: UITableViewController {

    var moc: NSManagedObjectContext!
    var notebookArray = [Notebook]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Waiting for iCloud"
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            moc = context
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "persistentStoreDidChange",
            name: NSPersistentStoreCoordinatorStoresDidChangeNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "persistentStoreWillChange:",
            name: NSPersistentStoreCoordinatorStoresWillChangeNotification,
            object: moc.persistentStoreCoordinator
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "receiveICloudChanges",
            name: NSPersistentStoreDidImportUbiquitousContentChangesNotification,
            object: moc.persistentStoreCoordinator)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: NSPersistentStoreCoordinatorStoresDidChangeNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: NSPersistentStoreCoordinatorStoresWillChangeNotification,
            object: moc.persistentStoreCoordinator
        )
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: NSPersistentStoreDidImportUbiquitousContentChangesNotification,
            object: moc.persistentStoreCoordinator)
        
    }
    
    func persistentStoreDidChange() {
        // re-enable UI and fetch data
        self.navigationItem.title = "iCloud ready"
        self.navigationItem.rightBarButtonItem?.enabled = true
        
        //loadData()
        
    }
    
    func persistentStoreWillChange(notification:NSNotification) {
        self.navigationItem.title = "Changes in progress"
        // disable the
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        moc.performBlock { () -> Void in
        // 41 min
            if self.moc.hasChanges {
                var error: NSError? = nil
                self.moc.save(&error)
                if error != nil {
                    println("Save error: \(error)")
                    
                } else {
                    // drop any managed object references
                    self.moc.reset()
                }
            }
        }
    }
    
    func recieveICloudChanges (notification:NSNotification) {
        moc.performBlock { () -> Void in
            self.moc.mergeChangesFromContextDidSaveNotification(notification)
            // loadData()
    
        }
    }
    
    
    @IBAction func addNotebook(sender: AnyObject) {
        
        let addNotebookAlert = UIAlertController(title: "New Notebook", message: "Enter notebook title", preferredStyle: UIAlertControllerStyle.Alert)
        addNotebookAlert.addTextFieldWithConfigurationHandler(nil)
        addNotebookAlert.addAction(UIAlertAction(title: "Save Notebook", style: UIAlertActionStyle.Default, handler: { (alertAction:UIAlertAction!) -> Void in
            let textField = addNotebookAlert.textFields?.last as! UITextField
            if textField.text != "" {
                let notebook = CoreDataHelper.insertManagedObject(NSStringFromClass(Notebook), managedObjectContext: self.moc) as! Notebook
                notebook.creationDate = NSDate()
                self.moc.save(nil)
                // loadData()
            }
        }))
        
        addNotebookAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))

    }
    
    func loadData() {
        notebookArray = [Notebook]()
        notebookArray = CoreDataHelper.fetchEntities(NSStringFromClass(Notebook), managedObjectContext: moc, predicate: nil) as! [Notebook]
        
        self.tableView.reloadData()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return notebookArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        
        cell.textLabel?.text = notebookArray[indexPath.row].title

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
