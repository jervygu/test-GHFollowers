//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import UIKit

class FollowerListVC: UIViewController {
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            switch result {
            case .success(let followers):
                
                print("Followers count = \(followers.count)")
                print("followers: \(followers)")
                
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Bad stuff", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
