//
//  ScrollViewExtension.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/16/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    func isNextPagination(percent: CGFloat) -> Bool { // in order to get percent offset not of whole scrolview, but from currentPagination block
        
        struct offset {
            static var oldMaximum: CGFloat = 0
            
            static func update(maximumOffset: CGFloat) {
                oldMaximum = maximumOffset
            }
        }
        
        let currentOffset = self.contentOffset.y
        let maximumOffset = self.contentSize.height - self.frame.height
        
        if (currentOffset - offset.oldMaximum) / (maximumOffset - offset.oldMaximum) < percent {
            return false
        }
        
        offset.update(maximumOffset: maximumOffset)
        return true
    }
}
