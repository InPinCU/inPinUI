//
//  GMSMarkerExtension.swift
//  inPinUI
//
//  Created by Paras Chaudhary on 4/24/22.
//

import Foundation
import GoogleMaps



extension GMSMarker {
    var yelpID: String {
        set(yelpID) {
            self.userData = yelpID
        }

        get {
           return self.userData as! String
       }
   }
}
