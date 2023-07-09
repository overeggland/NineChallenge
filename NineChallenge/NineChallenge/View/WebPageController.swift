//
//  WebPageController.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 9/7/2023.
//

import Foundation
import WebKit
import UIKit
import SnapKit
import ProgressHUD

final class WebPageController: UIViewController, WKNavigationDelegate {
    private lazy var webView = {
        let webViewConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: CGRectZero, configuration: webViewConfiguration)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        return webView
    }()
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ARTICLE"
        ProgressHUD.show("LOADING...", icon: .message, interaction: true, delay: 3.5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }
    
    // MARK: - WKNavigationDelegate Methods
    // Web view finished loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
    
    // Web view failed to load
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.dismiss()
    }
    
    // Other WKNavigationDelegate methods...
}






