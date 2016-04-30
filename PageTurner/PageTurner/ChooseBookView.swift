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
    let ChoosBookViewImageLabelWidth:CGFloat = 42.0
    var book: Book!
    var titleLabel: UILabel!
    var informationView: UIView!
    
    init(frame: CGRect, book: Book, options: MDCSwipeToChooseViewOptions){
        super.init(frame: frame, options: options)
        self.book = book
        
        self.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        UIViewAutoresizing.FlexibleBottomMargin
        
        //self.imageView.autoresizingMask = self.autoresizingMask
        constructInformationView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //fatalError("init(coder:) has not been implemented")
    }
    func constructInformationView() -> Void{
        let bottomHeight:CGFloat = 60.0
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
        func constructNameLabel() -> Void{
            let leftPadding:CGFloat = 12.0
            let topPadding:CGFloat = 17.0
            let frame:CGRect = CGRectMake(leftPadding,
                topPadding,
                floor(CGRectGetWidth(self.informationView.frame)/2),
                CGRectGetHeight(self.informationView.frame) - topPadding)
            self.titleLabel = UILabel(frame:frame)
            self.titleLabel.text = "\(book.title)"
            self.informationView.addSubview(self.titleLabel)
        }
    }

}
