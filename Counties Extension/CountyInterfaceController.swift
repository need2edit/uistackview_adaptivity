//
//  CountyInterfaceController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 02/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import WatchKit
import Foundation

/// The interface controller responsible for displaying county details in an interface controller
class CountyInterfaceController: WKInterfaceController {
    @IBOutlet fileprivate weak var flagImage: WKInterfaceImage!
    @IBOutlet fileprivate weak var nameLabel: WKInterfaceLabel!
    @IBOutlet fileprivate weak var populationLabel: WKInterfaceLabel!
    fileprivate var county: County?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let countyName = context as? String else {
            return
        }
        
        county = County.countyForName(countyName)
        setTitle(county?.name)
        flagImage.setImage(county?.flagImage)
        nameLabel.setText(county?.name)
        populationLabel.setText(county?.populationDescription)
    }

    override func willActivate() {
        guard let county = county else {
            return
        }
        updateUserActivity(HandoffActivity.CountyDetails, userInfo: [HandoffUserInfo.CountyName: county.name], webpageURL: nil)
        
        super.willActivate()
    }

    override func didDeactivate() {
        invalidateUserActivity()
        super.didDeactivate()
    }
}
