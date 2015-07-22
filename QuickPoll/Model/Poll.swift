//
//  Poll.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/2/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import Foundation
import Parse


class Poll: PFObject, PFSubclassing {
    
    // MARK: - Section: Instance Properties
    
    // MARK: - Sub-section: Computed
    @NSManaged var user: PFUser?
    @NSManaged var title:String?
    @NSManaged var descriptionOfPoll:String?
    @NSManaged var category:Int
    @NSManaged var options:[NSDictionary]
    var option:NSDictionary = Dictionary<String,Int>()
    var votedFor:Bool?
    //MARK: - Section: Class Methods

    
    override init() {
        super.init()
    }
    
    static func parseClassName() -> String{
        return "Poll"
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    
    // MARK: - Section: Instance Methods

    static func getCategoryImageString (categoryNumber:Int) ->String {
        var imageName:String
        
        switch categoryNumber {
        case 0:
            imageName = "Entertainment"
        case 1:
            imageName = "News"
        case 2:
            imageName = "edu"
        case 3:
            imageName = "Funny"
        case 4:
            imageName = "Health"
        default:
            assert(false, "Useful message for developer")
            imageName = "News"
        }
        return imageName
        
    }
    
    func postPoll(#pollTitle:String, pollDescribtion:String, arrayWithOptions:[NSDictionary], categoryTypeIndex:Int,completionBlock:PFBooleanResultBlock) {
        
        user = PFUser.currentUser()
        self.options = arrayWithOptions
        self.title = pollTitle
        self.descriptionOfPoll = pollDescribtion
        self.category = categoryTypeIndex
        
        saveInBackgroundWithBlock(completionBlock)
    }
    
    
    func didVote()->Bool {
        
        // check if current user is on list
        
        //get a list of polls current users votes
        //if not return false
        return false
    }
    
}