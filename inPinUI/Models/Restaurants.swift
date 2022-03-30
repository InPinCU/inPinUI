//
//  Restaurants.swift
//  inPinUI
//
//  Created by Paras Chaudhary on 3/29/22.
//

import Foundation

struct Restaurant:Decodable{
 
    let yelpId:String
    let location: Location
    let _id:String
    let averageRankedCommentCount:Double?
    let averageRankedLikeCount:Double?
    let averageRecentCommentCount:Double?
    let averageRecentLikeCount:Double?
    let name:String
    let rankedCommentCount:Int?
    let rankedLikeCount:Int?
    let recentCommentCount:Int?
    let recentLikeCount:Int?
    let totalCommentCount:Int?
    let totalLikeCount:Int?
    let updatedAt:String
//    let isClosed:String?
}
