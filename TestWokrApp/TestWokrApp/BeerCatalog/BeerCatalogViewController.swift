//
//  BeerCatalogViewController.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 08.06.2023.
//

import UIKit
import MBProgressHUD
import TinyConstraints
import SwiftyJSON


class BeerCatalogViewController: UIViewController {

    // MARK: - Private properties
    
    private var beerModel = [BeerModel]()
    
    var pageNumber = 1
    var totalBeerCount = 80

    private var networkManagerInstance = NetworkManager()
    
    private lazy var beerTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: BeerTableViewCell.identifier)
        return tableView
        
    }()
    
    private lazy var loadErrorView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        return view
        
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "Error"
        return label
    }()
    
    private lazy var errorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Error load description"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .light)

        return label
    }()
    
    private lazy var retryConnectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(retryConnection), for: .touchUpInside)
        return button
    }()
    // MARK: - LifeCycle - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.topItem?.backButtonTitle = " "
    }
   
    // MARK: - LifeCycle - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBeer()
        setupUI()
    }
    
    // MARK: -  Action's
    
    @objc func loadBeer() {
        
        loadErrorView.isHidden = true
        MBProgressHUD.showAdded(to: self.view, animated: true)
        beerTableView.isHidden = true
        networkManagerInstance.getResult(page: self.pageNumber, totalCount: self.totalBeerCount) { (searchResponse) in
            switch searchResponse {
            case.success(let data):
                DispatchQueue.main.async {
                    data?.forEach {

                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.beerTableView.isHidden = false
                        self.beerModel.append($0)
                        
                    }
                    self.beerTableView.reloadData()
                }
                    
            case .failure(let error):
                DispatchQueue.main.async {
                    self.beerTableView.isHidden = true
                    self.loadErrorView.isHidden = false
                    self.errorDescriptionLabel.text = error.localizedDescription ?? "Error"
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    
    @objc func myAccount() {
        
        if KeychainManager.getToken(service: "") != nil {
            
            let profileVC = ProfileViewController()
            let navController = UINavigationController(rootViewController: profileVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        } else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let fullScreenViewController = storyboard.instantiateViewController(withIdentifier: "MainID") as! StartScreenViewController
            navigationController?.pushViewController(fullScreenViewController, animated: true)
            
        }
    }
    @objc func retryConnection(sender : UIButton) {
        MBProgressHUD.hide(for: self.view, animated: true)
        loadBeer()
    }

}


// MARK: - Extention's

extension BeerCatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        beerModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerTableViewCell.identifier, for: indexPath) as? BeerTableViewCell else {
            fatalError("TableView could not deque CustomCell in ViewController")
        }
        let model = beerModel[indexPath.row]
        cell.configure(withModel: model)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let descriptionVC = BeerDescriptionViewController()
        let model = beerModel[indexPath.row]
        descriptionVC.modelToConfigure = model
        
        let navController = UINavigationController(rootViewController: descriptionVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }

extension BeerCatalogViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: UIBarButtonItem.Style.done, target: self, action: #selector(myAccount))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.setHidesBackButton(true, animated:true)
     
        // MARK: - Constraint (tableView)
        
        view.addSubview(beerTableView)
        
        view.addSubview(loadErrorView)
        loadErrorView.addSubview(errorLabel)
        loadErrorView.addSubview(errorDescriptionLabel)
        loadErrorView.addSubview(retryConnectionButton)
        
        beerTableView.edgesToSuperview()
        
        //Error View
        
        loadErrorView.left(to: view, offset: 64)
        loadErrorView.right(to: view, offset: -64)
        loadErrorView.centerY(to: view)
        
        errorLabel.top(to: loadErrorView, offset: 16)
        errorLabel.centerX(to: loadErrorView)
        
        errorDescriptionLabel.top(to: errorLabel, offset: 32)
        errorDescriptionLabel.leading(to: loadErrorView, offset: 16)
        errorDescriptionLabel.trailing(to: loadErrorView, offset: -16)
        errorDescriptionLabel.centerX(to: loadErrorView)
        
        retryConnectionButton.topToBottom(of: errorDescriptionLabel, offset: 16)
        retryConnectionButton.bottom(to: loadErrorView, offset: -16)
        retryConnectionButton.centerX(to: loadErrorView)
        retryConnectionButton.width(70)
        
    }
}
