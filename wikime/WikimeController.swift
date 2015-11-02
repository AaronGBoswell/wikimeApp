//
//  WikimeController.swift
//  wikime
//
//  Created by Aaron Boswell on 11/1/15.
//  Copyright © 2015 Aaron Boswell. All rights reserved.
//

import Foundation

class WikimeController{
    var maxID = 200
    private let defaults = NSUserDefaults.standardUserDefaults()
    private let wikimeConnector = WikimeConnector()
    
    init(){
        wikimeConnector.getMaxID({ [unowned self] (data, response, error) -> Void  in
            let response = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            self.maxID = Int(response as String)!
            print(self.maxID)
        })
    }
    private var history : [[String:AnyObject]]{
        get{
            return defaults.objectForKey("wikimeHistory") as? [[String:AnyObject]] ?? [[:]]
        }
        set{
            defaults.setObject(newValue, forKey:"wikimeHistory")
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
    func addToHistory(href:String){
        var historyEntry = [String:AnyObject]()
        historyEntry["href"] = href
        history.append(historyEntry)
        wikimeConnector.addhref(href) {[unowned self] (data, response, error) -> Void in
            self.wikimeConnector.addcount(href) { (data, response, error) -> Void in
                print("added\(href)")
            }
        }
    }
    func selectUnseenHref(var id:Int = -1, responder:WikimeResponder){
        if( id < 0){
            id = Int(arc4random_uniform(UInt32(maxID)))
        }else{
            id++
            if id > maxID {
                id = 0
            }
        }
        wikimeConnector.gethref(id) {[unowned self] (data, response, error) -> Void in
            let response = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            if self.isInHistory(response as String){
                self.selectUnseenHref(id, responder: responder)
            }else{
                responder.receiveHref(response as String)
            }
        }
        
    }
}