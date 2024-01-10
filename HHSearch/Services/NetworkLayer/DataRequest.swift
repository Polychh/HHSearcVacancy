//
//  DataRequest.swift
//  HHSearch
//
//  Created by Polina on 15.12.2023.
//
import Foundation

protocol DataRequest {
    associatedtype Response
    var url: EndPoints { get }
    var method: HTTPMethods { get }
    
    func decode(_ data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
