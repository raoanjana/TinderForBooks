//
//  ChooseBookView.swift
//  PageTurner
//
//  Created by Anjana Rao on 4/29/16.
//  Copyright © 2016 Hoot Industries. All rights reserved.
//

import Foundation
import UIKit
import MDCSwipeToChoose

class ChooseBookView: MDCSwipeToChooseView {
    let ChooseBookViewImageLabelWidth:CGFloat = 42.0
    var book: Book!
    var titleLabel: UILabel!
    var informationView: UIView!
    var image: UIImageView!
    
    init(frame: CGRect, book: Book, options: MDCSwipeToChooseViewOptions){
        super.init(frame: frame, options: options)
        self.book = book
        let imageURL = self.book.imageURL
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView.backgroundColor = UIColor.whiteColor()
        if imageURL == ""{
            self.imageView.image = UIImage(named: "InstructionCard.jpg")
        }
            
        else{
            let url = NSURL(string: imageURL as String)
            //initalizes imageview
            downloadImage(url!)

        }
                //self.imageView.image = image
        self.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        UIViewAutoresizing.FlexibleBottomMargin
        
        self.imageView.autoresizingMask = self.autoresizingMask
        constructInformationView()
        //constructSummaryView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //fatalError("init(coder:) has not been implemented")
    }
    
    func constructInformationView() -> Void{
        let bottomHeight:CGFloat = 40.0
        let bottomFrame:CGRect = CGRectMake(0,
            CGRectGetHeight(self.bounds) - bottomHeight,
            CGRectGetWidth(self.bounds),
            bottomHeight);
        self.informationView = UIView(frame:bottomFrame)
        self.informationView.backgroundColor = UIColor.whiteColor()
        self.informationView.clipsToBounds = true
        self.informationView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleTopMargin]
        self.addSubview(self.informationView)
        constructNameLabel()
        
    }
    
    func constructNameLabel() -> Void{
        let leftPadding:CGFloat = 12.0
        let topPadding:CGFloat = 17.0
        let frame:CGRect = CGRectMake(leftPadding,
            topPadding,
            floor(CGRectGetWidth(self.informationView.frame)),
            CGRectGetHeight(self.informationView.frame) - topPadding)
        self.titleLabel = UILabel(frame:frame)
        self.titleLabel.text = "\(book.title)"
        self.titleLabel.font = titleLabel.font.fontWithSize(15)
        self.informationView.addSubview(self.titleLabel)
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
