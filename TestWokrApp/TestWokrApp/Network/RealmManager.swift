//
//  RealmManager.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 07.07.2023.
//

import Foundation
import RealmSwift

class BeerRealmModel: Object {
    @Persisted var name: String
    @Persisted var descript: String
    @Persisted var image_url: String
    
    enum CodingKeys: String, CodingKey {

        case descript = "description"
    }
}

