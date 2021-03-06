//
//  ApplicationShortcutHandler.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 03/03/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The shortcut item type for county history shortcut items.
let CountyItemShortcutType = "CountyItem"

/// The class responsible for handling the response to application shortcuts.
class ApplicationShortcutHandler: NSObject {
    private let masterViewController: MasterViewController
    
    init(masterViewController: MasterViewController) {
        self.masterViewController = masterViewController
    }
    
    func handle(_ applicationShortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        var handled = false
        if applicationShortcutItem.type == "Search" {
            masterViewController.beginSearch()
            handled = true
        }
        else if applicationShortcutItem.type == CountyItemShortcutType {
            masterViewController.showCounty(County.countyForName(applicationShortcutItem.localizedTitle)!, animated: true)
            handled = true
        }
        completionHandler(handled)
    }
}
