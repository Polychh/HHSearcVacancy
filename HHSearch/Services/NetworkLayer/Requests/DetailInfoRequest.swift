//
//  DetailInfoRequest.swift
//  HHSearch
//
//  Created by Polina on 15.12.2023.
//

import Foundation

struct DetailInfoRequest: DataRequest{
    typealias Response = HHDetailModel
    
    let id: String
    
    var url: EndPoints{
        .getDetailVacancyInfo(id: id)
    }
    
    var method: HTTPMethods {
        .GET
    }
}
