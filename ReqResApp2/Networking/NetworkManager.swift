//
//  NetworkManager.swift
//  ReqResApp2
//
//  Created by Даниил Сивожелезов on 01.07.2024.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchUsers(completion: @escaping (Result<[User], AFError>) -> ()) {
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(Link.allUsers.url)
            .validate()
            .responseDecodable(of: UsersQuery.self, decoder: decode) { dataResponse in
                switch dataResponse.result {
                case .success(let usersQuery):
                    completion(.success(usersQuery.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
//    func fetchUsers(completion: @escaping (Result<[User], NetworkError>) -> ()) {
//        URLSession.shared.dataTask(with: Link.allUsers.url) { data, response, error in
//            guard let data = data,
//                  let response = response as? HTTPURLResponse else {
//                print(error?.localizedDescription ?? "No error description")
//                sendFailure(with: .noData)
//                return
//            }
//            
//            if (200...299).contains(response.statusCode) {
//                let decode = JSONDecoder()
//                decode.keyDecodingStrategy = .convertFromSnakeCase
//                
//                do {
//                    let usersQuery = try decode.decode(UsersQuery.self, from: data)
//                    DispatchQueue.main.async {
//                        if usersQuery.data.isEmpty {
//                            sendFailure(with: .noUsers)
//                            return
//                        }
//                        completion(.success(usersQuery.data))
//                    }
//                    
//                } catch {
//                    sendFailure(with: .decodingError)
//                }
//            }
//        }.resume()
//        
//        func sendFailure(with error: NetworkError) {
//            DispatchQueue.main.async {
//                completion(.failure(error))
//            }
//        }
//    }
    
    func postUser(_ user: User, completion: @escaping (Result<PostUserQuery, AFError>) -> ()) {
        let postUserParameters = PostUserQuery(name: "\(user.firstName) \(user.lastName)", email: user.email)
        
        AF.request(Link.singleUser.url, method: .post, parameters: postUserParameters)
            .validate()
            .responseDecodable(of: PostUserQuery.self) { dataResponse in
                switch dataResponse.result {
                    
                case .success(let postUserQuery):
                    completion(.success(postUserQuery))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
//    func postUser(_ user: User, completion: @escaping (Result<PostUserQuery, NetworkError>) -> ()) {
//        var request = URLRequest(url: Link.singleUser.url)
//        request.httpMethod = "POST"
//        
//        let userQuery = PostUserQuery(name: "\(user.firstName) \(user.lastName)", email: "\(user.email)")
//        let jsonData = try? JSONEncoder().encode(userQuery)
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//        
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            guard let data = data else { return }
//            if let postUserQuery = try? JSONDecoder().decode(PostUserQuery.self, from: data) {
//                DispatchQueue.main.async {
//                    completion(.success(postUserQuery))
//                }
//            } else {
//                DispatchQueue.main.async {
//                    completion(.failure(.decodingError))
//                }
//            }
//        }.resume()
//    }
    
    func deleteUser(id: Int, completion: @escaping (Bool) -> ()) {
        let deleteUserUrl = Link.singleUser.url.appending(component: "\(id)")
        
        AF.request(deleteUserUrl, method: .delete)
            .validate(statusCode: [204])
            .response { dataResponse in
                switch dataResponse.result {
                case .success:
                    completion(true)
                case .failure(_):
                    completion(false)
                }
            }
    }
    
//    func deleteUserWithId(id: Int) async throws -> Bool {
//        let userUrl = Link.singleUser.url.appending(component: "\(id)")
//        var request = URLRequest(url: userUrl)
//        request.httpMethod = "DELETE"
//        
//        let (_, response) = try await URLSession.shared.data(for: request)
//        
//        if let response = response as? HTTPURLResponse {
//            return response.statusCode == 204
//        }
//        
//        return false
//    }
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
