//
//  BookListModel.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/15/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class BookListModel {
    
    var bookListModelArray: [OLBookListModel]! {
        didSet {
            self.bookImageArray = Array(repeating: (false, nil), count: bookListModelArray.count)
            self.bookDescriptionArray = Array(repeating: (false, nil), count: bookListModelArray.count)
        }
    }
    var searchQuery: String!
    var maxItemsNumber: Int!
    var bookImageArray: [(isDownloading: Bool, image: UIImage?)]!
    var bookDescriptionArray: [(isDownloading: Bool, text: String?)]!
    
    private var page = 1
    
    func loadMore(failureHandler: (() -> Void)?, successHandler: (() -> Void)?) {
        if bookListModelArray.count == maxItemsNumber { return }
        
        let stringURL = Constants.main.API_URL + "/search.json?page=\(page)&q=\(searchQuery.replacingOccurrences(of: " ", with: "+"))"
        
        NetworkManager.shared.sendGETRequestResponseModel(stringURL: stringURL, successHandler: { (model: OLSearchPaginationModel) in
                
            self.page += 1
            
            self.bookListModelArray += model.docs
            self.bookImageArray += Array(repeating: (false, nil), count: model.docs.count)
            self.bookDescriptionArray += Array(repeating: (false, nil), count: model.docs.count)
                
            successHandler?()
                
        }, failureHandler: { error in
                
            failureHandler?()
        })
    }
}
