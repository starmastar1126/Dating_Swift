//
//  Comment.swift
//
//  Created by Demyanchuk Dmitry on 24.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class Comment {
    
    public var photoLoading = false
    public var pictureLoading = false
    
    private var id: Int = 0
    
    private var imageId: Int = 0
    private var imageFromUserId: Int = 0
    
    private var itemType: Int = 0
    
    private var fromUserId: Int = 0
    private var fromUserVerified: Int = 0
    private var fromUserState: Int = 0
    
    private var replyToUserId: Int = 0
    private var replyToUsername: String?
    private var replyToFullname: String?
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    
    private var comment: String?
    private var imgUrl: String?
    
    private var timeAgo: String?
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        
        self.setFromUserId(fromUserId: Int((Response["fromUserId"] as? String)!)!)
        self.setFromUserState(fromUserState: Int((Response["fromUserState"] as? String)!)!)
        self.setFromUserVerified(fromUserVerified: Int((Response["fromUserVerify"] as? String)!)!)
        
        self.setImageId(imageId: Int((Response["imageId"] as? String)!)!)
        self.setImageFromUserId(imageFromUserId: Int((Response["imageFromUserId"] as? String)!)!)
        
        self.setReplyToUserId(replyToUserId: Int((Response["replyToUserId"] as? String)!)!)
        self.setReplyToUsername(replyToUsername: (Response["replyToUserUsername"] as? String)!)
        self.setReplyToFullname(replyToFullname: (Response["replyToFullname"] as? String)!)
        
        self.setFullname(fullname: (Response["fromUserFullname"] as? String)!)
        self.setUsername(username: (Response["fromUserUsername"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["fromUserPhotoUrl"] as? String)!)
        
        self.setComment(comment: (Response["comment"] as? String)!)
        
        self.setTimeAgo(timeAgo: (Response["timeAgo"] as? String)!)
        
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
    
    public func setImageId(imageId: Int) {
        
        self.imageId = imageId;
    }
    
    func getImageId() -> Int {
        
        return self.imageId;
    }
    
    public func setImageFromUserId(imageFromUserId: Int) {
        
        self.imageFromUserId = imageFromUserId;
    }
    
    func getImageFromUserId() -> Int {
        
        return self.imageFromUserId;
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
    
    public func setFromUserState(fromUserState: Int) {
        
        self.fromUserState = fromUserState;
    }
    
    func getFromUserState() -> Int {
        
        return self.fromUserState;
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
    
    public func setTimeAgo(timeAgo: String) {
        
        self.timeAgo = timeAgo
    }
    
    public func getTimeAgo()->String {
        
        return self.timeAgo!
    }
    
    public func setReplyToUserId(replyToUserId: Int) {
        
        self.replyToUserId = replyToUserId;
    }
    
    func getReplyToUserId() -> Int {
        
        return self.replyToUserId;
    }
    
    public func setReplyToUsername(replyToUsername: String) {
        
        self.replyToUsername = replyToUsername
    }
    
    public func getReplyToUsername()->String {
        
        return self.replyToUsername!
    }
    
    public func setReplyToFullname(replyToFullname: String) {
        
        self.replyToFullname = replyToFullname
    }
    
    public func getReplyToFullname()->String {
        
        return self.replyToFullname!
    }
}
