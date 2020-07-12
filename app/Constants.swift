//
//  Constants.swift
//
//  Created by Demyanchuk Dmitry on 01.02.18.
//  Copyright © 2018 raccoonsquare@gmail.com All rights reserved.
//

struct Constants {
    
    // CLENT_ID (for identify app on server) Integer value, same that in db.inc.php
    
    static let CLIENT_ID: Int = 1;                                  // Correct Example: 1567    Incorrect example: 00098
    
    // Be careful! Not forgot slash "/" at the string end!
    
    static let API_DOMAIN: String = "http://chat.ifsoft.ru/";       // Example: http://yousite.com/
    
    // Show Facebook Login Button or not
    
    static let FACEBOOK_AUTHORIZATION: Bool = true; // true = show button
    
    
    // Don't modify next constants!!!
    
    static let SERVER_ENGINE_VERSION: Float = 1.0;
    
    static let API_FILE_EXTENSION: String = ".inc.php";
    
    static let API_VERSION: String = "v2";
    
    // Api URLs
    
    static let METHOD_PRIVACY_SETTINGS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.privacy" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_APP_TERMS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/app.terms" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_APP_THANKS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/app.thanks" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_AUTHORIZE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.authorize" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SIGNIN: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.signIn" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SIGNUP: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.signUp" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_RECOVERY: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.recovery" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_LOGOUT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.logOut" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SAVE_SETTINGS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.saveSettings" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SETPASSWORD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setPassword" + Constants.API_FILE_EXTENSION;
    
        static let METHOD_ACCOUNT_SET_DEVICE_TOKEN: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setGcmToken" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_GET_SETTINGS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.getSettings" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_GIFTS_GCM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowGiftsGCM" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_LIKES_GCM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowLikesGCM" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_MESSAGES_GCM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowMessagesGCM" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_FOLLOWERS_GCM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowFollowersGCM" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_COMMENTS_GCM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowCommentsGCM" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_REPLY_GCM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowCommentReplyGCM" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_ADD_FUNDS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.addFunds" + Constants.API_FILE_EXTENSION;
    
    // Account Privacy Settings
    
    static let METHOD_ACCOUNT_SET_ALLOW_MESSAGES: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowMessages" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_ALLOW_GALLERY_COMMENTS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowPhotosComments" + Constants.API_FILE_EXTENSION;
    
    // Messages
    
    static let METHOD_DIALOGS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/dialogs_new.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_DIALOG_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.remove" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_CHAT_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_CHAT_GET_PREVIOUS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.getPrevious" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_CHAT_UPDATE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.update" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_MESSAGE_NEW: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/msg.new" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_MESSAGE_UPLOAD_IMAGE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/msg.uploadImg" + Constants.API_FILE_EXTENSION;
    
    // Notifications
    
    static let METHOD_NOTIFICATIONS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/notifications.get" + Constants.API_FILE_EXTENSION;
    
    // Upgrades
    
    static let METHOD_ACCOUNT_SET_VERIFIED_BADGE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setVerifiedBadge" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_GHOST_MODE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setGhostMode" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_DISABLE_ADS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.disableAds" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_PRO_MODE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setProMode" + Constants.API_FILE_EXTENSION;
    
    // Gifts
    
    static let METHOD_GIFTS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gifts.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GIFTS_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gifts.remove" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GIFTS_SELECT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gifts.select" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GIFTS_SEND: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gifts.send" + Constants.API_FILE_EXTENSION;
    
    // Nearby
    
    static let METHOD_PEOPLE_NEARBY_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.getPeopleNearby" + Constants.API_FILE_EXTENSION;
    
    // Profile
    
    static let METHOD_PROFILE_UPLOAD_PHOTO: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.uploadPhoto" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_UPLOAD_COVER: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.uploadCover" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_GET_LIKES: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.getFans" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_LIKE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.like" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_REPORT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.report" + Constants.API_FILE_EXTENSION;
    
    // Freinds
    
    static let METHOD_FRIENDS_SEND_REQUEST: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.follow" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_FRIENDS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/friends.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_FRIENDS_ACCEPT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/friends.acceptRequest" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_FRIENDS_REJECT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/friends.rejectRequest" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_FRIENDS_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/friends.remove" + Constants.API_FILE_EXTENSION;
    
    // Gallery
    
    static let METHOD_GALLERY_COMMENT_ADD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/images.comment" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_COMMENT_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/images.commentRemove" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/photos.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_GET_ITEM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/images.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_ADD_ITEM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/photos.new" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_REPORT_ITEM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/photos.report" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_REMOVE_ITEM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/photos.remove" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_LIKE_ITEM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/images.like" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_UPLOAD_IMAGE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/photos.uploadImg" + Constants.API_FILE_EXTENSION;
    
    // Blacklist
    
    static let METHOD_BLACKLIST_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/blacklist.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_BLACKLIST_ADD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/blacklist.add" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_BLACKLIST_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/blacklist.remove" + Constants.API_FILE_EXTENSION;
    
