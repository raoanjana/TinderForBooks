//
//  HelperMethods.swift
//  PageTurner
//
//  Created by Hayden Schmackpfeffer on 5/2/16.
//  Copyright © 2016 Hoot Industries. All rights reserved.
//

import Foundation
import CoreData

class HelperMethods {
    
    func getAllLikedBooks() -> [NSManagedObject]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "LikedBook")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
    }
    
    private func deleteAsinFromCoreData(asin: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchPredicate = NSPredicate(format: "asin == %@", asin)
        
        let fetchAsin                      = NSFetchRequest(entityName: "PreviouslyLiked")
        fetchAsin.predicate                = fetchPredicate
        fetchAsin.returnsObjectsAsFaults   = false
        
        do{
            let fetchedAsins = try managedContext.executeFetchRequest(fetchAsin) as! [NSManagedObject]
            for fetchedAsin in fetchedAsins {
                managedContext.deleteObject(fetchedAsin)
            }
            
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    private func deleteLikedBookFromCoreData(asin: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchPredicate = NSPredicate(format: "asin == %@", asin)
        
        let fetchBooks                      = NSFetchRequest(entityName: "LikedBook")
        fetchBooks.predicate                = fetchPredicate
        fetchBooks.returnsObjectsAsFaults   = false
        
        do{
            let fetchedBooks = try managedContext.executeFetchRequest(fetchBooks) as! [NSManagedObject]
            for fetchedBook in fetchedBooks {
                managedContext.deleteObject(fetchedBook)
            }
            
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func deleteFromCoreData(asin: String) {
        deleteAsinFromCoreData(asin)
        deleteLikedBookFromCoreData(asin)
    }
}