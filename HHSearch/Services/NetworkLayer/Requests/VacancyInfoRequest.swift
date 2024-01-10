//
//  VacancyInfoRequest.swift
//  HHSearch
//
//  Created by Polina on 15.12.2023.
//

import Foundation

struct VacancyInfoRequest: DataRequest{
    typealias Response = HHVacanciesModel
    
    let word: String
    let page: Int
    
    var url: EndPoints{
        .getVacancy(word: word, page: page)
    }
    
    var method: HTTPMethods {
        .GET
    }
}
