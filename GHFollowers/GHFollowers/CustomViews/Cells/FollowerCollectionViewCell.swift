//
//  FollowerCollectionViewCell.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import UIKit
import SwiftUI

class FollowerCollectionViewCell: UICollectionViewCell {
    
    // Different ways of declaration for reusable identifier
    static let reuseId          = "FollowerCollectionViewCell"
    static let identifier       = String(describing: FollowerCollectionViewCell.self)
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    let avatarImageView         = GHFAvatarImageView(frame: .zero)
    let usernameLabel           = GHFTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower) {
        if #available(iOS 16.0, *) {
            contentConfiguration = UIHostingConfiguration { FollowerView(follower: follower) }
        } else {
            
            usernameLabel.text = follower.login
            //        NetworkManager.shared.downloadImage(from: follower.avatarUrl) { [weak self] image in
            //            guard let self = self else { return }
            //            DispatchQueue.main.async {
            //                self.avatarImageView.image = image
            //            }
            //        }
            Task {
                avatarImageView.image = await NetworkManager.shared.downloadImageZZ(from: follower.avatarUrl) ?? nil
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        avatarImageView.image = GHFAvatarImageView.placeholderImage
    }
    
    private func configure() {
        contentView.addSubviews(avatarImageView, usernameLabel)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
