//
//  FavoriteTableViewCell.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/23/24.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    // Different ways of declaring reusable identifier
    static let reuseId              = "FavoriteCell"
    static let identifier           = String(describing: FollowerCollectionViewCell.self)
    static var reuseIdentifier: String { String(describing: self) }
    
    private let avatarImageView     = GHFAvatarImageView(frame: .zero)
    private let usernameLabel       = GHFTitleLabel(textAlignment: .left, fontSize: 26)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favorite: Follower) {
        avatarImageView.downloadAvatarImage(fromUrl: favorite.avatarUrl)
        usernameLabel.text = favorite.login
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = GHFAvatarImageView.placeholderImage
        usernameLabel.text = nil
    }
    
    private func configure() {
        contentView.addSubviews(avatarImageView, usernameLabel)
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
