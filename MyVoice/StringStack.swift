//
//  StringStack.swift
//  MyVoice
//
//  Created by Pierre on 12/28/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation

struct StringStack {
    var items = [String]()
    mutating func push(_ item: String) {
        items.append(item)
    }
    mutating func pop() -> String {
        return items.removeLast()
    }
    
    mutating func print() -> String{
        var result: String = ""
        
        for item in items{
            result +=   item + "/"
        }
        return result
    }
    
    mutating func isEmpty() -> Bool{
        return items.isEmpty
    }
}
