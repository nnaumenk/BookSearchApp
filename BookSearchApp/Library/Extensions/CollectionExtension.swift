//
//  CollectionExtension.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/8/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index?) -> Element? {
        guard let index = index else { return nil }
        
        return indices.contains(index) ? self[index] : nil
    }
}
