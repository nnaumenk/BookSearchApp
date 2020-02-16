//
//  BookDetailsModel.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/16/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

final class BookDetailsModel {

    private(set) var editionTitle: String
    private(set) var imageURL: String
    private(set) var editionKey: String
    
    var bookDetailsModelArray: [(key: String, value: Any)] = []
    
    init(editionTitle: String, imageURL: String, editionKey: String) {
        self.editionTitle = editionTitle
        self.imageURL = imageURL
        self.editionKey = editionKey
    }
    
    func loadDetails(successHandler: (() -> Void)?, failureHandler: (() -> Void)?) {
        let descriptionURL =  Constants.main.API_URL + "/api/books?bibkeys=\(editionKey)&jscmd=details&format=json"
        
        NetworkManager.shared.sendGETRequestResponseJSON(stringURL: descriptionURL, successHandler: { [weak self] json in
            
            guard let self = self else { return }
            
            guard let model = self.parseModelDetailsBook(json: json, descriptionID: self.editionKey) else {
                failureHandler?()
                return
            }
            
            self.bookDetailsModelArray = Array(model)
            successHandler?()
            
        }, failureHandler: { errror in
            failureHandler?()
        })
        
    }
    
    private func parseModelDetailsBook(json: Any, descriptionID: String) -> [String: Any]? {
        guard let dict1 = json as? [String: Any] else { return nil }
        guard let dict2 = dict1["\(descriptionID)"] as? [String: Any] else { return nil }
        guard let dict3 = dict2["details"] as? [String: Any] else { return nil }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict3, options: .prettyPrinted) else { return nil }
        guard let responseModel = try? JSONDecoder().decode(OLBookDetailsModel.self, from: jsonData) else { return nil }
        guard let dict = responseModel.dictionary else { return nil }
        
        return dict
    }
}
