//
//  HHDetailModel.swift
//  HHSearch
//
//  Created by Polina on 20.11.2023.
//

import Foundation

struct HHDetailModel: Decodable{
    let name: String
    let description: String?
    let address: Address?
}

struct Address: Decodable{
    let raw: String?
}
