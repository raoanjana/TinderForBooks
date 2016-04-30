//
//  Book.swift
//  PageTurner
//
//  Created by Anjana Rao on 4/29/16.
//  Copyright © 2016 Hoot Industries. All rights reserved.
//

import Foundation
import UIKit

class Book: NSObject{
    let title : NSString
    let author : NSString
    let imageURL : NSString
    let summary : NSString
    let isbn : NSString
    let asin :NSString
    
    init(title: NSString?, author: NSString?, imageURL: NSString?, summary: NSString?, isbn : NSString, asin : NSString){
        self.title = title ?? ""
        self.author = author ?? ""
        self.imageURL = imageURL ?? ""
        self.summary = summary ?? ""
        self.isbn = isbn ?? ""
        self.asin = asin ?? ""
    }
    
}