//
//  BookListView.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/15/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class BookListView: UIView {

    var bookTableView: UITableView = {
        let tableView = UITableView()
        //tableView.register(BookListCell.self, forCellReuseIdentifier: "bookListCell")
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func bookTableViewConfigure(){
        self.addSubview(bookTableView)
        NSLayoutConstraint.activate([
            bookTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            bookTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            bookTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            bookTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bookTableViewConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
