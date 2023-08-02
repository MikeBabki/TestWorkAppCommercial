//
//  BeerDescriptionViewController.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 14.06.2023.
//

import UIKit
import TinyConstraints
import Kingfisher

class BeerDescriptionViewController: UIViewController {
    
    var massiveIngridients =  [Ingredients()]
    var modelToConfigure = BeerModel()
    
    // MARK: - Private properties
    
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
    
    private lazy var beerImageMain: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "wineglass.fill")
        image.contentMode = .scaleAspectFit
        return image
        
    }()
    private lazy var beerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Beer name"
        label.numberOfLines = 0
        return label
        
    }()
    private lazy var beerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Beer description"
        label.numberOfLines = 0
        return label
        
    }()
    
    // MARK: - Ingridients info
    
    private lazy var ingridientsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Ingredients :"
        label.numberOfLines = 0
        return label
        
    }()
    
    private lazy var ingridientsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 40
        return view
        
    }()
    
    private lazy var maltView: MaltDescriptionView = {
        let view = MaltDescriptionView()
        
        return view as! MaltDescriptionView
        
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupText()
        setupUI()
  
    }
    override func viewDidLayoutSubviews() {
        view.frame.size.height = scrollView.bounds.height
        
    }
    
    // MARK: - Action's
    
    @objc func tapHandler(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("state ended")
        }
    }
    
    @objc func closeButtonTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func shareButton() {

        let beerName: String? = (modelToConfigure.name ?? "") + "\n" + (modelToConfigure.description ?? "")

        var imageForBeer: UIImage?
        if let imageURL = URL(string: modelToConfigure.image_url ?? ""),
            let imageData = try? Data(contentsOf: imageURL),
            let image = UIImage(data: imageData) {
            imageForBeer = image
        }
        
        let vc = UIActivityViewController(activityItems: [beerName, imageForBeer], applicationActivities: [])
        if let popoverController = vc.popoverPresentationController{
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
            
        }
        self.present (vc, animated: true, completion: nil)
    }
    
}

// MARK: - Extentions

extension BeerDescriptionViewController {
    func setupUI() {
        view.backgroundColor = .white
        let leftDismissButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        self.navigationItem.leftBarButtonItem = leftDismissButton
        
        let shareButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButton))
        self.navigationItem.rightBarButtonItem = shareButton
        
        navigationItem.title = ""
        navigationItem.backButtonTitle = ""
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.beerImageMain.addGestureRecognizer(tapGestureRecognizer)
        self.beerImageMain.isUserInteractionEnabled = true
        
        // MARK: - Constraints
        
        view.clipsToBounds = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(beerImageMain)
        contentView.addSubview(beerNameLabel)
        contentView.addSubview(beerDescriptionLabel)
        contentView.addSubview(ingridientsLabel)
        contentView.addSubview(ingridientsStackView)
       
        scrollView.edgesToSuperview()
        
        contentView.top(to: scrollView)
        contentView.bottom(to: scrollView)
        contentView.leading(to: scrollView)
        contentView.trailing(to: scrollView)
        
        contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: 0).isActive = true

        beerImageMain.top(to: contentView, offset: 64)
        beerImageMain.height(220)
        beerImageMain.width(220)
        beerImageMain.centerX(to: contentView)
        
        beerNameLabel.topToBottom(of: beerImageMain, offset: 32)
        beerNameLabel.leading(to: contentView, offset: 16)
        beerNameLabel.trailing(to: contentView, offset: -16)
        
        beerNameLabel.width(30)
        beerNameLabel.centerXToSuperview()
        
        beerDescriptionLabel.topToBottom(of: beerNameLabel,offset: 8)
        beerDescriptionLabel.centerXToSuperview()
        beerDescriptionLabel.leading(to: contentView, offset: 16)
        beerDescriptionLabel.trailing(to: contentView, offset: -16)
        
        ingridientsLabel.topToBottom(of: beerDescriptionLabel,offset: 16)
        ingridientsLabel.centerXToSuperview()
        
        ingridientsStackView.top(to: ingridientsLabel, offset: 42)
        ingridientsStackView.leading(to: contentView, offset: 16)
        ingridientsStackView.trailing(to: contentView, offset: -16)
        ingridientsStackView.bottom(to: contentView, offset: -24)
        ingridientsStackView.centerXToSuperview()
        
    }
}

extension BeerDescriptionViewController {
    func setupText() {
        beerNameLabel.text = modelToConfigure.name
        beerDescriptionLabel.text = modelToConfigure.description
        beerImageMain.kf.setImage(with: URL(string: modelToConfigure.image_url ?? ""))
        let array = modelToConfigure.ingredients?.malt ?? []
        for ingredient in array{
            let maltView = MaltDescriptionView()
            maltView.configure(withModel: ingredient)
            ingridientsStackView.addArrangedSubview(maltView)
        }
        
    }
}
