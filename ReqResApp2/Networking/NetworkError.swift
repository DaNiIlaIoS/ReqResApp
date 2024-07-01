//
//  NetworkError.swift
//  ReqResApp2
//
//  Created by Даниил Сивожелезов on 01.07.2024.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case noData
    case noUsers
    case deletingError
    
    var title: String {
        switch self {
        case .decodingError:
            return "Can't decode received data"
        case .noData:
            return "Can't fetch data at all"
        case .noUsers:
            return "No users got from api"
        case .deletingError:
            return "Can't delete user"
        }
    }
}
