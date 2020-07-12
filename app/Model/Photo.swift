//
//  Photo.swift
//
//  Created by Demyanchuk Dmitry on 24.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class Photo {
    
    public var photoLoading = false
    public var imgLoading = false
    
    private var id: Int = 0
    
    private var itemType: Int = 0
    
    private var fromUserId: Int = 0
    private var fromUserVerified: Int = 0
    
    private var fromUserAllowPhotosComments: Int = 0
    
    private var commentsCount: Int = 0
    private var likesCount: Int = 0
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    
    private var comment: String?
    private var imgUrl: String?
    private var videoUrl: String?
    
    private var date: String?
    private var timeAgo: String?
    
    private var myLike: Bool = false;
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        
        self.setItemType(itemType: Int((Response["itemType"] as? String)!)!)
        
        self.setFromUserId(fromUserId: Int((Response["fromUserId"] as? String)!)!)
        self.setFromUserVerified(fromUserVerified: Int((Response["fromUserVerify"] as? String)!)!)
        
        self.setFullname(fullname: (Response["fromUserFullname"] as? String)!)
        self.setUsername(username: (Response["fromUserUsername"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["fromUserPhoto"] as? String)!)
        
        self.setComment(comment: (Response["comment"] as? String)!)
        self.setImgUrl(imgUrl: (Response["imgUrl"] as? String)!)
        
        self.setCommentsCount(commentsCount: Int((Response["commentsCount"] as? String)!)!)
        self.setLikesCount(likesCount: Int((Response["likesCount"] as? String)!)!)
        
        self.setDate(date: (Response["date"] as? String)!)
        self.setTimeAgo(timeAgo: (Response["timeAgo"] as? String)!)
        
        if ((Response["myLike"] as? Bool) != nil) {
            
            self.setMyLike(myLike: (Response["myLike"] as? Bool)!)
        }
        
    }
    
    init() {
        
    }
    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setItemType(itemType: Int) {
        
        self.itemType = itemType;
    }
    
    func getItemType() -> Int {
        
        return self.itemType;
    }
    
    public func setCommentsCount(commentsCount: Int) {
        
        self.commentsCount = commentsCount;
    }
    
    func getCommentsCount() -> Int {
        
        return self.commentsCount;
    }
    
    public func setLikesCount(likesCount: Int) {
        
        self.likesCount = likesCount;
    }
    
    func getLikesCount() -> Int {
        
        return self.likesCount;
    }
    
    public func setFromUserId(fromUserId: Int) {
        
        self.fromUserId = fromUserId;
    }
    
    func getFromUserId() -> Int {
        
        return self.fromUserId;
    }
    
    public func setFromUserVerified(fromUserVerified: Int) {
        
        self.fromUserVerified = fromUserVerified;
    }
    
    func getFromUserVerified() -> Int {
        
        return self.fromUserVerified;
    }
    
    public func setUsername(username: String) {
        
        self.username = username
    }
    
    public func getUsername()->String {
        
        return self.username!
    }
    
    public func setFullname(fullname: String) {
        
        self.fullname = fullname
    }
    
    public func getFullname()->String {
        
        return self.fullname!
    }
    
    public func setPhotoUrl(photoUrl: String) {
        
        self.photoUrl = photoUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getPhotoUrl()->String {
        
        return self.photoUrl!
    }
    
    public func setComment(comment: String) {
        
        self.comment = comment
    }
    
    public func getComment()->String {
        
        return self.comment!
    }
    
    public func setImgUrl(imgUrl: String) {
        
        self.imgUrl = imgUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getImgUrl()->String {
        
        return self.imgUrl!
    }
    
    public func setDate(date: String) {
        
        self.date = date
    }
    
    public func getDate()->String {
        
        return self.date!
    }
    
    public func setTimeAgo(timeAgo: String) {
        
        self.timeAgo = timeAgo
    }
    
    public func getTimeAgo()->String {
        
        return self.timeAgo!
    }
    
    public func setMyLike(myLike: Bool) {
        
        self.myLike = myLike;
    }
    
    func isMyLike() -> Bool {
        
        return self.myLike;
    }
}
