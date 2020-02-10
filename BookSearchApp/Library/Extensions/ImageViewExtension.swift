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
        self.startActivityIndicator()
        
        NetworkManager.shared.sendGETRequestResponseData(stringURL: urlString, successHandler: { data in
            
            self.stopActivityIndicator()
     
            let image = UIImage(data: data)
            self.image = image
            completionHandler?(image)
            
        }, failureHandler: { error in
            
            completionHandler?(nil)
        })
    }
}
