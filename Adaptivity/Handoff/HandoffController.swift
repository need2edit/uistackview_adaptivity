//
//  HandoffController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 02/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import WatchKit

class HandoffController: NSObject, CountyUserActivityHandling {
    //MARK: CountyUserActivityHandling
    var handledActivityType: String {
        get {
            return HandoffActivity.CountyDetails
        }
    }
    
    func countyFromUserActivity(userActivity: NSUserActivity) -> County? {
        if let userInfo = userActivity.userInfo, countyName = userInfo[HandoffUserInfo.CountyName] as? String, selectedCounty = County.allCounties.filter({$0.name == countyName}).first {
            return selectedCounty
        }
        return nil
    }
}