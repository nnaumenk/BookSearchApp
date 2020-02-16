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

    var myModel = BookSearchModel()
    var myView = BookSearchView()
    
    override func loadView() {
        self.view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Open Library"
        
        myView.searchTextField.delegate = self
        myView.searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
    }
}

extension BookSearchViewController {
    
    @objc private func searchButtonClicked() {
        if activityIndicatorView.isAnimating { return }
        if myView.searchTextField.text!.isEmpty { return }
        
        activityIndicatorView.startAnimating()
        myModel.loadBooks(searchQuery: myView.searchTextField.text!, successHandler: { [weak self] in
            
            guard let self = self else { return }
            
            let bookListModel = BookListModel(searchQuery: self.myModel.searchQuery, bookListModelArray: self.myModel.bookListModelArray, maxItemsNumber: self.myModel.maxItemsNumber)
            self.bookNavigationController?.openBookListVC(model: bookListModel)
            
        }, failureHandler: { [weak self] error in
            
            guard let self = self else { return }
            
            self.activityIndicatorView.stopAnimating()
            self.showErrorAlert(message: error)
        })
    }
    
}

extension BookSearchViewController: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myView.searchTextField.resignFirstResponder()
        return true
    }
}
