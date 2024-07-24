//
//  UIView+Extension.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/22/24.
//

import UIKit

extension UIView {
    // UIView... - variadic parameters
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
