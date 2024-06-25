//
//  UserModel.swift
//  ReqResApp
//
//  Created by Даниил Сивожелезов on 25.06.2024.
//

import Foundation

struct UserModel {
    let id: Int
    let firstName: String
    let lastName: String
    let avatar: URL
    
    static let example = UserModel(id: 2, firstName: "John", lastName: "Carter", avatar: URL(string: "https://reqres.in/img/faces/2-image.jpg")!)
}

struct UsersQuery {
    let data: [UserModel]
}
