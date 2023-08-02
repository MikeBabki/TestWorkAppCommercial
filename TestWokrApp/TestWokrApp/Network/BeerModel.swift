//
//  BeerModel.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 12.06.2023.
//

import Foundation

struct BeerModel: Decodable {
    var name: String?
    var description: String?
    var image_url: String?
    var ingredients: Ingredients?
}

struct Ingredients: Decodable {
    var malt: [Malt]?
}

struct Malt: Decodable {
    var name: String?
    var amount: Amount?
}

struct Amount: Decodable {
    var value: Float?
    var unit: String?
}

//struct BeerModel: Decodable {
//    let name: String?
//    let description: String?
//    let image_url: String?
//    let ingredients: Ingredients?
//}
//
//// MARK: - Ingredients
//struct Ingredients: Decodable {
//    let malt: [Malt]?
//    let yeast: String?
//}
//
//// MARK: - Malt
//struct Malt: Decodable {
//    let name: String?
//    let amount: Amount?
//}
//
//struct Amount: Decodable {
//    let value: Double?
//}

