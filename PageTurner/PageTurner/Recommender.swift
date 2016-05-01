//
//  Recommender.swift
//  PageTurner
//
//  Created by Hayden Schmackpfeffer on 4/30/16.
//  Copyright © 2016 Hoot Industries. All rights reserved.
//

import Foundation

struct APIConfig {
    static let baseURL : String = "http://ec2-54-218-12-101.us-west-2.compute.amazonaws.com"
    static let endpoint: String = "/recommend"
    static let b1 = "asin1"
    static let b2 = "asin2"
    static let b3 = "asin3"
    static let b4 = "asin4"
    static let b5 = "asin5"
}

class Recommender {
    func getRandomRecommendations(first : Bool, completionHandler: (([Book]?, NSError?) -> Void)!) -> Void {
        let query = APIConfig.baseURL + APIConfig.endpoint + "?" + APIConfig.b1 + "=" + "059035342X" + "&" + APIConfig.b2 + "=015216250X"
        
        let url: NSURL = NSURL(string: query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
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
                completionHandler(self.parseDataIntoBooks(data), nil)
            }
        }
        
        dataTask.resume()
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
                
                    bookArray.append(Book(title: title, author: author, imageURL: image_url, summary: description, isbn: isbn, asin: asin))
                }
            }
            return bookArray
        } catch {
            print("json error: \(error)")
            return nil
        }
    }
}