    // Search
    
    static let METHOD_SEARCH_PROFILE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/app.search" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_SEARCH_PROFILE_PRELOAD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/app.searchPreload" + Constants.API_FILE_EXTENSION;
    
    // Guests 
    
    static let METHOD_GUESTS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/guests.get" + Constants.API_FILE_EXTENSION;
    
    // Search fo new server version
    
    // static let METHOD_SEARCH_PROFILE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/search.profile" + Constants.API_FILE_EXTENSION;
    
    // static let METHOD_SEARCH_PROFILE_PRELOAD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/search.profilePreload" + Constants.API_FILE_EXTENSION;
    
    // Stickers
    
    static let METHOD_STICKERS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/stickers.get" + Constants.API_FILE_EXTENSION;
    
    // For version 1.6
    
    static let METHOD_CHAT_NOTIFY: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.notify" + Constants.API_FILE_EXTENSION;
    
    // For version 1.7
    
    static let METHOD_ACCOUNT_LOGINBYFACEBOOK: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.signInByFacebook" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_CONNECT_TO_FACEBOOK: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.connectToFacebook" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_DISCONNECT_FROM_FACEBOOK: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.disconnectFromFacebook" + Constants.API_FILE_EXTENSION;
    
    
    
    // Constants for Interface
    
    static let GHOST_MODE_COST = 100;
    static let VERIFIED_BADGE_COST = 150;
    static let PRO_MODE_COST = 170;
    static let DISABLE_ADS_COST = 200;
    
    static let LIST_ITEMS = 20;
    
    // Api Constants
    
    static let ERROR_SUCCESS: Int = 0;
    
    static let ERROR_UNKNOWN: Int = 100;
    static let ERROR_LOGIN_TAKEN: Int = 300;
    static let ERROR_EMAIL_TAKEN: Int = 301;
    
    static let NOTIFY_TYPE_LIKE: Int = 0;
    static let NOTIFY_TYPE_FOLLOWER: Int = 1;
    static let NOTIFY_TYPE_MESSAGE: Int = 2;
    static let NOTIFY_TYPE_COMMENT: Int = 3;
    static let NOTIFY_TYPE_COMMENT_REPLY: Int = 4;
    static let NOTIFY_TYPE_FRIEND_REQUEST_ACCEOTED: Int = 5;
    static let NOTIFY_TYPE_GIFT: Int = 6;
    static let NOTIFY_TYPE_IMAGE_COMMENT: Int = 7;
    static let NOTIFY_TYPE_IMAGE_COMMENT_REPLY: Int = 8;
    static let NOTIFY_TYPE_IMAGE_LIKE: Int = 9;
    
    static let ACCOUNT_STATE_ENABLED: Int = 0;
    static let ACCOUNT_STATE_DISABLED: Int = 1;
    static let ACCOUNT_STATE_BLOCKED: Int = 2;
    static let ACCOUNT_STATE_DEACTIVATED: Int = 3;
    
    static let GCM_NOTIFY_CONFIG: Int = 0;
    static let GCM_NOTIFY_SYSTEM: Int = 1;
    static let GCM_NOTIFY_CUSTOM: Int = 2;
    static let GCM_NOTIFY_LIKE: Int = 3;
    static let GCM_NOTIFY_ANSWER: Int = 4;
    static let GCM_NOTIFY_QUESTION: Int = 5;
    static let GCM_NOTIFY_COMMENT: Int = 6;
    static let GCM_NOTIFY_FOLLOWER: Int = 7;
    static let GCM_NOTIFY_PERSONAL: Int = 8;
    static let GCM_NOTIFY_MESSAGE: Int = 9;
    static let GCM_NOTIFY_COMMENT_REPLY: Int = 10;
    static let GCM_NOTIFY_REQUEST_INBOX: Int = 11;
    static let GCM_NOTIFY_REQUEST_ACCEPTED: Int = 12;
    static let GCM_NOTIFY_GIFT: Int = 14;
    static let GCM_NOTIFY_SEEN: Int = 15;
    static let GCM_NOTIFY_TYPING: Int = 16;
    static let GCM_NOTIFY_URL: Int = 17;
    static let GCM_NOTIFY_IMAGE_COMMENT_REPLY: Int = 18;
    static let GCM_NOTIFY_IMAGE_COMMENT: Int = 19;
    static let GCM_NOTIFY_IMAGE_LIKE: Int = 20;
    
    static let GCM_NOTIFY_TYPING_START: Int = 27;
    static let GCM_NOTIFY_TYPING_END: Int = 28;
    
    static let SEX_UNKNOWN: Int = 2;
    static let SEX_MALE: Int = 0;
    static let SEX_FEMALE: Int = 1;
    
    static let ERROR_FACEBOOK_ID_TAKEN: Int = 302;
}
