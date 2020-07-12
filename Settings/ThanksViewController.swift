//
//  ThanksViewController.swift
//  SocialApp
//
//  Created by Mac Book on 23.01.17.
//  Copyright © 2017 Ifsoft. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        webView.delegate = self
        
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        webView.isHidden = true
        
        UIWebView.loadRequest(webView)(NSURLRequest(url: NSURL(string: Constants.METHOD_APP_THANKS)! as URL) as URLRequest)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        
        webView.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

}
