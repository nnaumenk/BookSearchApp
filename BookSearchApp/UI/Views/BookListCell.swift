//
//  BookListCell.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/8/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit
import SnapKit

final class BookListCell: UITableViewCell {

    lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    lazy var subtileLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
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
//            leftImageView.heightAnchor.constraint(equalToConstant: 80),
//            leftImageView.widthAnchor.constraint(equalToConstant: 60),
//            leftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//        ])
//        
//        NSLayoutConstraint.activate([
//            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
//            subtileLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
//            descriptionLabel.heightAnchor.constraint(equalToConstant: 60),
//        ])
        
        leftImageView.snp.makeConstraints({ make in
            make.height.equalTo(80)
            make.width.equalTo(60)
            make.centerY.equalTo(contentView.snp.centerY)
        })
        
        titleLabel.snp.makeConstraints({ make in
            make.height.greaterThanOrEqualTo(18)
        })
        
        subtileLabel.snp.makeConstraints({ make in
            make.height.greaterThanOrEqualTo(18)
        })
        
        descriptionLabel.snp.makeConstraints({ make in
            make.height.equalTo(60)
        })
        
        let views: [String: UIView] = [
            "leftImageView": leftImageView,
            "titleLabel": titleLabel,
            "subtileLabel": subtileLabel,
            "descriptionLabel": descriptionLabel,
        ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[leftImageView]-16-[titleLabel]-16-|", options: [], metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[leftImageView]-16-[subtileLabel]-16-|", options: [], metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[leftImageView]-16-[descriptionLabel]-16-|", options: [], metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[titleLabel]-4-[subtileLabel]-8-[descriptionLabel]-8-|", options: [], metrics: nil, views: views))
    }
}
