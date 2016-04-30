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
    
    init(title: NSString?, author: NSString?, imageURL: NSString?){
        self.title = title ?? ""
        self.author = author ?? ""
        self.imageURL = imageURL ?? ""
    }
    
}