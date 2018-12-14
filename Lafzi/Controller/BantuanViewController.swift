//
//  BantuanViewController.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 13/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit
import WebKit

class BantuanViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var html = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString(html, baseURL: nil)
        webView.navigationDelegate  = self
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            let url = navigationAction.request.url
            UIApplication.shared.canOpenURL(url!)
            UIApplication.shared.open(url!)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

}
