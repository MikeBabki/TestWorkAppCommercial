//
//  LoginViewController.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 05.06.2023.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var visualBlur: UIVisualEffectView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    private var networkInstanse = NetworkManager()
    
    // MARK: - LifeCycle - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupText()
        setupUI()
    }
    //while repeat while
    
    // MARK: - Action
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let mbProgHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        guard let login = loginTextField.text,
              let password = passwordTextField.text
        else { return }
        
        networkInstanse.loginApiCall(email: login, password: password) { (searchResponse) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self
                else { return }
                mbProgHud.hide(animated: true)
                switch searchResponse {

                    case.success(_):
                        let beerCatalogVC = BeerCatalogViewController()
                        guard let navigationController = self.navigationController
                        else { return }
                        var navigationArray: [UIViewController] = [beerCatalogVC]
                        navigationController.setViewControllers(navigationArray, animated: true)

                    case.failure(let error):
//                        setupErrorAlert(error: error as NSError, controller: UIViewController)
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true)


                }
            }
        }
    }
}

// MARK: - Extentions (setupText, setupUI)

extension LoginViewController {
    func setupText() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = "BeerLoga"
    }
}

extension LoginViewController {
    func setupUI() {
        loginView.layer.masksToBounds = true
        loginView.layer.shadowOffset = CGSize(width: 10,
                                          height: 10)
        loginView.layer.shadowRadius = 5
        loginView.layer.shadowOpacity = 0.3
        loginView.layer.cornerRadius = 16
        passwordTextField.isSecureTextEntry = true
    }
}

public func setupErrorAlert(error: NSError, controller: UIViewController) {
    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default))
    controller.present(alert, animated: true)
}

//
var massiveArray = ["a", "b", "c"]
//
//for i in massiveArray {
//    print(i)
//}
//
//func forEach(body: (String) -> Void) -> Void
//{
//    for i in massiveArray {
//        body(i)
//    }
//}
//
//massiveArray.forEach({ i in
//    print(i)
//})
//
//massiveArray.forEach({ i in
//    print(i, i)
//})
//for i in 0..<massiveArray.count {
//    print(i)
//}
