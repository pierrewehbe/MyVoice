//
//  Extensions.swift
//  MyVoice
//
//  Created by Pierre on 11/12/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import UIKit



extension UIViewController {
    // utility to set the status bar appearance
    // Note: Make sure "View controller-based status bar appearance" is set to NO in your target settings or this won't work
    func setStatusBarForDarkBackground(dark: Bool) {
        UIApplication.shared.statusBarStyle = dark ? .lightContent : .default
        setNeedsStatusBarAppearanceUpdate()
    }
}



//extension String {
//    subscript(i: Int) -> String {
//        guard i >= 0 && i < characters.count else { return "" }
//        return String(self[index(startIndex, offsetBy: i)])
//    }
//    subscript(range: Range<Int>) -> String {
//        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
//        return substring(with: lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex))
//    }
//    subscript(range: ClosedRange<Int>) -> String {
//        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
//        return substring(with: lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex))
//    }
//}

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}



extension UIViewController{
// MARK: Keyboard
open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
}

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
}
}
