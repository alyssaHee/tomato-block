//
//  UIViewController+Extensions.swift
//  Tomato Block
//
//  Created by Alyssa H on 2025-08-22.
//

import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        } else if let nav = self as? UINavigationController {
            return nav.visibleViewController?.topMostViewController() ?? nav
        } else if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        } else {
            return self
        }
    }
}
