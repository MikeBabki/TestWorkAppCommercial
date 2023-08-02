//
//  ViewController.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 04.06.2023.
//

import UIKit

class StartScreenViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var asGuestButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    // MARK: - LifeCycle - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
    }
    // MARK: - LifeCycle - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    // MARK: - Actions
    
    @IBAction func asGuestModeButtonTapped(_ sender: Any) {
        
        let beerCatalogVC = BeerCatalogViewController()
        self.navigationController?.pushViewController(beerCatalogVC, animated: true)
        beerCatalogVC.title = "BeerLoga"
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let registerVC = RegistrationViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
        registerVC.title = "BeerLoga"
    }
}

    // MARK: - Extention (setupUI)

extension StartScreenViewController {
    func setupUI() {

    
        view.backgroundColor = .white
        buttonsView.layer.masksToBounds = true
        buttonsView.layer.shadowOffset = CGSize(width: 10,
                                          height: 10)
        buttonsView.layer.shadowRadius = 5
        buttonsView.layer.shadowOpacity = 0.3
        buttonsView.layer.cornerRadius = 16
    }
}
