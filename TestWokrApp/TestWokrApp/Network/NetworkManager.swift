//
//  NetworkManager.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 12.06.2023.
//

import Foundation
import SwiftyJSON

var registerModelInstance = DataClass()
var loginModelInstance = LoginData()
var beerModelInstance = [BeerModel]()

class NetworkManager {
    
    //MARK: - Api Call for beer catalog
    
    func getResult(page: Int, totalCount: Int, completion: @escaping(Result<[BeerModel]?, Error>) -> Void) {
        
        var urlString = URLManager.beerURLCreator(page: page, totalCount: totalCount)
        var url = URL(string: urlString)
       
        URLSession.shared.dataTask(with: url!) { data, _, error in
        
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            do {
               
                let json = try! JSON(data: data)
                var malts = [Malt]()
                let arr = json.arrayValue.map { item in
                let ingr =  item["ingredients"]["malt"].arrayValue.map({ jsn in
                let ingredient = Ingredients(malt: jsn.map({ str, jsn in
                            Malt(name: jsn.stringValue)
                        }))
                    })
                }

                json.arrayValue.map { item in
                    
                   let malto = item["ingredients"]["malt"].arrayValue.map({ malt in
                       let amount = Amount(value: malt["amount"]["value"].floatValue, unit: malt["amount"]["unit"].stringValue)
                     return Malt(name: malt["name"].stringValue, amount: amount)
                       
                    })

                }

                let beerModels = json.arrayValue.map{

                    return  BeerModel(
                        name: $0["name"].stringValue,
                        description: $0["description"].stringValue,
                        image_url: $0["image_url"].stringValue,
                        ingredients: Ingredients(malt: $0["ingredients"]["malt"].arrayValue.map({ malt in
                            let amount = Amount(value: malt["amount"]["value"].floatValue, unit: malt["amount"]["unit"].stringValue)
                            
                          return Malt(name: malt["name"].stringValue, amount: amount)
                            
                         }))
                    )
                }
                completion(.success(beerModels))
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
//MARK: - Api Call for RegistrationView
    
    func registerApiCall(name: String, email: String, password: String, completion: @escaping(Result<DataClass?, Error>) -> Void) {
        guard let url = URL(string: URLManager.profileRegister) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: AnyHashable] = [
            "name" : email,
            "email": email,
            "password": password,
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            do {
                let json = try JSON(data: data)
                if let userName = json["data"]["Name"].string,
                   let token1 = json ["data"]["Token"].string
                   
                {
                    let service = ""
                    KeychainManager.saveToken(token: token1, service: service)
                    registerModelInstance.email = userName
                    registerModelInstance.token = token1
                    completion(.success(registerModelInstance))


                } else {
                    let messageError = json ["Message"].string
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: messageError])
                }
                
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
                print("Error in NetworkManager - failure case")
            }
        }
        task.resume()
    }

    // MARK: - Api Call for LoginView
    
    func loginApiCall(email: String, password: String, completion: @escaping(Result<LoginData?, Error>) -> Void) {
        guard let url = URL(string: URLManager.profileLogin) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: AnyHashable] = [
            "email": email,
            "password": password,
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in

            guard let data = data, error == nil else {
                return
            }
            do {
                let json = try! JSON(data: data)
                if let userMail = json["data"]["Email"].string,
                   let token = json ["data"]["Token"].string
                   
                {
                    let service = ""
                    KeychainManager.saveToken(token: token, service: service)
                    loginModelInstance.email = userMail
                    loginModelInstance.token = token
                    completion(.success(loginModelInstance))
                } else {
                    let messageForError = json ["message"].string

                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: messageForError])
                }

            } catch {
                completion(.failure(error))
                print(error)
                print("error happen in login")
            }
        }
        task.resume()
    }
}
