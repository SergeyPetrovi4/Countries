//
//  WebServiceManager.swift
//  Movies
//
//  Created by Sergey Krasiuk on 04/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import Foundation

class WebServiceManager {
    
    enum NetworkErrors: Error {
        case badURL
        case badResponseOrNetwork
        case parsingFailed
    }
    
    static private let baseAPI = "https://restcountries.eu/rest/v2/"
    static let shared = WebServiceManager()
    private init() {}
    
    func fetch(service: NetworkServiceRepresentable,
               params parameters: [String: String],
               completion: @escaping ((Result<[Country], NetworkErrors>) -> Void)) {
        
        guard var components = URLComponents(string: WebServiceManager.baseAPI + service.rawValue) else {
            completion(.failure(.badURL))
            return
        }
        
        components.queryItems = parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: " ", with: "%20")

        guard let url = components.url else {
            completion(.failure(.badURL))
            return
        }
        
        let session = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in

            guard let responseData = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {

                completion(.failure(.badResponseOrNetwork))
                return
            }

            do {
                let countries = try self.decode([Country].self, fromData: responseData)
                completion(.success(countries))

            } catch {
                completion(.failure(.parsingFailed))
            }
        }
        
        session.resume()
    }
}

extension WebServiceManager {
    
    func decode<T: Decodable>(_ type: T.Type, fromData data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
