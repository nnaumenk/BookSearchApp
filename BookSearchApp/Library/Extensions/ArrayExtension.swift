//
//  CollectionExtension.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/8/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation

extension Array {
    
    subscript (safe index: Index?) -> Element? {
        get {
            guard let index = index else { return nil }
            
            return indices.contains(index) ? self[index] : nil
        }
        set (newValue) {
            guard let index = index else { return }
            if !indices.contains(index) { return }
            guard let newValue = newValue else { return }
            
            self[index] = newValue
        }
    }
}
