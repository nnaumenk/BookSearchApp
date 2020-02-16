//
//  BookSearchModel.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/16/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//


final class BookSearchModel {
    
    private(set) var searchQuery: String = ""
    private(set) var bookListModelArray: [OLBookListModel] = []
    private(set) var maxItemsNumber: Int = 0
    
    func loadBooks(searchQuery: String, successHandler: (() -> Void)?, failureHandler: ((String) -> Void)?) {
        
        let stringURL = Constants.main.API_URL + "/search.json?page=\(1)&q=\(searchQuery.replacingOccurrences(of: " ", with: "+"))"
        
        NetworkManager.shared.sendGETRequestResponseModel(stringURL: stringURL, successHandler: { [weak self] (model: OLSearchPaginationModel) in
            
            guard let self = self else { return }
            
            if model.docs.isEmpty {
                failureHandler?("No results")
                return
            }
            
            self.searchQuery = searchQuery
            self.bookListModelArray = model.docs
            self.maxItemsNumber = model.numFound
            
            successHandler?()
                
        }, failureHandler: { error in
            
            failureHandler?(error)
        })
    }
}
