//
//  Recommender.swift
//  PageTurner
//
//  Created by Hayden Schmackpfeffer on 4/30/16.
//  Copyright © 2016 Hoot Industries. All rights reserved.
//

import Foundation
import CoreData

struct APIConfig {
    static let baseURL : String = "http://ec2-54-218-12-101.us-west-2.compute.amazonaws.com"
    static let endpoint: String = "/recommend"
}

class Recommender {
    
    // return a list of books that are similar to previously liked books
    func getRandomRecommendations(first : Bool, completionHandler: (([Book]?, NSError?) -> Void)!) -> Void {
        print("getting random recommendations")
        var asins : String
        if let params = self.getRandomAsinsFromCoreData() {
            asins = params
        } else {
            asins = self.getCalibrationAsins()
        }
        
        print("querying = \(asins)")
        
        let query = APIConfig.baseURL + APIConfig.endpoint + "?" + asins
        
        let url: NSURL = NSURL(string: query.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())! )!
        
        let sessionConfiguartion: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session: NSURLSession = NSURLSession(configuration: sessionConfiguartion)
        
        let dataTask = session.dataTaskWithURL(url) {
            data, response, error in
            
            if error != nil {
                print("error getting data from API")
                completionHandler(nil, error)
                print(error?.code)
                return
            } else {
                print("getting new reviews")
                completionHandler(self.parseDataIntoBooks(data), nil)
            }
        }
        
        dataTask.resume()
    }
    
    // returns a random length string of
    // asinN=????&asinN+1=????? and so on (up to asin5=???
    func getRandomAsinsFromCoreData() -> String? {
        let numParams = Int(arc4random_uniform(UInt32(5))) + 1

        var queryString : String = ""
        
        guard var previousBooks : [NSManagedObject] = HelperMethods().getAllLikedBooks() else {
            return nil
        }
        
        if previousBooks.count < 1 {
            return nil
        }
        
        
        for index in 1...numParams {
            let randomIndex : Int = Int(arc4random_uniform(UInt32(previousBooks.count)))
            let asin = previousBooks[randomIndex].valueForKey("asin") as! String
            previousBooks.removeAtIndex(randomIndex)
            
            if (index > 1) {
                queryString += "&"
            }
            queryString += "asin\(index)=\(asin)"
        }
        
        return queryString
    }
    
    func parseDataIntoBooks(data : NSData?) -> [Book]? {
        do {
            // Try and parse the data, this will fail
            let arr : NSArray =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSArray
        
            var bookArray : [Book] = [Book]()
        
            for dataObject : AnyObject in arr {
                if let data = dataObject as? NSDictionary {
                    // parse the returned json
                    guard let asin = data["asin"] as? NSString else {
                        continue
                    }
                    guard let author = data["author"] as? NSString else {
                        continue
                    }
                    guard let description = data["description"] as? NSString else {
                        continue
                    }
                    guard let image_url = data["image_url"] as? NSString else {
                        continue
                    }
                    guard let isbn = data["isbn"] as? NSString else {
                        continue
                    }
                    guard let title = data["title"] as? NSString else {
                        continue
                    }
                    
                    // check if it exists in previously liked
                    if doesAsinExist(asin as String) {
//                        print("trimming because title already viewed:  \(title)")
                        continue
                    } else {
                        self.saveAsin(asin)
                    }
//                    print("adding \(title)")
                    bookArray.append(Book(title: title, author: author, imageURL: image_url, summary: description, isbn: isbn, asin: asin, instruction: false))
                }
            }
            print("\(bookArray.count) books added")
            return bookArray
        } catch {
            print("json error: \(error)")
            return nil
        }
    }
    
    // queries all the previously liked books to see if the ASIN has previously been seen
    func doesAsinExist(asinToCompare: String) -> Bool {
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let managedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "PreviouslyLiked")
        
        do{
            if let entities = try managedObjectContext.executeFetchRequest(request) as? [NSManagedObject] {
                for asin in entities {
                    if let theAsin = asin.valueForKey("asin") as? String {
                        if theAsin == asinToCompare {
//                            print("comparing stored asin \(theAsin) to \(asinToCompare)")
                            return true
                        }
                    }
                }
                return false
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
        print("SHOULD NEVER GET THIS MESSAGE")
        return false
    }
    
    func saveAsin(asin : NSString) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("PreviouslyLiked", inManagedObjectContext: managedContext)
        let asinToSave = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        asinToSave.setValue(asin as String, forKey: "asin")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // return a varied set of books to find recommendations between
    func getCalibrationAsins() -> String {
        return "asin1=059035342X&asin2=0312944926&asin3=1400079985&asin4=0316306053&asin5=0143038583"
    }
}