//
//  BookListModel.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/15/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

final class BookListModel {
    
    private var page = 1
    
    private(set) var searchQuery: String
    private(set) var bookListModelArray: [OLBookListModel]
    private(set) var maxItemsNumber: Int
    
    var bookImageArray: [(isDownloading: Bool, image: UIImage?)]!
    var bookDescriptionArray: [(isDownloading: Bool, text: String?)]!
    
    
    init(searchQuery: String, bookListModelArray: [OLBookListModel], maxItemsNumber: Int) {
        self.searchQuery = searchQuery
        self.bookListModelArray = bookListModelArray
        self.maxItemsNumber = maxItemsNumber
        
        self.bookImageArray = Array(repeating: (false, nil), count: bookListModelArray.count)
        self.bookDescriptionArray = Array(repeating: (false, nil), count: bookListModelArray.count)
    }
    
    func getImageForCellFromURL(cellIndex: Int, urlString: String, completionHandler: @escaping (() -> Void) ) {
        
        self.bookImageArray[cellIndex].isDownloading = true
        
        NetworkManager.shared.sendGETRequestResponseData(stringURL: urlString, successHandler: { [weak self] data in
            
            guard let self = self else { return }
            
            let image = UIImage(data: data)
            
            self.bookImageArray[safe: cellIndex]?.isDownloading = false
            self.bookImageArray[safe: cellIndex]?.image = image ?? UIImage(named: "no_book_cover")
            
            completionHandler()
                
        }, failureHandler: { error in
            
            self.bookImageArray[safe: cellIndex]?.isDownloading = false
            self.bookImageArray[safe: cellIndex]?.image = UIImage(named: "no_book_cover")
            
            completionHandler()
        })
    }
    
    func getDescriptionForCellFromURL(cellIndex: Int, descriptionID: String, completionHandler: @escaping (() -> Void) ) {
        
        self.bookDescriptionArray[cellIndex].isDownloading = true
        
        let descriptionURL = Constants.main.API_URL + "/api/books?bibkeys=\(descriptionID)&jscmd=details&format=json"
        
        NetworkManager.shared.sendGETRequestResponseJSON(stringURL: descriptionURL, successHandler: { json in
            
            self.bookDescriptionArray[safe: cellIndex]?.isDownloading = false
            self.bookDescriptionArray[safe: cellIndex]?.text = self.parseDescriptionOLDetailsBook(json: json, descriptionID: descriptionID) ?? "No description available"
            
            completionHandler()
                
        }, failureHandler: { error in
            
            self.bookDescriptionArray[safe: cellIndex]?.isDownloading = false
            self.bookDescriptionArray[safe: cellIndex]?.text = "No description available"
            completionHandler()
        })
    }
    
    private func parseDescriptionOLDetailsBook(json: Any, descriptionID: String) -> String? {
        guard let dict1 = json as? [String: Any] else { return nil }
        guard let dict2 = dict1["\(descriptionID)"] as? [String: Any] else { return nil }
        guard let dict3 = dict2["details"] as? [String: Any] else { return nil }
        guard let description = dict3["description"] as? String else { return nil }
        
        return description
    }
    
    func loadMoreBooks(successHandler: (() -> Void)?, failureHandler: (() -> Void)?) {
        
        let stringURL = Constants.main.API_URL + "/search.json?page=\(page)&q=\(searchQuery.replacingOccurrences(of: " ", with: "+"))"
        
        NetworkManager.shared.sendGETRequestResponseModel(stringURL: stringURL, successHandler: { [weak self] (model: OLSearchPaginationModel) in
                
            guard let self = self else { return }
            
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
