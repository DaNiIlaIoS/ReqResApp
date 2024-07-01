//
//  NetworkManager.swift
//  ReqResApp2
//
//  Created by Даниил Сивожелезов on 01.07.2024.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchUsers(completion: @escaping (Result<[User], NetworkError>) -> ()) {
        URLSession.shared.dataTask(with: Link.allUsers.url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse else {
                print(error?.localizedDescription ?? "No error description")
                sendFailure(with: .noData)
                return
            }
            
            if (200...299).contains(response.statusCode) {
                let decode = JSONDecoder()
                decode.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let usersQuery = try decode.decode(UsersQuery.self, from: data)
                    DispatchQueue.main.async {
                        if usersQuery.data.isEmpty {
                            sendFailure(with: .noUsers)
                            return
                        }
                        completion(.success(usersQuery.data))
                    }
                    
                } catch {
                    sendFailure(with: .decodingError)
                }
            }
        }.resume()
        
        func sendFailure(with error: NetworkError) {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Link
extension NetworkManager {
    enum Link {
        case allUsers
        case singleUser
        case withNoData
        case withDecodingError
        case withNoUsers
        
        var url: URL {
            switch self {
            case .allUsers:
                return URL(string: "https://reqres.in/api/users/?delay=2")!
            case .singleUser:
                return URL(string: "https://reqres.in/api/users/")!
            case .withNoData:
                return URL(string: "https://reqres.int/api/users/")!
            case .withDecodingError:
                return URL(string: "https://reqres.in/api/users/3?delay=2")!
            case .withNoUsers:
                return URL(string: "https://reqres.in/api/users/?delay=2&page=3")!
            }
        }
    }
}
