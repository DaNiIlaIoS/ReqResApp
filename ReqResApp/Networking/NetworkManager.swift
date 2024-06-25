//
//  NetworkManager.swift
//  ReqResApp
//
//  Created by Даниил Сивожелезов on 25.06.2024.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchAvatar(from url: URL, completion: @escaping (Data) -> ()) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                completion(imageData)
            }
        }
    }
    
    func fetchUsers(completion: @escaping (Result<[UserModel], NetworkError>) -> ()) {
        guard let url = URL(string: "https://reqres.in/api/users") else { return }
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print("Status code \(response.statusCode)")
            }
            
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                completion(.failure(.noData))
                return
            }
            let decode = JSONDecoder()
            decode.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let usersQuery = try decode.decode(UsersQuery.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(usersQuery.data))
                }
                
            } catch let error {
                print(error.localizedDescription)
                completion(.failure(.decodingError))
            }
        }
        session.resume()
    }
}

