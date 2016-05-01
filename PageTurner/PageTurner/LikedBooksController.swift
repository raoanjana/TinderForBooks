//
//  LikedBooksController.swift
//  PageTurner
//
//  Created by Hayden Schmackpfeffer on 5/1/16.
//  Copyright © 2016 Hoot Industries. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LikedBooksController : UITableViewController {
    var source :[ Book]
    var likedBooks = [NSManagedObject]()
    
    required init?(coder aDecoder: NSCoder) {
        // initialize properties here
        source = [Book]()
        super.init(coder : aDecoder)
    }
    
    override func viewDidLoad() {
        print("loaded")
<<<<<<< HEAD
=======
//        self.saveBook(Book(title: "Welcome to PageTurner!", author: "Test author 1", imageURL: "www.xyz", summary: "the end", isbn: "111114441", asin: "10142978X"))
//        self.saveBook(Book(title: "Instructions", author: "huck fin 1", imageURL: "www.xyz", summary: "the beginnimng", isbn: "111413441", asin: "ASaSFA334"))
>>>>>>> fa3296be32f7fdb4cb60b5e2cbe90068e29a748d
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
<<<<<<< HEAD
        
=======
>>>>>>> fa3296be32f7fdb4cb60b5e2cbe90068e29a748d
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "LikedBook")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            likedBooks = results as! [NSManagedObject]
<<<<<<< HEAD
            self.tableView.reloadData()
=======
>>>>>>> fa3296be32f7fdb4cb60b5e2cbe90068e29a748d
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return likedBooks.count
        return likedBooks.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LikedBookCell", forIndexPath: indexPath) as UITableViewCell
        
        let book = likedBooks[indexPath.row]
        
        cell.textLabel!.text = book.valueForKey("title") as? String
        
        // set the cell imageview
        // cell.imageView
        
        return cell
    }

}