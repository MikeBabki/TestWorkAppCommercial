//
//  LoginModel.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 19.06.2023.
//

import Foundation

struct LoginModel: Decodable {

    var data: LoginData?
    var message: String?
}

struct LoginData: Decodable {
    
    var email: String?
    var token: String?

    enum CodingKeys: String, CodingKey {

        case email = "Email"
        case token = "Token"
    }
}
