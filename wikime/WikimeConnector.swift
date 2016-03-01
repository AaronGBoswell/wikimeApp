//
//  WikimeConnector.swift
//  wikime
//
//  Created by Aaron Boswell on 11/1/15.
//  Copyright © 2015 Aaron Boswell. All rights reserved.
//

import Foundation
class WikimeConnector {
    var baseURL = "http://www.mywikime.com/wikime/"
    var addhrefURL = "addhref.php"
    var gethrefURL = "gethref.php"
    var addtimeURL = "addtime.php"
    var addcountURL = "addcount.php"
    var getMaxIDURL = "getMaxID.php"
    
    func gethref(id:Int, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void){
        let url = NSURL(string: (baseURL + gethrefURL + "?ID=\(id)"))
        print(url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!,completionHandler: completionHandler)
        task.resume()
    }
    func addhref(href:String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void){
        let url = NSURL(string: (baseURL + gethrefURL + "?href=\(href)"))
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!,completionHandler: completionHandler)
        task.resume()
    }
    func addtime(href:String, time:Int, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void){
        let url = NSURL(string: (baseURL + addtimeURL + "?href=\(href)&time=\(time)"))
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!,completionHandler: completionHandler)
        task.resume()
    }
    func addcount(href:String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void){
        let url = NSURL(string: (baseURL + addcountURL + "?href=\(href)"))
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!,completionHandler: completionHandler)
        task.resume()
    }
    func getMaxID(completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void){
        let url = NSURL(string: (baseURL + getMaxIDURL))
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!,completionHandler: completionHandler)
        task.resume()
    }
}