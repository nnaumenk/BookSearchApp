//
//  BookDetailsCell.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/9/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class BookDetailsCell: UITableViewCell {

    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
//        NSLayoutConstraint.activate([
//            leftLabel.widthAnchor.constraint(equalTo: rightLabel.widthAnchor),
//            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            rightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//        ])
        
        leftLabel.snp.makeConstraints({ make in
            make.width.equalTo(rightLabel.snp.width)
            make.centerY.equalTo(contentView.snp.centerY)
        })
        
        rightLabel.snp.makeConstraints({ make in
            make.centerY.equalTo(contentView.snp.centerY)
        })
        
        let views: [String: UIView] = [
            "leftLabel": leftLabel,
            "rightLabel": rightLabel,
        ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[leftLabel]-8-[rightLabel]-16-|", options: [], metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=8)-[rightLabel]-(>=8)-|", options: [], metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=8)-[leftLabel]-(>=8)-|", options: [], metrics: nil, views: views))
    }
}
