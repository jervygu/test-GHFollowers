//
//  UIView+Extension.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/22/24.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
