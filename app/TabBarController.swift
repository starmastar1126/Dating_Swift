//
//  TabBarController.swift
//
//  Created by Demyanchuk Dmitry on 30.01.18.
//  Copyright © 2018 qascript@mail.ru All rights reserved.
//

import UIKit
import GoogleMobileAds

import FirebaseCore
import FirebaseAnalytics
import FirebaseInstanceID
import FirebaseMessaging

class TabBarController: UITabBarController, GADBannerViewDelegate {
    
    @IBOutlet weak var mTabBar: UITabBar!
    
    var bannerView: GADBannerView!    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (iApp.sharedInstance.getFcmRegId().count != 0) {
            
            print("Set Device Token")
            
            self.setDeviceToken()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadges), name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAdmobBanner), name: NSNotification.Name(rawValue: "updateAdmobBanner"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideAdmobBanner), name: NSNotification.Name(rawValue: "hideAdmobBanner"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAdmobBanner), name: NSNotification.Name(rawValue: "showAdmobBanner"), object: nil)
        
        getSettings();
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
        
        updateBadges();
        updateAdmobBanner();
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: -self.mTabBar.frame.size.height),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }

    @objc func updateBadges() {
        
        print("update badges notify")
        
        if (iApp.sharedInstance.getNotificationsCount() > 0) {
            
            self.tabBar.items?[1].badgeValue = String(iApp.sharedInstance.getNotificationsCount())
            
        } else {
            
            self.tabBar.items?[1].badgeValue = nil
        }
        
        if (iApp.sharedInstance.getMessagesCount() > 0) {
            
            self.tabBar.items?[2].badgeValue = String(iApp.sharedInstance.getMessagesCount())
            
        } else {
            
            self.tabBar.items?[2].badgeValue = nil
        }
    }
    
    @objc func updateAdmobBanner() {
        
        print("update banner notify")
        
        if (iApp.sharedInstance.getAdmob() == 1) {
            
            self.bannerView.isHidden = false;
            
        } else {
            
            self.bannerView.isHidden = true;
        }
    }
    
    @objc func hideAdmobBanner() {
        
        print("hide banner")
        
        self.bannerView.isHidden = true;
    }
    
    @objc func showAdmobBanner() {
        
        print("show banner")
        
        self.bannerView.isHidden = false;
    }
    
    func setDeviceToken() {
        
        guard let refreshedToken = FIRInstanceID.instanceID().token() else {
            
            return
        }
        
        iApp.sharedInstance.setFcmRegId(ios_fcm_regid: refreshedToken);
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_DEVICE_TOKEN)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId();
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        // print(response)
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                }
            }
            
        }).resume();
    }
    
    func getSettings() {
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_GET_SETTINGS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken();
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setMessagesCount(messagesCount: (response["messagesCount"] as? Int)!)
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.updateBadges()
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                }
            }
            
        }).resume();
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
