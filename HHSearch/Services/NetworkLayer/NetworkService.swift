//
//  NetworkService.swift
//  HHSearch
//
//  Created by Polina on 17.11.2023.
//
import Foundation

protocol Network {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, HHError>) -> Void)
}

final class DefaultNetworkService: Network {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, HHError>) -> Void) {
        guard let url = URL(string: request.url.fullPath) else {
            completion(.failure(.invalidNameVacancy))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let _ = error {
                return completion(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(.invalidResponse))
            }
            
            guard let data = data else {
                return completion(.failure(.invalidDataFromServer))
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        .resume()
    }
}
