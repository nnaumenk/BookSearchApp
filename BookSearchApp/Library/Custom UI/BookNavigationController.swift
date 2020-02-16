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
        vc.myModel = model
        
        self.pushViewController(vc, animated: true)
    }
    
    func openBookDetailsVC(model: BookDetailsModel) {
        let vc = BookDetailsViewController()
        vc.myModel = model
        
        self.pushViewController(vc, animated: true)
    }
}

