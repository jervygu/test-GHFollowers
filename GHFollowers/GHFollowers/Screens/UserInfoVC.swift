//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/22/24.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject { // class {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoVC: GHFDataLoadingVC {
    
    let headerView =            UIView()
    let itemViewOne =           UIView()
    let itemViewTwo =           UIView()
    let dateLabel =             GHFBodyLabel(textAlignment: .center)
    
    var itemViews: [UIView] =   []
    
    var username:       String!
    
    weak var followerListVCDelegate: FollowerListVCDelegate!
    
//    init(username: String) {
//        super.init(nibName: nil, bundle: nil)
//        self.username = username
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        if #available(iOS 15, *) {
            navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        }
        
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                presentGHFAlertOnMainThread(title: "Something went wrong!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUIElements(with user: User) {
        let repoItemVC = GHFRepoItemVC(user: user)
        repoItemVC.userInfoVCDelegate = self
        
        let followerItemVC = GHFFollowerItemVC(user: user)
        followerItemVC.userInfoVCDelegate = self
        
        self.add(childVC: GHFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "Github since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func layoutUI() {
        let padding: CGFloat =      20
        let itemHeight: CGFloat =   140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

}

extension UserInfoVC: UserInfoVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGHFAlertOnMainThread(title: "Invalid URL", message: "The user of the user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        // dismiss VC
        // tell the follower list screen the new user
        guard user.followers != 0 else {
            presentGHFAlertOnMainThread(title: "No Followers", message: "This user has no followers, what a shame 😞.", buttonTitle: "So sad")
            return
        }
        followerListVCDelegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
}
