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
}