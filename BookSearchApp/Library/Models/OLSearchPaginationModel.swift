//
//  OLSearchPaginationModel.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/8/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation

struct OLSearchPaginationModel: Codable {
    var start: Int
    var numFound: Int
    var docs: [OLBookListModel]
}
