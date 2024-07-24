//
//  UITableView+Extension.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/24/24.
//

import UIKit


extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
}
