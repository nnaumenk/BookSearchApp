//
//  BookSearchView.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/16/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

final class BookSearchView: UIView {

    var searchTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Book's title"
        textFiled.borderStyle = .roundedRect
        textFiled.returnKeyType = .done
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    
    var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "search_icon"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        searchTextFieldConfigure()
        searchButtonConfigure()
        
        setupVisualConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func searchTextFieldConfigure(){
        
        self.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.widthAnchor.constraint(equalToConstant: 200),
            searchTextField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor, constant: -100)
        ])
    }
    
    private func searchButtonConfigure(){
        
        self.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24),
            searchButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor, constant: -100)
        ])
    }
    
    private func setupVisualConstraints() {
        let views: [String: UIView] = [
            "searchTextField": searchTextField,
            "searchButton": searchButton,
        ]
            
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[searchTextField]-4-[searchButton]", options: [], metrics: nil, views: views))
    }
    
}
