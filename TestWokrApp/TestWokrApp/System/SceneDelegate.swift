//
//  SceneDelegate.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 04.06.2023.
//

import UIKit
import Foundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var service = ""
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                window = UIWindow(windowScene: windowScene)
        if let token = KeychainManager.getToken(service: "") {
            
            let mainViewController = BeerCatalogViewController()
            let navigationController = UINavigationController(rootViewController: mainViewController)
            mainViewController.title = "Beer Catalog"
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        } else {
            
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let startVC = vc.instantiateViewController(withIdentifier: "MainID") as! StartScreenViewController
            let navigationController = UINavigationController(rootViewController: startVC)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
    
}

