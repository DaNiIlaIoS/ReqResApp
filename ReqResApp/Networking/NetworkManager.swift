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
    
//    func fetchAvatar(from url: URL, completion: @escaping (Data) -> ()) {
//        DispatchQueue.global(qos: .background).async {
//            guard let imageData = try? Data(contentsOf: url) else { return }
//            
//            DispatchQueue.main.async {
//                completion(imageData)
//            }
//        }
//    }
    
    func fetchUsers(completion: @escaping (Result<[UserModel], NetworkError>) -> ()) {
        let session = URLSession.shared.dataTask(with: Link.allUsers.url) { data, response, error in
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
                        if usersQuery.data.count == 0 {
                            sendFailure(with: .noUsers)
                            return
                        }
                        completion(.success(usersQuery.data))
                    }
                    
                } catch {
                    sendFailure(with: .decodingError)
                }
            }
            
            func sendFailure(with error: NetworkError) {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        session.resume()
    }
}

// MARK: - Link
extension NetworkManager {
    enum Link {
        case allUsers
        case withNoData
        case withDecodingError
        case withNoUsers
        
        var url: URL {
            switch self {
            case .allUsers:
                return URL(string: "https://reqres.in/api/users/?delay=2")!
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
