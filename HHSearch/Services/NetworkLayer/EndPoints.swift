//
//  EndPoints.swift
//  HHSearch
//
//  Created by Polina on 15.12.2023.
//

import Foundation

enum EndPoints{
    private var baseURL: String { return "https://api.hh.ru/" }
    
    case getVacancy(word:String, page: Int)
    case getDetailVacancyInfo(id: String)
    case getTips(word: String)
    
    var fullPath: String {
        var endpoint: String
        switch self{
        case .getVacancy(let name, let page):
            endpoint = "vacancies?text=\(name)&page=\(page)&per_page=20"
        case .getDetailVacancyInfo(let vacancyId):
            endpoint = "vacancies/\(vacancyId)"
        case .getTips(let word):
            endpoint = "suggests/vacancy_search_keyword?text=\(word)"
        }
        return baseURL + endpoint
    }
}
