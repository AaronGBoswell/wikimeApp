//
//  WikimeController.swift
//  wikime
//
//  Created by Aaron Boswell on 11/1/15.
//  Copyright © 2015 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit

class WikimeController{
    var urlArray:[[String:String]] = []
    private let defaults = NSUserDefaults.standardUserDefaults()
    private let wikimeConnector = WikimeConnector()
    static let sharedWikimeController = WikimeController()
    
    
    init(){
        wikimeConnector.getURLObject(){ [unowned self] (data, response, error) -> Void  in
            if error != nil {
                print("error=\(error)")
                return
            }
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                self.urlArray = json as! [[String : String]]
                print(self.wikiHistory)
                
            }catch{
                print("error")
            }
        };
    }
    private var history : [[String:AnyObject]]{
        get{
            return defaults.objectForKey("wikimeHistory") as? [[String:AnyObject]] ?? [[:]]
        }
        set{
            defaults.setObject(newValue, forKey:"wikimeHistory")
        }
    }
    func clearHistory(){
        
        history = [[String:AnyObject]]()
    }
    var wikiHistory: [[String:AnyObject]]{
        get{
            return history.reverse()
        }
    }
    
    func isInHistory(href:String)->Bool{
        for element in history{
            if element["href"] as? String ?? "" == href{
                return true
            }
        }
        return false
    }
    func move(fromhref: String, tohref: String){
        wikimeConnector.addpath(fromhref,tohref: tohref)
    }
    func addToHistory(href:String, articleTitle:String, fromRandom:Bool){
        var historyEntry = [String:AnyObject]()
        historyEntry["href"] = href
        historyEntry["articleTitle"] = articleTitle
        historyEntry["fromRandom"] = fromRandom
        history.append(historyEntry)
        wikimeConnector.addvisit(href)
    }
    
    func selectUnseenHref(var index:Int = -1) -> String{
        if( index < 0){
            index = Int(arc4random_uniform(UInt32(urlArray.count-1)))
        }else{
            index++
            if index > urlArray.count-1 {
                index = 0
            }
        }
        guard var link = urlArray[index]["url"] else {
            return "fucked"
        }
        if self.isInHistory(link){
            link = selectUnseenHref(index)
        }
        return link
        
    }
    
}