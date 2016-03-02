//
//  WikimeConnector.swift
//  wikime
//
//  Created by Aaron Boswell on 11/1/15.
//  Copyright © 2015 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit

class WikimeConnector {
    var baseURL = "http://159.203.21.108:3000"
    var getallLinks = "/data/links"
    var addsession = "/data/addsession"
    var addvisit = "/data/addvisit"
    var addpath = "/data/addpath"

    
    private let UUID = UIDevice.currentDevice().identifierForVendor?.UUIDString

    func getURLObject(completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void){
        let url = NSURL(string: (baseURL + getallLinks))
        print(url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!,completionHandler: completionHandler)
        task.resume()
    }
    
    func addtime(href:String, time:Int){
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+addsession)!)
        request.HTTPMethod = "POST"
        
        request.HTTPBody = "url=\(href)&length=\(time)&user=\(UUID!)".dataUsingEncoding(NSUTF8StringEncoding)
        let t = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
        }
        t.resume()

    }
    func addvisit(href:String){
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+addvisit)!)
        request.HTTPMethod = "POST"
        
        request.HTTPBody = "url=\(href)&user=\(UUID!)".dataUsingEncoding(NSUTF8StringEncoding)
        let t = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
        }
        t.resume()
    }
    func addpath(fromhref:String, tohref:String){
        print(fromhref + tohref)
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+addpath)!)
        request.HTTPMethod = "POST"
        
        request.HTTPBody = "from=\(fromhref)&to=\(tohref)&user=\(UUID!)".dataUsingEncoding(NSUTF8StringEncoding)
        let t = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
        }
        t.resume()
        
    }
    
}