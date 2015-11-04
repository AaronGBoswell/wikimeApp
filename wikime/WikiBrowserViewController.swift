//
//  WikiBrowserViewController.swift
//  wikime
//
//  Created by Aaron Boswell on 10/22/15.
//  Copyright © 2015 Aaron Boswell. All rights reserved.
//

import UIKit

class WikiBrowserViewController: UIViewController, UIWebViewDelegate, WikimeResponder {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var wikimeController = WikimeController.sharedWikimeController
    var fromRandom = true
    var displayHref :String?{
        didSet{
            if let href = displayHref {
                if webView != nil{
                    let Url = NSURL(string:href)
                    let requestObj = NSURLRequest(URL: Url!)
                    self.webView.loadRequest(requestObj)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareHref:")
        navigationItem.rightBarButtonItem = shareButton
        navigationItem.rightBarButtonItem?.enabled = false
        webView.delegate = self
        if displayHref == nil{
            wikimeController.selectUnseenHref(responder: self)
        }else{
            displayHref = displayHref!
            fromRandom = false
        }
        self.view.bringSubviewToFront(activityIndicator)

        activityIndicator.stopAnimating()
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appDidEnterBackround:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    func shareHref(view:UIView){
        var sharingItems = [AnyObject]()
        
        if let href = displayHref{
            sharingItems.append(title!)
            sharingItems.append(href)
            let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(animated: Bool) {
        stopMeasuring()
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
        activityIndicator.stopAnimating()
        if let documentTitle = webView.stringByEvaluatingJavaScriptFromString("document.title"){
            title = documentTitle.stringByReplacingOccurrencesOfString(" - Wikipedia, the free encyclopedia", withString: "")
            wikimeController.addToHistory(displayHref!,articleTitle: title!,fromRandom: fromRandom)

        }
        screenKey = displayHref
        navigationItem.rightBarButtonItem?.enabled = true
        startMeasuring()
    }
    
    var startDate:NSDate?
    func startMeasuring(){
        startDate = NSDate()
    }
    func stopMeasuring(){
        if let time = startDate?.timeIntervalSinceNow{
            let secondsInScreen = Int(abs(time))
            addSecondsToScreen(secondsInScreen)
        }
    }
    var screenKey:String?
    func addSecondsToScreen(secondsInScreen:Int){
        if let key = screenKey{
            let defaults = NSUserDefaults.standardUserDefaults()
            let s = defaults.objectForKey(key) as? Int ?? 0
            defaults.setObject(s + secondsInScreen, forKey: key)
            defaults.synchronize()
        }
    }
    func appDidEnterBackround(not:NSNotification){
        stopMeasuring()
    }
    func appWillEnterForeground(not:NSNotification){
        startMeasuring()

    }
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil{
            if let key = screenKey{
                if let href = displayHref{
                    let wc = WikimeConnector()
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let time = defaults.objectForKey(key) as? Int ?? 0
                    print("time spent on page :\(time)")
                    wc.addtime(href, time: time, completionHandler: { (data, response, error) -> Void in
                        defaults.setObject(0, forKey: key)
                        let d = NSString(data: data!, encoding: NSUTF8StringEncoding)!

                        print(d)
                    })
                }
            }
        }
    }
}


