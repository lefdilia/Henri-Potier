//
//  APIManager.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 23/4/2022.
//

import Foundation
import CoreData


enum NetworkError: Error {
    case wrongEndpoint
    case invalidResponse(Int)
    case invalidData
    case invalidDecode(String)
    
    var localizedDescription: String {
        switch self {
        case .wrongEndpoint:
            return "Please check the request URL"
        case .invalidResponse(let statusCode):
            return "Please, check if the server is up and running - Status Code is : \(statusCode)"
        case .invalidData:
            return "Data is corrupted"
        case .invalidDecode(let error):
            return error
        }
    }
}

enum Endpoint {
    case Books
    case Offers([String])
    
    var source: String {
        switch self {
        case .Books:
            return "http://henri-potier.xebia.fr/books"
        case .Offers(let isbns):
            return "http://henri-potier.xebia.fr/books/\(isbns.joined(separator: ","))/commercialOffers"
        }
    }
}

protocol APIManagerProtocol {
    func fetchRemoteStore(url: Endpoint, completion: @escaping (Result<[Books], NetworkError>)->Void)
    func fetchRemoteOffers(url: Endpoint, completion: @escaping (Result<CommercialOffers, NetworkError>)->Void)
}

class APIManager: APIManagerProtocol {
    
    func fetchRemoteStore(url: Endpoint, completion: @escaping (Result<[Books], NetworkError>)->Void) {
        
        guard let endpoint = URL(string: url.source) else {
            return completion(.failure(.wrongEndpoint))
        }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse((response as? HTTPURLResponse)?.statusCode ?? 0)))
                return
            }
            
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            let context = CoreDataManager.shared.moc
            let decoder = JSONDecoder()
            
            if let contextUserInfoKey = CodingUserInfoKey.context {
                decoder.userInfo[contextUserInfoKey] = context
            }
            
            do {
                _ = try decoder.decode([Books].self, from: data)
                try context.save()
                
                let books = CoreDataManager.shared.fetchBooks()
                return completion(.success(books))
        
            } catch {
                let error: NetworkError = .invalidDecode(error.localizedDescription)
                return completion(.failure(error))
            }
        
        }.resume()
    }
    
    //MARK: - Fetch Remote Offers
    func fetchRemoteOffers(url: Endpoint, completion: @escaping (Result<CommercialOffers, NetworkError>)->Void) {
        
        guard let endpoint = URL(string: url.source) else {
            return completion(.failure(.wrongEndpoint))
        }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse((response as? HTTPURLResponse)?.statusCode ?? 0)))
                return
            }
            
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let offers = try decoder.decode(CommercialOffers.self, from: data)
                return completion(.success(offers))
        
            } catch {
                let error: NetworkError = .invalidDecode(error.localizedDescription)
                return completion(.failure(error))
            }
        }.resume()
    }
    
}

