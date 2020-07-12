//
//  TermsController.swift
//  DatingApp
//
//  Created by Mac Book on 23.02.17.
//  Copyright © 2017 Ifsoft. All rights reserved.
//

import UIKit

class TermsController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        webView.delegate = self
        
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        webView.isHidden = true
        
        UIWebView.loadRequest(webView)(NSURLRequest(url: NSURL(string: Constants.METHOD_APP_TERMS)! as URL) as URLRequest)
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
