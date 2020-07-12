//
//  UpgradesController.swift
//  SocialNetwork
//
//  Created by Demyanchuk Dmitry on 03.02.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class UpgradesController: UIViewController {
    
    @IBOutlet weak var ghostButton: UIButton!
    @IBOutlet weak var verifiedButton: UIButton!
    @IBOutlet weak var proModeButton: UIButton!
    @IBOutlet weak var adButton: UIButton!
    
    
//    static let GHOST_MODE_COST = 100;
//    static let VERIFIED_BADGE_COST = 150;
//    static let PRO_MODE_COST = 170;
//    static let DISABLE_ADS_COST = 200;

    override func viewDidLoad() {
        
        super.viewDidLoad()

        update()
    }
    
    func update() {
        
        if (iApp.sharedInstance.getGhost() == 1) {
            
            self.ghostButton.isEnabled = false
            self.ghostButton.setTitle(NSLocalizedString("label_enabled", comment: ""), for: .disabled)
            
        } else {
            
            self.ghostButton.isEnabled = true
            self.ghostButton.setTitle(NSLocalizedString("action_enable", comment: "") + " (" + String(Constants.GHOST_MODE_COST) + ")", for: .normal)
        }
        
        if (iApp.sharedInstance.getVerified() == 1) {
            
            self.verifiedButton.isEnabled = false
            self.verifiedButton.setTitle(NSLocalizedString("label_enabled", comment: ""), for: .disabled)
            
        } else {
            
            self.verifiedButton.isEnabled = true
            self.verifiedButton.setTitle(NSLocalizedString("action_enable", comment: "") + " (" + String(Constants.VERIFIED_BADGE_COST) + ")", for: .normal)
        }
        
        if (iApp.sharedInstance.getPro() == 1) {
            
            self.proModeButton.isEnabled = false
            self.proModeButton.setTitle(NSLocalizedString("label_enabled", comment: ""), for: .disabled)
            
        } else {
            
            self.proModeButton.isEnabled = true
            self.proModeButton.setTitle(NSLocalizedString("action_enable", comment: "") + " (" + String(Constants.PRO_MODE_COST) + ")", for: .normal)
        }
        
        if (iApp.sharedInstance.getAdmob() == 1) {
            
            self.adButton.isEnabled = true
            self.adButton.setTitle(NSLocalizedString("action_enable", comment: "") + " (" + String(Constants.DISABLE_ADS_COST) + ")", for: .normal)
            
        } else {
            
            self.adButton.isEnabled = false
            self.adButton.setTitle(NSLocalizedString("label_enabled", comment: ""), for: .disabled)
        }
    }
    
    @IBAction func ghostButtonTap(_ sender: Any) {
        
        if (iApp.sharedInstance.getBalance() < Constants.GHOST_MODE_COST) {
            
            let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.ghostMode(cost: Constants.GHOST_MODE_COST)
        }
    }
    
    @IBAction func verifiedButtonTap(_ sender: Any) {
     
        if (iApp.sharedInstance.getBalance() < Constants.VERIFIED_BADGE_COST) {
            
            let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.verifiedBadge(cost: Constants.VERIFIED_BADGE_COST)
        }
    }
    
    @IBAction func proModeButtonTap(_ sender: Any) {
        
        if (iApp.sharedInstance.getBalance() < Constants.PRO_MODE_COST) {
            
            let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.proMode(cost: Constants.PRO_MODE_COST)
        }
    }
    
    @IBAction func adButtonTap(_ sender: Any) {
        
        if (iApp.sharedInstance.getBalance() < Constants.DISABLE_ADS_COST) {
            
            let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.disableAds(cost: Constants.DISABLE_ADS_COST)
        }
    }
    
    func ghostMode(cost: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_GHOST_MODE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&cost=" + String(cost);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - cost)
                        
                        iApp.sharedInstance.setGhost(ghost: 1)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd();
                        
                        self.update();
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func proMode(cost: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_PRO_MODE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&cost=" + String(cost);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - cost)
                        
                        iApp.sharedInstance.setPro(pro: 1)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd();
                        
                        self.update();
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func verifiedBadge(cost: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_VERIFIED_BADGE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&cost=" + String(cost);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - cost)
                        
                        iApp.sharedInstance.setVerified(verified: 1)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd();
                        
                        self.update();
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func disableAds(cost: Int) {
        
        self.serverRequestStart();
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideAdmobBanner"), object: nil)
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_DISABLE_ADS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&cost=" + String(cost);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - cost)
                        
                        iApp.sharedInstance.setAdmob(admob: 0)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd();
                        
                        self.update();
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
