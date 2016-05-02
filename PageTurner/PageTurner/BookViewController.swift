//
//  BookViewController.swift
//  PageTurner
//
//  Created by Anjana Rao on 5/2/16.
//  Copyright © 2016 Hoot Industries. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BookViewController : UIViewController{
    var likedBook : NSManagedObject!

    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var isbn: UILabel!
    @IBOutlet weak var synopsis: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        bookTitle.text = likedBook.valueForKey("title") as? String
        isbn.text = likedBook.valueForKey("isbn") as? String
        synopsis.text = likedBook.valueForKey("summary") as? String
        let imageURL = likedBook.valueForKey("image_url") as?String
        let url = NSURL(string: imageURL! as String)
        downloadImage(url!)

    }
    func getData(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        getData(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else {
                    // Something went wrong getting the image out
                    self.imageView.image = UIImage(named: "NoImage.png")
                    return
                }
                let imageTest = UIImage(data: data)
                self.imageView.image = imageTest
            }
        }
    }
}