//
//  WikiParser.swift
//  wikime
//
//  Created by Aaron Boswell on 3/1/16.
//  Copyright © 2016 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit

enum Item{
    case image(String,String)
    case paragraph(String)
}

func ParseURL(url:NSURL)->[[String:[Item]]]{
    var finalArray:[[String:[Item]]] = [];
    var pagecontents = ""
    do{
        pagecontents = try String(contentsOfURL: url)

    } catch{
        return finalArray
    }
    let document = HTML(html: pagecontents, encoding: NSUTF8StringEncoding)!
    var heading = "Introduction"
    var items:[Item] = []
    var imageString = ""
    for par in document.css("p, h2, .image, .thumbcaption") {
        if let c = par.className{
            print(c)
            if c == "image"{
                imageString = par["href"]!
            }
            if c == "thumbcaption"{
                items.append(Item.image(imageString, par.text!))
                imageString = ""
            }
        }
        if let t = par.tagName{
            if( t == "p"){
                items.append(Item.paragraph(par.toHTML!))
            }
            if( t == "h2"){
                finalArray.append([heading:items])
                heading = par.text!.stringByReplacingOccurrencesOfString("[edit]", withString: "")
                items = []
            }
    
        }
        print(par.text)
        
    }
    return finalArray

}

