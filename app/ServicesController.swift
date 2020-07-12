//
//  ServicesController.swift
//
//  Created by Mac Book on 28.02.2018.
//  Copyright © 2018 raccoonsquare@gmail.com. All rights reserved.
//

import UIKit

import FacebookLogin
import FBSDKLoginKit

class ServicesController: UIViewController, FBSDKLoginButtonDelegate {
    
    var fbdata : [String : AnyObject]!
    
    @IBOutlet weak var connectButton: FBSDKLoginButton!
    @IBOutlet weak var disconnectButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        if FBSDKAccessToken.current() != nil {
            
            self.logoutFromFacebook()
        }
        
        connectButton.readPermissions = ["email", "public_profile"]
        connectButton.delegate = self
        
        print("FB ID: " + iApp.sharedInstance.getFacebookId())
        
        if (!Constants.FACEBOOK_AUTHORIZATION) {
            
            self.connectButton.isHidden = true
            self.disconnectButton.isHidden = true
            
        } else {
            
            if (iApp.sharedInstance.getFacebookId().count > 1) {
                
                self.disconnectScreen()
                
            } else {
                
                self.connectScreen()
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if ((error) != nil) {
            
            print(error)
            
        } else if result.isCancelled {
            
            print("User cancelled login.")
            
        } else {
            
            self.setLoginButtonTitle()
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            if result.grantedPermissions.contains("email") {
                
                self.readFacebookData()
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        return
    }
    
    func readFacebookData() {
        
        if ((FBSDKAccessToken.current()) != nil) {
            
            // alswo can use "picture.type(large)" for get photo
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    
                    self.fbdata = result as! [String : AnyObject]
                    
                    iApp.sharedInstance.setFacebookId(fbId: self.fbdata["id"] as? String! ?? "")
                    iApp.sharedInstance.setFacebookName(fbName: self.fbdata["name"] as? String! ?? "")
                    iApp.sharedInstance.setFacebookEmail(fbEmail: self.fbdata["email"] as? String! ?? "")
                    
                    // print(FBSDKAccessToken.current().userID)
                    
                    self.logoutFromFacebook(); // Kill Access token
                    
                    self.connectWithFacebook(fbId: iApp.sharedInstance.getFacebookId())
                }
            })
        }
    }
    
    func logoutFromFacebook() {
        
        self.setLoginButtonTitle()
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func setLoginButtonTitle() {
        
        let buttonText = NSAttributedString(string: NSLocalizedString("action_facebook_connect", comment: ""))
        self.connectButton.setAttributedTitle(buttonText, for: .normal)
        self.connectButton.setAttributedTitle(buttonText, for: .focused)
        self.connectButton.setAttributedTitle(buttonText, for: .selected)
    }
    
    func connectScreen() {
        
        self.setLoginButtonTitle()
        
        self.connectButton.isHidden = false
        self.disconnectButton.isHidden = true
    }
    
    func disconnectScreen() {
        
        self.disconnectButton.isHidden = false
        self.connectButton.isHidden = true
    }
    
    @IBAction func disconnectButtonClick(_ sender: Any) {
        
        self.disconnectFromFacebook()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func disconnectFromFacebook() {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_DISCONNECT_FROM_FACEBOOK)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken();
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
                print("start auth error")
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    print(response)
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setFacebookId(fbId: "")
                        iApp.sharedInstance.setFacebookName(fbName: "")
                        iApp.sharedInstance.setFacebookEmail(fbEmail: "")
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                // show message with error
                                
                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("alert_account_disconnect_success", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                                
                                if (iApp.sharedInstance.getFacebookId().count > 1) {
                                    
                                    self.disconnectScreen()
                                    
                                } else {
                                    
                                    self.connectScreen()
                                }
                            }
                        }

                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }

    func connectWithFacebook(fbId: String) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_CONNECT_TO_FACEBOOK)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&facebookId=" + fbId + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken();
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
                print("start auth error")
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    print(response)
                    
                    if (responseError == false) {
                        
                        let errorCode = response["error_code"] as! Int;
                        
                        if (errorCode == Constants.ERROR_FACEBOOK_ID_TAKEN) {
                            
                            iApp.sharedInstance.setFacebookId(fbId: "")
                            iApp.sharedInstance.setFacebookName(fbName: "")
                            iApp.sharedInstance.setFacebookEmail(fbEmail: "")
                            
                            DispatchQueue.global(qos: .background).async {
                                
                                DispatchQueue.main.async {
                                    
                                    // show message with error
                                    
                                    let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("alert_account_connect_error", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                                    
                                    // show the alert
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            
                        } else {
                            
                            DispatchQueue.main.async() {
                                
                                // show message with connection success text
                                
                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("alert_account_connect_success", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                                
                                if (iApp.sharedInstance.getFacebookId().count > 1) {
                                    
                                    self.disconnectScreen()
                                    
                                } else {
                                    
                                    self.connectScreen()
                                }
                            }
                        }
                        
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
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
}
