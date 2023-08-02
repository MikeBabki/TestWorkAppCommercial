//
//  ProfileViewController.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 13.06.2023.
//

import UIKit
import TinyConstraints
import RealmSwift

class ProfileViewController: UIViewController {
    
    //MARK: - Private properties
    
    var tableViewCellEx = BeerTableViewCell()
    var testData = ["Beer1": "Description1", "Beer2": "Description2", "Beer3": "Description3", "Beer4": "Description4","Beer5": "Description5","Beer6": "Description6"]
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    private lazy var favouriteBeerTitle: UILabel = {
        let label = UILabel()
        label.text = "Favourite Beer"
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .light)
        return label
    }()
    
    private lazy var favouriteBeerTableview: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.separatorStyle = .none

        return tableView
    }()
    
    //MARK: - LifeCycle - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
     func someHandler(alert: UIAlertAction!) {
         KeychainManager.deleteToken(service: "")
         KeychainManager.deleteEmail()
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let fullScreenViewController = storyboard.instantiateViewController(withIdentifier: "MainID") as! StartScreenViewController
         fullScreenViewController.navigationItem.setHidesBackButton(true, animated: true)
         
         navigationController?.pushViewController(fullScreenViewController, animated: true)
    }
    //MARK: - Actions
    
    @objc func myAccount() {
        
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: someHandler))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func closeButtonTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
        
    }
}

        //MARK: - Extention (SetupUI)

extension ProfileViewController {
    func setupUI() {
        
        //MARK: - Setup NavigationView
        
        view.backgroundColor = .white
        navigationItem.title = KeychainManager.getEmail()
        let leftDismissButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        self.navigationItem.leftBarButtonItem = leftDismissButton
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.square"), style: UIBarButtonItem.Style.done, target: self, action: #selector(myAccount))
        self.navigationItem.rightBarButtonItem = rightButton
        
        //MARK: - Addsubview, constraints
        
        favouriteBeerTableview.dataSource = self
        favouriteBeerTableview.delegate = self
        view.addSubview(favouriteBeerTableview)
        
        favouriteBeerTableview.edgesToSuperview()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomBeerCell", for: indexPath) as! ProfileTableViewCell
                
                let beerName = Array(testData.keys)[indexPath.row]
                let beerDescription = Array(testData.values)[indexPath.row]
                
        cell.beerNameLabel = tableViewCellEx.beerNameLabel
        cell.beerDescriptionLabel = tableViewCellEx.beerDescriptionLabel
        
//                cell.beerNameLabel.text = beerName
//                cell.beerDescriptionLabel.text = beerDescription
                cell.selectionStyle = .none
                return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 10, width: tableView.frame.width, height: 50))
        
        headerView.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: -10, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Favourite Beer"
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .black
        
        headerView.addSubview(label)
        
        return headerView
    }
}
