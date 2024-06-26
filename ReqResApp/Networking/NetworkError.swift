//
//  NetworkError.swift
//  ReqResApp
//
//  Created by Даниил Сивожелезов on 25.06.2024.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case noData
    case noUsers
    
    var title: String {
        switch self {
        case .decodingError:
            return "Can't decode received data"
        case .noData:
            return "Can't fetch data at all"
        case .noUsers:
            return "No users got from api"
        }
    }
}
