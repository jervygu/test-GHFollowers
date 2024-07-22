//
//  GHFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/22/24.
//

import Foundation

class GHFFollowerItemVC: GHFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
}
