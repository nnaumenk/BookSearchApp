//
//  OpenLibraryBookModel.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/8/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation

struct OLBookListModel: Codable {
    var cover_i: Int?
    var edition_key: [String]?
    var author_name: [String]?
    var title: String?
    
    var mediumImageURL: String? {
        guard let cover_i = cover_i else { return nil }
        if cover_i <= 0 { return nil }
        
        return "http://covers.openlibrary.org/w/id/\(cover_i)-M.jpg"
    }
    
    var largeImageURL: String? {
        guard let cover_i = cover_i else { return nil }
        
        return "http://covers.openlibrary.org/w/id/\(cover_i)-L.jpg"
    }
}
