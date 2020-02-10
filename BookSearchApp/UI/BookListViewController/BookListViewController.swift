//
//  BookListViewController.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/8/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

final class BookListViewController: MyViewController {

    private lazy var bookTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookListCell.self, forCellReuseIdentifier: "bookListCell")
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.addSubview(tableView)
        return tableView
    }()
    
    
    var bookListModelArray: [OLBookListModel]! {
        didSet {
            self.bookImageArray = Array(repeating: (false, nil), count: bookListModelArray.count)
            self.bookDescriptionArray = Array(repeating: (false, nil), count: bookListModelArray.count)
        }
    }
    var searchQuery: String!
    var maxItemsNumber: Int!
    var bookImageArray: [(isDownloading: Bool, image: UIImage?)]!
    var bookDescriptionArray: [(isDownloading: Bool, text: String?)]!
    
    private var page = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = searchQuery
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let views: [String: UIView] = [
            "bookTableView": bookTableView,
        ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[bookTableView]-0-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bookTableView]-0-|", options: [], metrics: nil, views: views))
    }
}

extension BookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookListModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = bookListModelArray[safe: indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookListCell") as? BookListCell else { return UITableViewCell() }
        
        cell.titleLabel.text = model.title ?? ""
        cell.subtileLabel.text = String(indexPath.row)//model.author_name != nil ? "by " + model.author_name!.joined(separator: " • ") : ""
        
        setCellImage(indexPath: indexPath, model: model, cell: cell)
        setCellDescription(indexPath: indexPath, model: model, cell: cell)
        
        return cell
    }
}


extension BookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let largeImageURL = bookListModelArray[safe: indexPath.row]?.largeImageURL else {
            showErrorAlert(message: "No additional information available")
            return
        }
        guard let editionTitle = bookListModelArray[safe: indexPath.row]?.title else {
            showErrorAlert(message: "No additional information available")
            return
        }
        guard let editionKey = bookListModelArray[safe: indexPath.row]?.edition_key?.first else {
            showErrorAlert(message: "No additional information available")
            return
        }
        
        bookNavigationController?.openBookDetailsVC(imageURL: largeImageURL, editionTitle: editionTitle, editionKey: editionKey)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        
        if currentOffset / maximumOffset < 0.6 {
            return
        }
        
        if bookListModelArray.count == maxItemsNumber { return }
        if activityIndicatorView.isAnimating { return }
        
        loadMore()
    }
}

extension BookListViewController {
    private func setCellImage(indexPath: IndexPath, model: OLBookListModel, cell: BookListCell) {
        
        cell.leftImageView.stopActivityIndicator()
        
        guard let imageURL = model.mediumImageURL else {
            bookImageArray[indexPath.row].image = UIImage(named: "no_book_cover")
            cell.leftImageView.image = bookImageArray[indexPath.row].image
            return
        }
        
        if let image = bookImageArray[indexPath.row].image {
            cell.leftImageView.image = image
            return
        }
        
        if bookImageArray[indexPath.row].isDownloading {
            cell.leftImageView.startActivityIndicator()
            return
        }
        
        bookImageArray[indexPath.row].isDownloading = true
        cell.leftImageView.startActivityIndicator()
        cell.leftImageView.image = nil
        
        self.getImageFromURL(urlString: imageURL, completionHandler: { image in
                
            self.bookImageArray[indexPath.row].isDownloading = false
            self.bookImageArray[indexPath.row].image = image ?? UIImage(named: "no_book_cover")
                
            guard let indexPathsForVisibleRows = self.bookTableView.indexPathsForVisibleRows else { return }
            if !indexPathsForVisibleRows.contains(indexPath) { return }
            guard let newCell = self.bookTableView.cellForRow(at: indexPath) as? BookListCell else { return }
            
            newCell.leftImageView.stopActivityIndicator()
            newCell.leftImageView.image = self.bookImageArray[indexPath.row].image
        })
    }
    
