//
//  HHTipsModel.swift
//  HHSearch
//
//  Created by Polina on 14.12.2023.
//

import Foundation

struct HHTipsModel: Decodable{
    let items: [TipsItem]
}

struct TipsItem: Decodable {
    let text: String
}
