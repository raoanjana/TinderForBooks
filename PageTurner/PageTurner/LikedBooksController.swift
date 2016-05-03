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
    var likedBooks = [NSManagedObject]()
    var likedBook : NSManagedObject!
    
    required init?(coder aDecoder: NSCoder) {
        // initialize properties here
        super.init(coder : aDecoder)
    }
    
    override func viewDidLoad() {
        print("loaded")
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let allLikedBooks = HelperMethods().getAllLikedBooks() {
            self.likedBooks = allLikedBooks
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return likedBooks.count
        return likedBooks.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let book = likedBooks[indexPath.row]
            HelperMethods().deleteFromCoreData(book.valueForKey("asin") as! String)
            likedBooks.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LikedBookCell", forIndexPath: indexPath) as UITableViewCell
        
        let book = likedBooks[indexPath.row]
        cell.textLabel!.text = book.valueForKey("title") as? String
        
       // set the cell imageview
//        cell.imageView
        let url = NSURL(string: book.valueForKey("image_url") as! String)
        downloadImage(url!, cell: cell)
        //initalizes imageview
        
        return cell
    }
    
    func getData(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL, cell : UITableViewCell){
        getData(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else {
                    // Something went wrong getting the image out
                    cell.imageView!.image = UIImage(named: "NoImage.png")
                    return
                }
                let imageTest = UIImage(data: data)
                cell.imageView!.image = imageTest
            }
        }
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let book = likedBooks[indexPath.row]
        likedBook = book
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "bookSegue") {
            print("transitioning")
            let destinationVC = (segue.destinationViewController as! BookViewController)
            destinationVC.likedBook = likedBook

        }
    }
}