    private func setCellDescription(indexPath: IndexPath, model: OLBookListModel, cell: BookListCell) {
        cell.descriptionLabel.stopActivityIndicator()
        
        guard let descriptionID = model.edition_key?.first else {
            self.bookDescriptionArray[indexPath.row].text = "No description available"
            cell.descriptionLabel.text = "No description available"
            return
        }
        
        if let text = bookDescriptionArray[indexPath.row].text {
            cell.descriptionLabel.text = text
            return
        }
        
        if bookDescriptionArray[indexPath.row].isDownloading {
            cell.descriptionLabel.startActivityIndicator()
            return
        }
        
        bookDescriptionArray[indexPath.row].isDownloading = true
        cell.descriptionLabel.startActivityIndicator()
        cell.descriptionLabel.text = ""
        
        self.getDescriptionFromURL(descriptionID: descriptionID, completionHandler: { text in
            
            self.bookDescriptionArray[indexPath.row].isDownloading = false
            self.bookDescriptionArray[indexPath.row].text = text
            
            guard let indexPathsForVisibleRows = self.bookTableView.indexPathsForVisibleRows else { return }
            if !indexPathsForVisibleRows.contains(indexPath) { return }
            guard let newCell = self.bookTableView.cellForRow(at: indexPath) as? BookListCell else { return }
               
            newCell.descriptionLabel.stopActivityIndicator()
            newCell.descriptionLabel.text = self.bookDescriptionArray[indexPath.row].text
        })
    }

    private func getDescriptionFromURL(descriptionID: String, completionHandler: @escaping ((String) -> Void) ) {
        
        let descriptionURL = "https://openlibrary.org/api/books?bibkeys=\(descriptionID)&jscmd=details&format=json"
        NetworkManager.shared.sendGETRequestResponseJSON(stringURL: descriptionURL, successHandler: { json in
            guard let description = self.parseDescriptionOLDetailsBook(json: json, descriptionID: descriptionID) else {
                completionHandler("No description available")
                return
            }
            
            completionHandler(description)
                
        }, failureHandler: { error in
            completionHandler("No description available")
        })
    }
    
    private func getImageFromURL(urlString: String, completionHandler: @escaping ((UIImage?) -> Void) ) {
        
        NetworkManager.shared.sendGETRequestResponseData(stringURL: urlString, successHandler: { data in
            
            let image = UIImage(data: data)
            completionHandler(image)
                
        }, failureHandler: { error in
            
            completionHandler(nil)
        })
    }
    
    private func parseDescriptionOLDetailsBook(json: Any, descriptionID: String) -> String? {
        guard let dict1 = json as? [String: Any] else { return nil }
        guard let dict2 = dict1["\(descriptionID)"] as? [String: Any] else { return nil }
        guard let dict3 = dict2["details"] as? [String: Any] else { return nil }
        guard let description = dict3["description"] as? String else { return nil }
        
        return description
    }
    
    private func loadMore() {
        let stringURL = "http://openlibrary.org/search.json?page=\(self.page)&q=\(searchQuery.replacingOccurrences(of: " ", with: "+"))"
        
        activityIndicatorView.startAnimating()
        NetworkManager.shared.sendGETRequestResponseModel(stringURL: stringURL, successHandler: { (model: OLSearchPaginationModel) in
                
            self.activityIndicatorView.stopAnimating()
                
            if model.docs.isEmpty {
                self.showErrorAlert(message: "No results")
                return
            }
                
            self.page += 1
            
            self.bookListModelArray += model.docs
            self.bookImageArray += Array(repeating: (false, nil), count: model.docs.count)
            self.bookDescriptionArray += Array(repeating: (false, nil), count: model.docs.count)
                
            self.bookTableView.reloadData()
                
        }, failureHandler: { error in
                
            self.activityIndicatorView.stopAnimating()
            self.showErrorAlert(message: error)
        })
    }
}
