//
//  IndividualRestaurantViewModel.swift
//  inPinUI
//
//  Created by Paras Chaudhary on 4/24/22.
//

import Foundation
import GoogleMaps

class IndividualRestaurantViewModel{
    var restaurant: Restaurant
    var restaurantCardView: RestauarantCard
    var restaurantMarker: GMSMarker
    public init (restaurant:Restaurant, restaurantCardView:RestauarantCard, restaurantMarker:GMSMarker){
        self.restaurant = restaurant
        self.restaurantCardView = restaurantCardView
        self.restaurantMarker = restaurantMarker
    }
}
