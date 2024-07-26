//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import UIKit

class FollowerListVC: GHFDataLoadingVC {
    
    enum Section {
        case main
    }
    
    var username: String!
    var followers: [Follower] = []
//    private var followers: [Follower] = [] {
//        didSet {
//            guard followers.isEmpty else { return }
//            DispatchQueue.main.async {
//                self.showEmptyStateView(with: "This user doesnt have any followers. Go follow them 😀.", in: self.view)
//            }
//        }
//    }
    var filteredFollowers: [Follower]   = []
    
    var page: Int                       = 1
    var hasMoreFollowers: Bool          = true
    var isSearching                     = false
    var isLoadingMoreFollowers          = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    let searchController                = UISearchController()
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        super.updateContentUnavailableConfiguration(using: state)
        if followers.isEmpty && !isLoadingMoreFollowers {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "person.slash")
            config.text = "No followers"
            config.secondaryText = "This user has no followers, go follow them."
            contentUnavailableConfiguration = config
        } else if isSearching && filteredFollowers.isEmpty {
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .done, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.identifier)
        
        print("FollowerCollectionViewCell.reuseId:          \(FollowerCollectionViewCell.reuseId)")
        print("FollowerCollectionViewCell.identifier:       \(FollowerCollectionViewCell.identifier)")
        print("FollowerCollectionViewCell.reuseIdentifier:  \(FollowerCollectionViewCell.reuseIdentifier)")
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.placeholder                  = "Search a username"
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.searchController                         = searchController
        // navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()	
        isLoadingMoreFollowers = true
        
//        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
//            guard let self = self else { return }
//            self.dismissLoadingView()
//            
//            switch result {
//            case .success(let followers):
//                // check if less than 100, it means theres no more followers to load
//                if followers.count < NetworkManager.shared.perPage { self.hasMoreFollowers = false }
//                
//                self.followers.append(contentsOf: followers)
//                
//                if self.followers.isEmpty {
//                    let message = "This user doesnt have any followers. Go follow them 😀."
//                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
//                    return
//                }
//                
//                DispatchQueue.main.async {
//                    self.updateData(on: self.followers)
//                    self.updateSearchResults(for: self.searchController)
//                }
//            case .failure(let error):
//                self.presentGHFAlertOnMainThread(title: "Bad stuff", message: error.rawValue, buttonTitle: "Ok")
//            }
//            self.isLoadingMoreFollowers = false
//            print("CFGetRetainCount: \(CFGetRetainCount(self))")
//        }
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowersZZ(for: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
                isLoadingMoreFollowers = false
            } catch {
                if let error = error as? GHFError {
                    presentGHFAlert(title: "Bad stuff", message: error.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
                isLoadingMoreFollowers = false
            }
            print("CFGetRetainCount: \(CFGetRetainCount(self))")
        }
    }
    
    func updateUI(with followers: [Follower]) {
        // check if less than 100, it means theres no more followers to load
        if followers.count < NetworkManager.shared.perPage { self.hasMoreFollowers = false }
        
        self.followers.append(contentsOf: followers)
        
//        if self.followers.isEmpty {
//            let message = "This user doesnt have any followers. Go follow them 😀."
//            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
//            return
//        }
        
        updateData(on: self.followers)
        updateSearchResults(for: searchController)
        
        setNeedsUpdateContentUnavailableConfiguration()
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCollectionViewCell.identifier, for: indexPath) as? FollowerCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.set(follower: item)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func favoriteButtonTapped() {
        showLoadingView()
//        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
//            guard let self = self else { return }
//            self.dismissLoadingView()
//            
//            switch result {
//            case .success(let user):
//                self.addUserToFavorites(user: user)
//            case .failure(let error):
//                self.presentGHFAlertOnMainThread(title: "Something went wrong.", message: error.rawValue, buttonTitle: "Ok")
//            }
//        }
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfoZZ(for: username)
                addUserToFavorites(user: user)
                dismissLoadingView()
            } catch {
                if let error = error as? GHFError {
                    presentGHFAlert(title: "Something went wrong.", message: error.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
            }
        }
    }
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenseManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentGHFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user. 👊🏿", buttonTitle: "Hooray!")
                return
            }
            self.presentGHFAlertOnMainThread(title: "Something went wrong.", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY =           scrollView.contentOffset.y
        let contentHeight =     scrollView.contentSize.height
        let height =            scrollView.frame.size.height
        
        print("offsetY:         \(offsetY)")
        print("contentHeight:   \(contentHeight)")
        print("height:          \(height)")
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers, !isSearching else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
        
    }
    	
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let follower = (isSearching ? filteredFollowers : followers)[indexPath.item]
        guard let follower = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let destinationVC = UserInfoVC()
        destinationVC.username = follower.login
        destinationVC.delegate = self
        let navVC = UINavigationController(rootViewController: destinationVC)
        navVC.sheetPresentationController?.prefersGrabberVisible = true
        present(navVC, animated: true)
    }
    
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate
extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter) })
        updateData(on: filteredFollowers)
        setNeedsUpdateContentUnavailableConfiguration()
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        isSearching = false
//        updateData(on: followers)
//    }
}


// MARK: - FollowerListVCDelegate
extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username   = username
        title           = username
        page            = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        navigationItem.searchController?.searchBar.text = nil
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
