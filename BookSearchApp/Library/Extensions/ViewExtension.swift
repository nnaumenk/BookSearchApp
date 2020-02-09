//
//  ViewExtension.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/9/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func startActivityIndicator() {
        if ((self.subviews.first(where: { $0.accessibilityIdentifier == "activityIndicator" }) as? UIActivityIndicatorView) != nil) { return }
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.accessibilityIdentifier = "activityIndicator"
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        guard let activityIndicator = self.subviews.first(where: { $0.accessibilityIdentifier == "activityIndicator" }) as? UIActivityIndicatorView else { return }
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    
}
