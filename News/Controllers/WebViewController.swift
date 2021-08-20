//
//  WebViewController.swift
//  News
//
//  Created by user198890 on 7/30/21.
//

import UIKit
import WebKit

// Web View controller to display full article
class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    // Url to the article passed from Article Cell
    var url: URL?
    
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.uiDelegate = self
        view = webView
        
        // create title label for nav bar
        let titleLabel = UILabel()
        titleLabel.text = "News"
        let titleView = UIStackView(arrangedSubviews: [titleLabel])
        titleView.axis = .vertical
        titleView.alignment = .center
        navigationItem.titleView = titleView
        
    }
    
    // on load, load the request to the article url
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: url!)
        webView.load(request)
    }


}
