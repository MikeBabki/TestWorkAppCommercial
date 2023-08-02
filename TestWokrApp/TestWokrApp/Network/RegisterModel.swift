//
//  RegisterModel.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 15.06.2023.
//

import Foundation


struct RegisterModel: Decodable {
    
    var data: DataClass?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
    }
}

struct DataClass: Decodable {
    
    var email: String?
    var token: String?

    enum CodingKeys: String, CodingKey {

        case email = "Email"
        case token = "Token"
    }
}
