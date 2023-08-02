//
//  ProfileTableViewCell.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 23.06.2023.
//

import UIKit
import TinyConstraints

class ProfileTableViewCell: UITableViewCell {

    
    static let identifier = "CustomBeerCell"
    
    private lazy var beerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var beerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var beerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var favouriteIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.addTarget(self, action: #selector(addFavourite), for: .touchUpInside)
        return button
    }()
    
    @objc func addFavourite(sender : UIButton) {
        
        if favouriteIcon.currentImage == UIImage(systemName: "star") {
            addFavour()
         } else {
             deleteFavour()
         }
     }
    
    @objc func addFavour() {
            favouriteIcon.setImage(UIImage(systemName: "star.fill"), for: .normal)
        print("add favoured")
    }
    
    @objc func deleteFavour() {
            favouriteIcon.setImage(UIImage(systemName: "star"), for: .normal)
        print("delete favoured")
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

        self.contentView.addSubview(beerImage)
        self.contentView.addSubview(beerNameLabel)
        self.contentView.addSubview(beerDescriptionLabel)
        self.contentView.addSubview(favouriteIcon)
        
        // MARK: - Constraint's
        
        beerImage.leading(to: contentView.layoutMarginsGuide)
        beerImage.top(to: contentView, offset: 16)
        beerImage.bottom(to: contentView,offset: -16, relation: .equalOrLess)

        beerNameLabel.leadingToTrailing(of: beerImage, offset: 16)
        beerNameLabel.trailingToLeading(of: favouriteIcon, offset: -8)
        beerNameLabel.top(to: contentView, offset: 16)
        
        beerDescriptionLabel.leadingToTrailing(of: beerImage, offset: 16)
        beerDescriptionLabel.topToBottom(of: beerNameLabel, offset: 8)
        beerDescriptionLabel.trailingToLeading(of: favouriteIcon, offset: -8)
        beerDescriptionLabel.bottom(to: contentView, offset: -16, relation: .equalOrLess)
        
        beerImage.height(80)
        beerImage.aspectRatio(1)
        
        favouriteIcon.leadingToTrailing(of: contentView, offset: -36)
        favouriteIcon.centerY(to: contentView)

    }
}
