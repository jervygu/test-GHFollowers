//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import UIKit

class FollowerListVC: UIViewController {
    
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
    var filteredFollowers: [Follower] = []
    
    var page: Int = 1
    var hasMoreFollowers: Bool = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSearchController()
        configureViewController()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.identifier)
        
        print("FollowerCollectionViewCell.reuseId: \(FollowerCollectionViewCell.reuseId)")
        print("FollowerCollectionViewCell.identifier: \(FollowerCollectionViewCell.identifier)")
        print("FollowerCollectionViewCell.reuseIdentifier: \(FollowerCollectionViewCell.reuseIdentifier)")
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater =                     self
        searchController.searchBar.delegate =                       self
        searchController.searchBar.placeholder =                    "Search a username"
        searchController.obscuresBackgroundDuringPresentation =     false
        navigationItem.searchController =                           searchController
        // navigationItem.hidesSearchBarWhenScrolling =                false
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()	
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                // check if less than 100, it means theres no more followers to load
                if followers.count < NetworkManager.shared.perPage { self.hasMoreFollowers = false }
                
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty {
                    let message = "This user doesnt have any followers. Go follow them 😀."
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                
                DispatchQueue.main.async {
                    self.updateData(on: self.followers)
                    self.updateSearchResults(for: self.searchController)
                }
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Bad stuff", message: error.rawValue, buttonTitle: "Ok")
            }
            print("CFGetRetainCount: \(CFGetRetainCount(self))")
        }
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
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
        
    }
    	
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let follower = (isSearching ? filteredFollowers : followers)[indexPath.item]
        guard let follower = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let destinationVC = UserInfoVC()
        destinationVC.username = follower.login
        let navVC = UINavigationController(rootViewController: destinationVC)
        navVC.sheetPresentationController?.prefersGrabberVisible = true
        present(navVC, animated: true)
    }
    
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate
extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
//        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
//            updateData(on: followers)
//            return
//        }
//        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
//        updateData(on: filteredFollowers)
        
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            updateData(on: followers)
            return
        }
        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter) })
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: followers)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        updateData(on: followers)
    }
}
