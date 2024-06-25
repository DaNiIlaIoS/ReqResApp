//
//  NetworkError.swift
//  ReqResApp
//
//  Created by Даниил Сивожелезов on 25.06.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL, decodingError, noData
}
