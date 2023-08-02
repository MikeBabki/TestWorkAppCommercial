//
//  MaltDescriptionView.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 21.06.2023.
//

import UIKit
import TinyConstraints

class MaltDescriptionView: UIView {
    
    var model: Malt?

    private lazy var contentView: UIView = {
        let view = UIView()
       
        return view
    }()
    
    private lazy var ingridientName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private lazy var ingridientVolume: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        
        return label
    }()
    private lazy var ingridientUnit: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)
        
        return label
    }()

    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupUI()
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withModel model: Malt?) {
        self.model = model
        print(model)
        
        if let maltNames = model?.name {
            ingridientName.text = maltNames
        }
        print(ingridientName.text)
        

        if let maltVolumes = model?.amount?.value {
            ingridientVolume.text = "\(maltVolumes)"
        }
        print(ingridientVolume.text)
        
        if let maltUnit = model?.amount?.unit {
            ingridientUnit.text = "\(maltUnit)"
        }
    }
}


extension MaltDescriptionView {
    func setupUI() {
        
        addSubview(contentView)
        contentView.addSubview(ingridientName)
        contentView.addSubview(ingridientVolume)
        contentView.addSubview(ingridientUnit)
        
        contentView.edgesToSuperview()
        contentView.centerXAnchor
        contentView.width(contentView.frame.width)
        
        ingridientName.leading(to: contentView, offset: 16)
        ingridientName.trailingToLeading(of: ingridientVolume, offset: -8)
        
        ingridientVolume.centerXToSuperview()
        
        ingridientUnit.trailing(to: contentView, offset: -16)

        ingridientName.centerYToSuperview()
        ingridientVolume.centerYToSuperview()
        ingridientUnit.centerYToSuperview()
    }
}

