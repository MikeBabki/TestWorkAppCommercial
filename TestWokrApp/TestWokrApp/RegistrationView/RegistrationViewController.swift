//
//  RegistrationViewController.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 06.06.2023.
//

import UIKit
import TinyConstraints
import MBProgressHUD

class RegistrationViewController: UIViewController {
    
    
    private var networkInstanse = NetworkManager()
    
    // MARK: - Private properties
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainImage")
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.55
        return imageView
    }()
    
    // MARK: - Scroll View propertie
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        return scrollView
    }()
    
    // MARK: - Registration View properties
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    private lazy var registrationView: UIView = {
        let registrationView = UIView()
        registrationView.backgroundColor = .clear
        return registrationView
    }()
    
    private lazy var loginRegisterLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .systemFont(ofSize: 25, weight: .regular)
        return label
    }()
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = .systemFont(ofSize: 25, weight: .regular)
        return label
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(firstPasswordTextField), for: .editingChanged)
        return textField
    }()

    private lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm password"
        label.font = .systemFont(ofSize: 25, weight: .regular)
        return label
    }()
    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(secondConfirmPasswordTextfield(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGray3
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.isEnabled = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var passwordValidationView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.borderWidth = 0.7
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var confirmPasswordValidationView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.7
        view.layer.cornerRadius = 5
        return view
    }()
    
    // MARK: - LifeCycle ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSetup()
        setupText()
    }
    
    // MARK: - Action's (Button and TextFields)
    
    @objc func buttonTapped(sender : UIButton) {
        
        let mbProgHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        guard let email = loginTextField.text, let password = confirmPasswordTextField.text else { return }
        networkInstanse.registerApiCall(name: email, email: email, password: password) { (searchResponse) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self
                else { return }
                
                switch searchResponse {
        
                    case.success(_):
                    mbProgHud.hide(animated: true)
                    let beerCatalogVC = BeerCatalogViewController()
                    guard let navigationController = self.navigationController
                    else { return }
                    
                    var navigationArray: [UIViewController] = [beerCatalogVC]
                    navigationController.setViewControllers(navigationArray, animated: true)
                        
                        KeychainManager.saveEmail(email: email)
                    
                case.failure(let error):
//                        setupErrorAlert()
                    mbProgHud.hide(animated: true)
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc func firstPasswordTextField() {
        
        if validation() {
            passwordValidationView.isHidden = false
            confirmPasswordValidationView.isHidden = !sameTextFields()
        } else {
            passwordValidationView.isHidden = true
        }
    }
    
    @objc func secondConfirmPasswordTextfield(_ textField: UITextField) {
        if validation() {
            if sameTextFields() {
                confirmPasswordValidationView.isHidden = !sameTextFields()
                registerButton.isEnabled = true
            } else {
                confirmPasswordValidationView.isHidden = true
            }
        }
    }
    // MARK: - Private methods
    
    private func initializeSetup() {
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    func validation() -> Bool {
        passwordTextField.text!.count >= 8 && ((passwordTextField.text?.rangeOfCharacter(from: CharacterSet.decimalDigits)) != nil)
    }
    func sameTextFields() -> Bool {
        confirmPasswordTextField.text == passwordTextField.text
    }
}

// MARK: - Extention for text validation

extension RegistrationViewController: UITextFieldDelegate {
    
}

// MARK: - Extention - AddSubView's - Constraints

extension RegistrationViewController {
    
        func setupText() {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            view.clipsToBounds = true

            passwordValidationView.isHidden = true
            confirmPasswordValidationView.isHidden = true
            
            view.backgroundColor = .white
            view.addSubview(backgroundImage)
            view.addSubview(scrollView)
            
            scrollView.addSubview(contentView)
            contentView.addSubview(registrationView)
            
            registrationView.addSubview(loginRegisterLabel)
            registrationView.addSubview(loginTextField)
            registrationView.addSubview(passwordLabel)
            registrationView.addSubview(passwordTextField)
            registrationView.addSubview(confirmPasswordLabel)
            registrationView.addSubview(confirmPasswordTextField)
            registrationView.addSubview(registerButton)
            registrationView.addSubview(passwordValidationView)
            registrationView.addSubview(confirmPasswordValidationView)
   
            backgroundImage.edgesToSuperview()
            scrollView.edgesToSuperview()
            
            contentView.verticalToSuperview()
            contentView.centerInSuperview()
            contentView.widthToSuperview()
            contentView.heightToSuperview()

            registrationView.centerInSuperview()
            registrationView.width(250)
            registrationView.height(400)
            
            loginRegisterLabel.top(to: registrationView, offset: 16)
            loginRegisterLabel.centerX(to: registrationView)
            
            loginTextField.topToBottom(of: loginRegisterLabel, offset: 8)
            loginTextField.leading(to: registrationView, offset: 8)
            loginTextField.trailing(to: registrationView, offset: -8)
            loginTextField.height(34)

            passwordLabel.topToBottom(of: loginTextField, offset: 40)
            passwordLabel.centerX(to: registrationView)
            
            passwordTextField.topToBottom(of: passwordLabel, offset: 8)
            passwordTextField.leading(to: registrationView, offset: 8)
            passwordTextField.trailing(to: registrationView, offset: -8)
            passwordTextField.height(34)
            
            confirmPasswordLabel.topToBottom(of: passwordTextField, offset: 40)
            confirmPasswordLabel.centerX(to: registrationView)
            
            confirmPasswordTextField.topToBottom(of: confirmPasswordLabel, offset: 8)
            confirmPasswordTextField.leading(to: registrationView, offset: 8)
            confirmPasswordTextField.trailing(to: registrationView, offset: -8)
            confirmPasswordTextField.height(34)
            
            registerButton.topToBottom(of: confirmPasswordTextField, offset: 40)
            registerButton.centerX(to: registrationView)
            registerButton.width(100)
            
            passwordValidationView.leadingToTrailing(of: passwordTextField, offset: 16)
            passwordValidationView.centerY(to: passwordTextField)
            passwordValidationView.width(10)
            passwordValidationView.height(10)
            
            confirmPasswordValidationView.leadingToTrailing(of: confirmPasswordTextField, offset: 16)
            confirmPasswordValidationView.centerY(to: confirmPasswordTextField)
            confirmPasswordValidationView.width(10)
            confirmPasswordValidationView.height(10)
    }
}

