//
//  BookListDetailsViewController.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/9/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

final class BookDetailsViewController: MyViewController {

    var myModel: BookDetailsModel!
    var myView = BookDetailsView()
    
    
    override func loadView() {
        self.view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = myModel.editionTitle
        
        myView.bookTableView.dataSource = self
        myView.bookTableView.register(BookDetailsCell.self, forCellReuseIdentifier: "bookDetailsCell")
        
        myView.avatarCell.avatarImageView.imageFromURL(urlString: myModel.imageURL, completionHandler: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicatorView.startAnimating()
        myModel.loadDetails(successHandler: { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicatorView.stopAnimating()
            self.myView.bookTableView.reloadData()
            
        }, failureHandler: { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicatorView.stopAnimating()
            
            self.showErrorAlertWithCompletion(message: "Some error occurred", handler: { action in
                
                self.bookNavigationController?.popViewController(animated: true)
            })
        })
    }
}

extension BookDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return 1
        case 1:
            return myModel.bookDetailsModelArray.count
        
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return myView.avatarCell
        }
        
        guard let bookDetailsModel = myModel.bookDetailsModelArray[safe: indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookDetailsCell") as? BookDetailsCell else { return UITableViewCell() }
        
        cell.leftLabel.text = bookDetailsModel.key
        if let dictArray = bookDetailsModel.value as? [[String: Any]] {
            cell.rightLabel.text = dictArray.flatMap { Array($0) }.map { String(describing: $0.value) }.joined(separator: "\n")
        } else {
            cell.rightLabel.text = String(describing: bookDetailsModel.value)
        }
        
        return cell
    }
}

