//
//  TipsRequest.swift
//  HHSearch
//
//  Created by Polina on 15.12.2023.
//

import Foundation
struct TipsRequest: DataRequest{
    typealias Response = HHTipsModel
    
    let word: String
    
    var url: EndPoints{
        .getTips(word: word)
    }
    
    var method: HTTPMethods {
        .GET
    }
}
