//
//  ViewController.swift
//  WebCache
//
//  Created by yu qin on 2019/5/14.
//  Copyright © 2019 yu qin. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    lazy var webView: WKWebView = {
        let webView = WKWebView.init(frame: self.view.bounds)
        self.view.addSubview(webView)
        return webView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request:URLRequest = URLRequest(url: URL(string: "https://www.baidu.com")!)
        webView.load(request)
    }

}

