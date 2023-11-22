//
//  HHVacanciesModel.swift
//  HHSearch
//
//  Created by Polina on 17.11.2023.
//

import Foundation

struct HHVacanciesModel: Decodable{
    let items: [Item]
    let pages: Int
}

struct Item: Decodable{
    let id: String
    let name: String
    let salary: Salary?
    let employer: Employer
    let snippet: Snippet?
}

struct Salary: Decodable{
    let from: Int?
    let to: Int?
    let currency: String?
}

struct Employer: Decodable {
    let name: String
    let logoUrls: LogoUrls?

    private enum CodingKeys: String, CodingKey {
        case name
        case logoUrls = "logo_urls"
    }
}

struct LogoUrls: Decodable {
    let imageUrl: String?

    private enum CodingKeys: String, CodingKey {
        case imageUrl = "240"
    }
}

struct Snippet: Decodable{
    let requirement, responsibility: String?
}
