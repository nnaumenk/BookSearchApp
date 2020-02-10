//
//  SearchViewController.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/8/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit
import SnapKit

final class BookSearchViewController: MyViewController {

    private lazy var searchTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Book's title"
        textFiled.borderStyle = .roundedRect
        textFiled.returnKeyType = .done
        textFiled.delegate = self
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.addSubview(textFiled)
        return textFiled
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "search_icon"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.addSubview(button)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Open Library"
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        
//        NSLayoutConstraint.activate([
//            searchTextField.widthAnchor.constraint(equalToConstant: 200),
//            searchTextField.centerXAnchor.constraint(equalTo: safeAreaView.centerXAnchor),
//            searchTextField.centerYAnchor.constraint(equalTo: safeAreaView.centerYAnchor, constant: -100)
//        ])
//        
//        NSLayoutConstraint.activate([
//            searchButton.widthAnchor.constraint(equalToConstant: 24),
//            searchButton.heightAnchor.constraint(equalToConstant: 24),
//            searchButton.centerYAnchor.constraint(equalTo: safeAreaView.centerYAnchor, constant: -100)
//        ])
        
        searchTextField.snp.makeConstraints({ make in
            make.width.equalTo(200)
            make.centerX.equalTo(safeAreaView.snp.centerX)
            make.centerY.equalTo(safeAreaView.snp.centerY).offset(-100)
        })
        
        searchButton.snp.makeConstraints({ make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.centerY.equalTo(safeAreaView.snp.centerY).offset(-100)
        })
        
        let views: [String: UIView] = [
            "searchTextField": searchTextField,
            "searchButton": searchButton,
        ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[searchTextField]-4-[searchButton]", options: [], metrics: nil, views: views))
    }
}

extension BookSearchViewController {
    
    @objc private func searchButtonClicked() {
        if activityIndicatorView.isAnimating { return }
        if searchTextField.text!.isEmpty { return }
        
        let searchFieldText = searchTextField.text!
        let stringURL = "http://openlibrary.org/search.json?page=\(1)&q=\(searchFieldText.replacingOccurrences(of: " ", with: "+"))"
        
        activityIndicatorView.startAnimating()
        NetworkManager.shared.sendGETRequestResponseModel(stringURL: stringURL, successHandler: { (model: OLSearchPaginationModel) in
            
            self.activityIndicatorView.stopAnimating()
            
            if model.docs.isEmpty {
                self.showErrorAlert(message: "No results")
                return
            }
            
            self.bookNavigationController?.openBookListVC(bookListModelArray: model.docs, searchQuery: searchFieldText, maxItemsNumber: model.numFound)
            
        }, failureHandler: { error in
            
            self.activityIndicatorView.stopAnimating()
            self.showErrorAlert(message: error)
        })
    }
    
}

extension BookSearchViewController: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
