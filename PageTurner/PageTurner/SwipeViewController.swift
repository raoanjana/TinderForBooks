//
//  SwipeViewController.swift
//  PageTurner
//
//  Created by Anjana Rao on 4/29/16.
//  Copyright © 2016 Hoot Industries. All rights reserved.
//

import Foundation
import MDCSwipeToChoose
import CoreData

class SwipeViewController: UIViewController, MDCSwipeToChooseDelegate{
    var books: [Book] = []
    
    
    @IBOutlet weak var descriptionField: UITextView!
    let recommender : Recommender = Recommender()
    var currentBook:Book!
    var frontCardView:ChooseBookView!
    var backCardView:ChooseBookView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.books = getInitialBooks()              // our problem here is that we cant just wait for updateBooks to finish since it tries to create cards before that happens
        self.updateBooks()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.books = getInitialBooks()
        self.updateBooks()
        // Here you can init your properties
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMyFrontCardView(self.popPersonViewWithFrame(frontCardViewFrame())!)
        self.view.addSubview(self.frontCardView)
        
        self.backCardView = self.popPersonViewWithFrame(backCardViewFrame())!
        self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
    }
    
    func suportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.Portrait
    }
    
    func viewDidCancelSwipe(view: UIView) -> Void{
        
        print("You couldn't decide on \(self.currentBook.title)");
    }
    
    // This is called then a user swipes the view fully left or right.
    func view(view: UIView, wasChosenWithDirection: MDCSwipeDirection) -> Void{
        
        // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
        // and "LIKED" on swipes to the right.
        if(wasChosenWithDirection == MDCSwipeDirection.Left){
            print("You noped: \(self.currentBook.title)")
        }
        else{
            print("You liked: \(self.currentBook.title)")
            self.saveBook(self.currentBook)
        }
        
        // MDCSwipeToChooseView removes the view from the view hierarchy
        // after it is swiped (this behavior can be customized via the
        // MDCSwipeOptions class). Since the front card view is gone, we
        // move the back card to the front, and create a new back card.
        if(self.backCardView != nil){
            self.setMyFrontCardView(self.backCardView)
        }
        
        backCardView = self.popPersonViewWithFrame(self.backCardViewFrame())
        //if(true){
        // Fade the back card into view.
        if(backCardView != nil){
            self.backCardView.alpha = 0.0
            self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.backCardView.alpha = 1.0
                },completion:nil)
        }
        
        // check if we need more cards
        if (self.books.count < 3) {
            self.updateBooks()
        }
    }


    func setMyFrontCardView(frontCardView:ChooseBookView) -> Void{
        
        // Keep track of the person currently being chosen.
        self.frontCardView = frontCardView
        self.currentBook = frontCardView.book
        descriptionField.font = descriptionField.font?.fontWithSize(15)
        descriptionField.text = currentBook.summary as String
    }

    func popPersonViewWithFrame(frame:CGRect) -> ChooseBookView?{
        if(self.books.count == 0){
            return nil;
        }
        
        let options:MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
        options.delegate = self
        //options.threshold = 160.0
        options.onPan = { state -> Void in
            if(self.backCardView != nil){
                let frame:CGRect = self.frontCardViewFrame()
                self.backCardView.frame = CGRectMake(frame.origin.x, frame.origin.y-(state.thresholdRatio * 10.0), CGRectGetWidth(frame), CGRectGetHeight(frame))
            }
        }// Display the first ChoosePersonView in front. Users can swipe to indicate
        // whether they like or dislike the person displayed.
      
        let bookView:ChooseBookView = ChooseBookView(frame: frame, book: self.books[0], options: options)
        self.books.removeAtIndex(0)
        return bookView
        
    }

    func frontCardViewFrame() -> CGRect{
        let horizontalPadding:CGFloat = 20.0
        let topPadding:CGFloat = 60.0
        let bottomPadding:CGFloat = 300.0
        return CGRectMake(horizontalPadding,topPadding,CGRectGetWidth(self.view.frame) - (horizontalPadding * 2), CGRectGetHeight(self.view.frame) - bottomPadding)
    }
    
    func backCardViewFrame() ->CGRect{
        let frontFrame:CGRect = frontCardViewFrame()
        return CGRectMake(frontFrame.origin.x, frontFrame.origin.y + 10.0, CGRectGetWidth(frontFrame), CGRectGetHeight(frontFrame))

    }
    
    
    func nopeFrontCardView() -> Void{
        self.frontCardView.mdc_swipe(MDCSwipeDirection.Left)
    }
    
    func likeFrontCardView() -> Void{
        self.frontCardView.mdc_swipe(MDCSwipeDirection.Right)
    }
    
    // We find new recommendations and append them to our books array
    func updateBooks() {
        recommender.getRandomRecommendations(false, completionHandler: {data, error -> Void in
            if (error != nil) {
                print ("ERROR")
            } else {
                guard let newBooks : [Book] = data else {
                    return
                }
                // add all new books to our thing
                for bookObject : Book in newBooks {
                    self.books.append(bookObject)
                }
                
                self.reloadView()
            }
        })
    }
    
    func reloadView() {
        self.view.setNeedsDisplay()
    }
    
    
    // TODO: We need to have this return either a set of "default books" or a set of saved recommendations?
    // this is currently the solution to the problem of adding initial cards, if we only call updateBooks() then
    // the method doesnt finish in time and we get a nil exception when it tries to create the first card
    func getInitialBooks() -> [Book]{
        books = [Book]()
        books.append(Book(title: "Welcome to PageTurner!", author: "Test author 1", imageURL: "https://pbs.twimg.com/profile_images/664257671768354816/w2ZlpSd6.png", summary: "the end", isbn: "111114441", asin: "10142978X", instruction: true))
        books.append(Book(title: "Have fun Swiping!", author: "Test author 1", imageURL: "https://pbs.twimg.com/profile_images/664257671768354816/w2ZlpSd6.png", summary: "the end", isbn: "111114441", asin: "10142978X", instruction: true))
        return books
    }
    
    // save the book to core data
    func saveBook(book : Book){
        // we dont want to save our sample cards
        if (book.instruction) {
            return
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("LikedBook", inManagedObjectContext: managedContext)
        let bookToSave = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        bookToSave.setValue(book.title as String, forKey: "title")
        bookToSave.setValue(book.isbn as String, forKey: "isbn")
        bookToSave.setValue(book.asin as String, forKey: "asin")
        bookToSave.setValue(book.imageURL as String, forKey: "image_url")
        bookToSave.setValue(book.summary as String, forKey: "summary")
        bookToSave.setValue(book.author as String, forKey: "author")
        
        do {
            try managedContext.save()
//            likedBooks.append(bookToSave)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}