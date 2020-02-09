//
//  ImageViewExtension.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/9/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func imageFromURL(urlString: String, completionHandler: ((UIImage?) -> Void)? ) {
    
        self.image = nil
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        
        NetworkManager.shared.sendGETRequestResponseData(stringURL: urlString, successHandler: { data in
            
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
     
            let image = UIImage(data: data)
            self.image = image
            completionHandler?(image)
            
        }, failureHandler: { error in
            
            completionHandler?(nil)
        })
    }
}
