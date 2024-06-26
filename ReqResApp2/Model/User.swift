//
//  User.swift
//  ReqResApp2
//
//  Created by Даниил Сивожелезов on 01.07.2024.
//

import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: URL?
    
    init(id: Int, email: String, firstName: String, lastName: String, avatar: URL? = nil) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.avatar = avatar
    }
    
    init(postUserQuery: PostUserQuery) {
        self.id = 0
        self.email = postUserQuery.email
        self.firstName = postUserQuery.name
        self.lastName = ""
        self.avatar = nil
    }
}
