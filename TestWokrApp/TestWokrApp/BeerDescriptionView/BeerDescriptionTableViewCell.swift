//
//  BeerDescriptionTableViewCell.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 20.06.2023.
//

import UIKit
import TinyConstraints

class BeerDescriptionTableViewCell: UITableViewCell {
    
    static let identifier = "BeerDescriptionTableViewCell"
    var model: Malt?
    var massiveIngridients = [Malt]()
    
    lazy var ingridientName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var ingridientVolume: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupUI()
        self.allowText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withModel model: Malt?) {
    
    self.model = model
        ingridientName.text = model?.name ?? "Name MALT"
        ingridientVolume.text = "\(model?.amount)" ?? "VOLUME MALT"
        
}
    
    private func setupUI() {
        
        contentView.addSubview(ingridientName)
        contentView.addSubview(ingridientVolume)
    
        // MARK: - Constraint's
        
        ingridientName.leading(to: contentView, offset: 8)
        ingridientName.centerYAnchor
        ingridientVolume.trailing(to: contentView, offset: -8)
        ingridientVolume.centerYAnchor

    }
    private func allowText() {
        
        let model = massiveIngridients
        
        ingridientName.text = model[0].name ?? "Opa"
        ingridientVolume.text = "\(model[0].amount?[0].value)" ?? "dsadsd"
    }
}

  
