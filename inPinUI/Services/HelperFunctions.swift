//
//  HelperFunctions.swift
//  inPinUI
//
//  Created by Paras Chaudhary on 4/18/22.
//

import Foundation

func json(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}
