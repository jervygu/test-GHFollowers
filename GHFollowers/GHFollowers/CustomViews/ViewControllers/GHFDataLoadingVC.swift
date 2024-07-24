//
//  GHFDataLoadingVC.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/24/24.
//

import UIKit

class GHFDataLoadingVC: UIViewController {
    
    var containerView: UIView!
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemGreen
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        #warning("Try modify later")
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
            
//            UIView.animate(withDuration: 0.25) {
//                containerView.alpha = 0
//            } completion: { _ in
//                containerView.removeFromSuperview()
//                containerView = nil
//            }
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GHFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }

}
