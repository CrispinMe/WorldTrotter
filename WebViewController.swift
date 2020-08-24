//
//  WebViewCong.swift
//  WorldTrotter
//
//  Created by Crispin Lloyd on 17/11/2017.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
         print("WebViewController loaded its view.")
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webView.uiDelegate = self
        
        
        //Set it as the view of this view controller
        view = webView

        
        let myURL = URL(string: "https://www.bignerdranch.com")
        let myRequest = URLRequest(url: myURL!)
        
        webView.load(myRequest)
        
       
        
    }
}
