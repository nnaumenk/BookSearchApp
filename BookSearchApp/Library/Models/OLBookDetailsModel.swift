//
//  OLBookDetailsModel.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/9/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation

struct BookDetailsAuthor: Codable {
    var name: String?
}

struct OLBookDetailsModel: Codable {
    var number_of_pages: Int?
    var subtitle: String?
    var weight: String?
    var physical_format: String?
    var title: String?
    var description: String?
    var publish_date: String?
    var physical_dimensions: String?
    var authors: [BookDetailsAuthor]?
}
