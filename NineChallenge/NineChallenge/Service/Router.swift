//
//  Router.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 10/7/2023.
//

import Foundation
import UIKit
import WebKit

protocol RouterAction {
    func openArticle(with asset:Asset)
}

struct Router : RouterAction {
    unowned let navigationController : UINavigationController
    
    func openArticle(with asset:Asset) {
        if let url = asset.url, let aURL = URL(string: url) {
            let webPage = WebPageController(url: aURL)
            self.navigationController.pushViewController(webPage, animated: true)
        }
    }
}
