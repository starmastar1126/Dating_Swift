//
//  BalanceController.swift
//
//  Created by Demyanchuk Dmitry on 03.02.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit
import StoreKit

class BalanceController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var buyButton1: UIButton!
    @IBOutlet weak var buyButton2: UIButton!
    @IBOutlet weak var buyButton3: UIButton!
    
    
    let LOW = 30;
    let NORMAL = 70;
    let HIGHT = 120;
    
    let COINS_PRODUCT_LOW = "ru.ifsoft.dating.low" // ru.ifsoft.mynetwork.low
    
    let COINS_PRODUCT_NORMAL = "ru.ifsoft.dating.normal" // ru.ifsoft.mynetwork.normal
    
    let COINS_PRODUCT_HIGHT = "ru.ifsoft.dating.hight" // ru.ifsoft.mynetwork.hight
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var nonConsumablePurchaseMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseMade")
    var coins = UserDefaults.standard.integer(forKey: "coins")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchAvailableProducts()
        
        update()
        
        self.buyButton1.isEnabled = false;
        self.buyButton2.isEnabled = false;
        self.buyButton3.isEnabled = false;
        
        self.buyButton1.isHidden = true;
        self.buyButton2.isHidden = true;
        self.buyButton3.isHidden = true;
        
        self.creditsLabel.isHidden = true;
        
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func update() {
        
        self.creditsLabel.text = NSLocalizedString("label_you_balance", comment: "") + ": " + String(iApp.sharedInstance.getBalance()) + " " + NSLocalizedString("label_credits", comment: "")
    }
    
    func fetchAvailableProducts()  {
        
        // IAP Products IDs
        
        let productIdentifiers = NSSet(objects: COINS_PRODUCT_LOW, COINS_PRODUCT_NORMAL, COINS_PRODUCT_HIGHT)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if (response.products.count > 0) {
            
            iapProducts = response.products
            
            self.buyButton1.isHidden = false;
            self.buyButton2.isHidden = false;
            self.buyButton3.isHidden = false;
            
            self.creditsLabel.isHidden = false;
            
            loadingView.isHidden = true
            loadingView.stopAnimating()
            
            self.buyButton1.isEnabled = true;
            self.buyButton2.isEnabled = true;
            self.buyButton3.isEnabled = true;
            
            // 30 Credits
            
            let lowProduct = response.products[0] as SKProduct
            
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = lowProduct.priceLocale
            let price1Str = numberFormatter.string(from: lowProduct.price)
            
            self.buyButton1.setTitle(lowProduct.localizedDescription + " \(price1Str!)", for: .normal)
            

            // 70 Credits
            
            let normalProduct = response.products[1] as SKProduct
            
            let price2Str = numberFormatter.string(from: normalProduct.price)
            
            self.buyButton2.setTitle(normalProduct.localizedDescription + " \(price2Str!)", for: .normal)
            
            
            // 120 Credits
            
            let hightProduct = response.products[2] as SKProduct
            
            let price3Str = numberFormatter.string(from: hightProduct.price)
            
            self.buyButton3.setTitle(hightProduct.localizedDescription + " \(price3Str!)", for: .normal)
            
        } else {
            
            self.creditsLabel.isHidden = false;
            self.creditsLabel.text = "Error get products"
            
            loadingView.isHidden = true
            loadingView.stopAnimating()
        }
    }
    
    @IBAction func buyButton1Tap(_ sender: Any) {
        
        purchaseMyProduct(product: iapProducts[0])
    }
    
    @IBAction func buyButton2Tap(_ sender: Any) {
        
        purchaseMyProduct(product: iapProducts[1])
    }

    @IBAction func buyButton3Tap(_ sender: Any) {
        
        purchaseMyProduct(product: iapProducts[2])
    }
    
    
    func canMakePurchases() -> Bool {
        
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchaseMyProduct(product: SKProduct) {
        
        if self.canMakePurchases() {
            
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
            
            print(productID)
            
            
            // IAP Purchases dsabled on the Device
            
        } else {
            
            let alertVC = UIAlertController(title: "IAP", message: "Purchases disabled in your device!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
            
            alertVC.addAction(okAction)
            
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        nonConsumablePurchaseMade = true
        UserDefaults.standard.set(nonConsumablePurchaseMade, forKey: "nonConsumablePurchaseMade")
        
        let alertVC = UIAlertController(title: "IAP", message: "Successfully restored your purchase!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        
        alertVC.addAction(okAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction:AnyObject in transactions {
            
            if let trans = transaction as? SKPaymentTransaction {
                
                switch trans.transactionState {
                    
                case .purchased:
                    
                    print("purchased")
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    if (productID == COINS_PRODUCT_LOW) {
                        
                        self.send(funds: LOW)
                        
                    } else if (productID == COINS_PRODUCT_NORMAL) {
                        
                        self.send(funds: NORMAL)
                        
                    } else if (productID == COINS_PRODUCT_HIGHT) {
                        
                        self.send(funds: HIGHT)
                    }
                    
                    break
                    
                case .failed:
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    print("fail")
                    
                    break
                    
                case .restored:
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    print("restored")
                    
                    break
                    
                default:
                    
                    print("default")
                    
                    break
                }
            }
        }
    }
    
    func send(funds: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_ADD_FUNDS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&funds=" + String(funds);
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
                        
                        let balance = (response["balance"] as AnyObject).integerValue
                        
                        iApp.sharedInstance.setBalance(balance: balance!)
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
