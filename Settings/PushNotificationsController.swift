//
//  PushNotificationsController.swift
//
//  Created by Demyanchuk Dmitry on 02.02.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class PushNotificationsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // add footer to delete empty cell's
        
        self.tableView.tableFooterView = UIView()
        
        // add tableview delegate
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "PushNotificationCell")!
        
        cell?.selectionStyle = .default
        
        switch indexPath.row {
            
        case 0:
            
            cell?.textLabel?.text  = NSLocalizedString("label_gcm_messages", comment: "")
            cell?.detailTextLabel?.text = self.getAllowText(value: iApp.sharedInstance.getAllowMessagesGCM())
            
            break
            
        case 1:
            
            cell?.textLabel?.text  = NSLocalizedString("label_gcm_likes", comment: "")
            cell?.detailTextLabel?.text = self.getAllowText(value: iApp.sharedInstance.getAllowLikesGCM())
            
            break
            
        case 2:
            
            cell?.textLabel?.text  = NSLocalizedString("label_gcm_followers", comment: "")
            cell?.detailTextLabel?.text = self.getAllowText(value: iApp.sharedInstance.getAllowFollowersGCM())
            
            break
            
        default:
            
            cell?.textLabel?.text  = NSLocalizedString("label_gcm_gifts", comment: "")
            cell?.detailTextLabel?.text = self.getAllowText(value: iApp.sharedInstance.getAllowGiftsGCM())
            
            break
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.showOptions(index: indexPath.row, indexPath: indexPath)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showOptions(index: Int, indexPath: IndexPath) {
        
        var text: String = ""
        
        switch index {
            
        case 0:
            
            text = NSLocalizedString("label_gcm_messages", comment: "")
            
            break;
            
        case 1:
            
            text = NSLocalizedString("label_gcm_likes", comment: "")
            
            break
            
        case 2:
            
            text = NSLocalizedString("label_gcm_followers", comment: "")
            
            break
            
        default:
            
            text = NSLocalizedString("label_gcm_gifts", comment: "")
            
            break;
        }
        
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        let disableAction = UIAlertAction(title: NSLocalizedString("action_off", comment: ""), style: .default) { action in
            
            switch index {
                
                case 0:
                    
                    self.setAllowMessagesGCM(allowMessagesGCM: 0)
                
                    break;
                
                case 1:
                    
                    self.setAllowLikesGCM(allowLikesGCM: 0)
                
                    break
                
                case 2:
                    
                    self.setAllowFollowersGCM(allowFollowersGCM: 0)
                
                    break
                
                default:
                    
                    self.setAllowGiftsGCM(allowGiftsGCM: 0)
                
                    break;
            }
        }
        
        alertController.addAction(disableAction)
        
        let allowAction = UIAlertAction(title: NSLocalizedString("action_on", comment: ""), style: .default) { action in
            
            switch index {
                
            case 0:
                
                self.setAllowMessagesGCM(allowMessagesGCM: 1)
                
                break;
                
            case 1:
                
                self.setAllowLikesGCM(allowLikesGCM: 1)
                
                break
                
            case 2:
                
                self.setAllowFollowersGCM(allowFollowersGCM: 1)
                
                break
                
            default:
                
                self.setAllowGiftsGCM(allowGiftsGCM: 1)
                
                break;
            }
        }
        
        alertController.addAction(allowAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = tableView.cellForRow(at: indexPath)
            popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getAllowText(value: Int)->String {
        
        if (value == 1) {
            
            return NSLocalizedString("action_on", comment: "")
            
        } else {
            
            return NSLocalizedString("action_off", comment: "")
        }
    }
    
    func setAllowMessagesGCM(allowMessagesGCM: Int) {
        
        self.serverRequestStart()
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_MESSAGES_GCM)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&allowMessagesGCM=" + String(allowMessagesGCM);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.serverRequestEnd()
                })
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setAllowMessagesGCM(allowMessagesGCM: (response["allowMessagesGCM"] as AnyObject).integerValue)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                        
                        self.tableView.reloadData()
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                    })
                }
            }
            
        }).resume();
    }
    
    func setAllowLikesGCM(allowLikesGCM: Int) {
        
        self.serverRequestStart()
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_LIKES_GCM)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&allowLikesGCM=" + String(allowLikesGCM);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.serverRequestEnd()
                })
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setAllowLikesGCM(allowLikesGCM: (response["allowLikesGCM"] as AnyObject).integerValue)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                        
                        self.tableView.reloadData()
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                    })
                }
            }
            
        }).resume();
    }
    
    func setAllowFollowersGCM(allowFollowersGCM: Int) {
        
        self.serverRequestStart()
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_FOLLOWERS_GCM)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&allowFollowersGCM=" + String(allowFollowersGCM);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.serverRequestEnd()
                })
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setAllowFollowersGCM(allowFollowersGCM: (response["allowFollowersGCM"] as AnyObject).integerValue)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                        
                        self.tableView.reloadData()
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                    })
                }
            }
            
        }).resume();
    }
    
    func setAllowGiftsGCM(allowGiftsGCM: Int) {
        
        self.serverRequestStart()
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_GIFTS_GCM)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&allowGiftsGCM=" + String(allowGiftsGCM);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.serverRequestEnd()
                })
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setAllowGiftsGCM(allowGiftsGCM: (response["allowGiftsGCM"] as AnyObject).integerValue)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                        
                        self.tableView.reloadData()
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                    })
                }
            }
            
        }).resume();
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show("Loading");
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
