//
//  PostUserQuery.swift
//  ReqResApp
//
//  Created by Даниил Сивожелезов on 27.06.2024.
//

import Foundation

struct PostUserQuery: Codable {
    let name: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case email = "job"
    }
}
