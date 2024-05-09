//
//  UserModel.swift
//  EventApp
//
//  Created by Bekarys on 07.05.2024.
//

import Foundation

struct UserProfile: Codable {
    let id: Int
    let username: String
    let email: String
    var first_name: String
    var last_name: String
}
