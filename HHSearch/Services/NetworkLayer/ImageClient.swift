//
//  ImageClient.swift
//  HHSearch
//
//  Created by Polina on 15.12.2023.
//

import UIKit

protocol NetworkImageClient{
    func downloadImage(with url: String, completed: @escaping (Result<UIImage?, HHError>) -> Void)
}

final class ImageClient: NetworkImageClient{
    private let cache = NSCache<NSString, UIImage>()
    
    func downloadImage(with url: String, completed: @escaping (Result<UIImage?, HHError>) -> Void){
        
        let cacheKey = NSString(string: url)
        
        if let image = cache.object(forKey: cacheKey){
            completed(.success(image))
            return
        }
        guard let url = URL(string: url) else {
            completed(.failure(.invalidNameVacancy))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else{
                completed(.failure(.invalidDataFromServer))
                return
            }
            
            DispatchQueue.main.async{
                guard let image = UIImage(data: data) else{
                    completed(.success(nil))
                    return
                }
                self.cache.setObject(image, forKey: cacheKey)
                completed(.success(image))
            }
        }
        task.resume()
    }
}
    
    
