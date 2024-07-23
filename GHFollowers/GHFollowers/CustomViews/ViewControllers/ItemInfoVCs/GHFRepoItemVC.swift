//
//  GHFRepoItemVC.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/22/24.
//

import UIKit

class GHFRepoItemVC: GHFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, with: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
    
    override func actionButtonTapped() {
        userInfoVCDelegate.didTapGitHubProfile(for: user)
    }
    
}
