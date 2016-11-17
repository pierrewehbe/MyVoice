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
