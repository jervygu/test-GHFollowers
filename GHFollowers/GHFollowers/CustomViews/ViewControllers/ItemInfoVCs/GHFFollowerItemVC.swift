//
//  GHFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/22/24.
//

import Foundation

protocol GHFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class GHFFollowerItemVC: GHFItemInfoVC {
    
    weak var delegate: GHFFollowerItemVCDelegate!
    
    init(user: User, delegate: GHFFollowerItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
    
}
