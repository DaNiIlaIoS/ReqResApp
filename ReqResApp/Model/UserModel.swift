//
//  UserModel.swift
//  ReqResApp
//
//  Created by Даниил Сивожелезов on 25.06.2024.
//

import Foundation

struct UserModel: Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: URL?
    
    static let example = UserModel(id: 2, email: "sivozelezovdaniil@gmail.com", firstName: "John", lastName: "Carter", avatar: URL(string: "https://reqres.in/img/faces/2-image.jpg")!)
    
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

struct UsersQuery: Codable {
    let data: [UserModel]
}
