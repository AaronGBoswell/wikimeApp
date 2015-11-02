//
//  WikiBrowserViewController.swift
//  wikime
//
//  Created by Aaron Boswell on 10/22/15.
//  Copyright © 2015 Aaron Boswell. All rights reserved.
//

import UIKit

class WikiBrowserViewController: UIViewController, UIWebViewDelegate, WikimeResponder {
    private var wikimeController = WikimeController()
    var displayHref :String?{
        didSet{
            if let href = displayHref {
                if webView != nil{
                    let Url = NSURL(string:href)
                    let requestObj = NSURLRequest(URL: Url!)
                    self.webView.loadRequest(requestObj)
                    wikimeController.addToHistory(href)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        if displayHref == nil{
            wikimeController.selectUnseenHref(responder: self)
        }else{
            displayHref = displayHref!
        }
    }
    @IBOutlet weak var webView: UIWebView!

    func receiveHref(href: String) {
        displayHref = href
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL!.absoluteString
        if(urlString != displayHref){
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WikiBrowserViewController") as! WikiBrowserViewController
                
                newViewController.displayHref = request.URL!.absoluteString
                
                navigationController?.pushViewController(newViewController, animated: true)
                return false
            }

        return true
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        if let documentTitle = webView.stringByEvaluatingJavaScriptFromString("document.title"){
            title = documentTitle.stringByReplacingOccurrencesOfString(" - Wikipedia, the free encyclopedia", withString: "")
            
        }
    }
}


