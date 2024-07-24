//
//  GHFItemInfoView.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/22/24.
//

import UIKit


enum ItemInfoType {
    case repos, gists, followers, following
}

class GHFItemInfoView: UIView {

    let symbolImageView = UIImageView()
    let titleLabel = GHFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GHFTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(symbolImageView, titleLabel, countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func set(itemInfoType: ItemInfoType, with count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image =     SFSymbolsImage.repos
            titleLabel.text =           "Public Repos"
        case .gists:
            symbolImageView.image =     SFSymbolsImage.gists
            titleLabel.text =           "Public Gists"
            
        case .followers:
            symbolImageView.image =     SFSymbolsImage.followers
            titleLabel.text =           "Followers"
        case .following:
            symbolImageView.image =     SFSymbolsImage.following
            titleLabel.text =           "Following"
        }
        countLabel.text =               String(count)
    }
    
    
}
