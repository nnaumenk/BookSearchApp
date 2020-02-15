//
//  NavigationManager.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/8/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation
import UIKit

final class BookNavigationController: UINavigationController {
    
    func openBookListVC(model: BookListModel) {
        let vc = BookListViewController()
        vc.model = model
        
        self.pushViewController(vc, animated: true)
    }
    
    func openBookDetailsVC(imageURL: String, editionTitle: String, editionKey: String) {
        let vc = BookDetailsViewController()
        vc.imageURL = imageURL
        vc.editionTitle = editionTitle
        vc.editionKey = editionKey
        
        self.pushViewController(vc, animated: true)
    }
}

