//
//  APIRequests.swift
//  inPinUI
//
//  Created by Paras Chaudhary on 3/29/22.
//

import Foundation
class APIRequestServie{
    static func getRequest(urlString: String, header: [String:String],parserFunction:@escaping (Data?, URLResponse?, Error?) -> Void){
        let url = URL(string: urlString)! //change the url
        let session = URLSession.shared
        var request = URLRequest(url: url)
        for (key, value) in header {
            request.setValue((value), forHTTPHeaderField: key )
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler:parserFunction)

           task.resume()
    }
}
