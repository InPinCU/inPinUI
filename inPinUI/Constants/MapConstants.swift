//
//  MapConstants.swift
//  inPinUI
//
//  Created by Paras Chaudhary on 3/29/22.
//

import Foundation


class MapConstants {
    
    static let iconMap = [
        0: "red1",
        1: "red2",
        2: "red3",
        3: "red4",
        4: "red5",
        5: "yellow1",
        6: "yellow2",
        7: "yellow3",
        8: "yellow4",
        9: "yellow5",
]
    
    static let styleURL = """
[
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "administrative.neighborhood",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    }
]
""";
}

