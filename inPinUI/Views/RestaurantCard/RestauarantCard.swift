//
//  RestauarantCard.swift
//  inPinUI
//
//  Created by Paras Chaudhary on 4/24/22.
//

import UIKit

class RestauarantCard: UIView {
    @IBOutlet weak var nameAndRating: UITextView!
    @IBOutlet weak var cardImage: UIImageView!
    let restaurantInfo: Restaurant
    
    public init(restaurantInfo: Restaurant,frame: CGRect){
        self.restaurantInfo = restaurantInfo
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func dataDidGetLoaded(){
        
    }
}
