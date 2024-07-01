//
//  PostUserQuery.swift
//  ReqResApp2
//
//  Created by Даниил Сивожелезов on 01.07.2024.
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
