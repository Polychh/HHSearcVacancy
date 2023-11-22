//
//  NetworkService.swift
//  HHSearch
//
//  Created by Polina on 17.11.2023.
//
import UIKit

protocol Network{
    func getVacanciesInfo(for nameVacancy: String, page: Int, completed: @escaping (Result<[Item], HHError>) -> Void)
    func downloadImage(with url: String, completed: @escaping (Result<UIImage?, HHError>) -> Void)
    func getDetailVacancyInfo(for vacancyId: String, completed: @escaping (Result<HHDetailModel, HHError>) -> Void)
    var allPages: Int {get set}
}

final class NetworkService: Network{
    
    private let baseURL = "https://api.hh.ru/vacancies"
    private let decoder = JSONDecoder()
    private let cache = NSCache<NSString, UIImage>()
    var allPages = 0
    
    func getVacanciesInfo(for nameVacancy: String, page: Int, completed: @escaping (Result<[Item], HHError>) -> Void) {
        let endpoint = baseURL + "?text=\(nameVacancy)&page=\(page)&per_page=20"
        
        guard let url = URL(string: endpoint) else {
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
            
            do { // parsing json
                let decodeData = try self.decoder.decode(HHVacanciesModel.self, from: data)
                self.allPages = decodeData.pages
                completed(.success(decodeData.items))
            }catch{
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
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
    
    func getDetailVacancyInfo(for vacancyId: String, completed: @escaping (Result<HHDetailModel, HHError>) -> Void){
        let endpoint = baseURL + "/\(vacancyId)" 
        
        guard let url = URL(string: endpoint) else { 
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
            
            do { // parsing json
                let decodeData = try self.decoder.decode(HHDetailModel.self, from: data)
                completed(.success(decodeData))
            }catch{
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
    
    
