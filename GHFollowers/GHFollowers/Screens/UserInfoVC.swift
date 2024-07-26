//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/22/24.
//

import UIKit


// MARK: - UserInfoVCDelegate
protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

// MARK: - GHFDataLoadingVC
class UserInfoVC: GHFDataLoadingVC {
    
    let scrollView          = UIScrollView()
    let contentView         = UIView()
    
    let headerView          = UIView()
    let itemViewOne         = UIView()
    let itemViewTwo         = UIView()
    let dateLabel           = GHFBodyLabel(textAlignment: .center)
    
    var itemViews: [UIView] = []
    
    var username: String!
    weak var delegate: UserInfoVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureScrollView()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    func getUserInfo() {
//        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let user):
//                DispatchQueue.main.async { self.configureUIElements(with: user) }
//            case .failure(let error):
//                presentGHFAlertOnMainThread(title: "Something went wrong!", message: error.rawValue, buttonTitle: "Ok")
//            }
//        }
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfoZZ(for: username)
                configureUIElements(with: user)
            } catch {
                if let error = error as? GHFError {
                    presentGHFAlert(title: "Something went wrong!", message: error.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
        }
    }
    
    func configureUIElements(with user: User) {
        self.add(childVC: GHFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: GHFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GHFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        self.dateLabel.text = "Github since \(user.createdAt.convertToMonthYearFormatNew())"
    }
    
    func layoutUI() {
        let padding: CGFloat        = 20
        let itemHeight: CGFloat     = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
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

// MARK: - GHFRepoItemVCDelegate
extension UserInfoVC: GHFRepoItemVCDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGHFAlert(title: "Invalid URL", message: "The user of the user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
}

// MARK: - GHFFollowerItemVCDelegate
extension UserInfoVC: GHFFollowerItemVCDelegate {
    
    func didTapGetFollowers(for user: User) {
        // dismiss VC
        // tell the follower list screen the new user
        guard user.followers != 0 else {
            presentGHFAlert(title: "No Followers", message: "This user has no followers, what a shame 😞.", buttonTitle: "So sad")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
}
