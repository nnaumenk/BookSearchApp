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
        return tableView
    }()
    
    var model: BookListModel!
    
    override func loadView() {
        self.view = bookTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = model.searchQuery
    }
}

extension BookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.bookListModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bookModel = model.bookListModelArray[safe: indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookListCell") as? BookListCell else { return UITableViewCell() }
        
        cell.titleLabel.text = bookModel.title ?? ""
        cell.subtileLabel.text = bookModel.author_name != nil ? "by " + bookModel.author_name!.joined(separator: " • ") : ""
        
        setCellImage(indexPath: indexPath, bookModel: bookModel, cell: cell)
        setCellDescription(indexPath: indexPath, bookModel: bookModel, cell: cell)
        
        return cell
    }
}


extension BookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let largeImageURL = model.bookListModelArray[safe: indexPath.row]?.largeImageURL else {
            showErrorAlert(message: "No additional information available")
            return
        }
        guard let editionTitle = model.bookListModelArray[safe: indexPath.row]?.title else {
            showErrorAlert(message: "No additional information available")
            return
        }
        guard let editionKey = model.bookListModelArray[safe: indexPath.row]?.edition_key?.first else {
            showErrorAlert(message: "No additional information available")
            return
        }
        
        bookNavigationController?.openBookDetailsVC(imageURL: largeImageURL, editionTitle: editionTitle, editionKey: editionKey)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        struct offset {
            static var oldMaximum: CGFloat = 0
            static var currentMaximum: CGFloat = 0
            
            static func update(maximumOffset: CGFloat) {
                
                if currentMaximum == maximumOffset { return }
                    
                oldMaximum = currentMaximum
                currentMaximum = maximumOffset
            }
        }
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        
        offset.update(maximumOffset: maximumOffset)
        
        if (currentOffset - offset.oldMaximum) / (maximumOffset - offset.oldMaximum) < 0.6 {
            return
        }
        
        if activityIndicatorView.isAnimating { return }
        
        model.loadMore(failureHandler: nil, successHandler: { [weak self] in
            guard let self = self else { return }
            
            self.bookTableView.reloadData()
        })
    }
}

extension BookListViewController {
    private func setCellImage(indexPath: IndexPath, bookModel: OLBookListModel, cell: BookListCell) {
        
        cell.leftImageView.stopActivityIndicator()
        
        guard let imageURL = bookModel.mediumImageURL else {
            model.bookImageArray[indexPath.row].image = UIImage(named: "no_book_cover")
            cell.leftImageView.image = model.bookImageArray[safe: indexPath.row]?.image
            return
        }
        
        if let image = model.bookImageArray[indexPath.row].image {
            cell.leftImageView.image = image
            return
        }
        
        if model.bookImageArray[indexPath.row].isDownloading {
            cell.leftImageView.startActivityIndicator()
            return
        }
        
        model.bookImageArray[indexPath.row].isDownloading = true
        cell.leftImageView.startActivityIndicator()
        cell.leftImageView.image = nil
        
        self.getImageFromURL(urlString: imageURL, completionHandler: { [weak self] image in
            guard let self = self else { return }
            
            self.model.bookImageArray[safe: indexPath.row]?.isDownloading = false
            self.model.bookImageArray[safe: indexPath.row]?.image = image ?? UIImage(named: "no_book_cover")
                
            guard let indexPathsForVisibleRows = self.bookTableView.indexPathsForVisibleRows else { return }
            if !indexPathsForVisibleRows.contains(indexPath) { return }
            guard let newCell = self.bookTableView.cellForRow(at: indexPath) as? BookListCell else { return }
            
            newCell.leftImageView.stopActivityIndicator()
            newCell.leftImageView.image = self.model.bookImageArray[indexPath.row].image
        })
    }
    
    private func setCellDescription(indexPath: IndexPath, bookModel: OLBookListModel, cell: BookListCell) {
        
        cell.descriptionLabel.stopActivityIndicator()
        
        guard let descriptionID = bookModel.edition_key?.first else {
            self.model.bookDescriptionArray[safe: indexPath.row]?.text = "No description available"
            cell.descriptionLabel.text = "No description available"
            return
        }
        
        if let text = model.bookDescriptionArray[safe: indexPath.row]?.text {
            cell.descriptionLabel.text = text
            return
        }
        
        if model.bookDescriptionArray[safe: indexPath.row]?.isDownloading ?? false {
            cell.descriptionLabel.startActivityIndicator()
            return
        }
        
        model.bookDescriptionArray[safe: indexPath.row]?.isDownloading = true
        cell.descriptionLabel.startActivityIndicator()
        cell.descriptionLabel.text = ""
        
        self.getDescriptionFromURL(descriptionID: descriptionID, completionHandler: { [weak self] text in
            guard let self = self else { return }
            
            self.model.bookDescriptionArray[safe: indexPath.row]?.isDownloading = false
            self.model.bookDescriptionArray[safe: indexPath.row]?.text = text
            
            guard let indexPathsForVisibleRows = self.bookTableView.indexPathsForVisibleRows else { return }
            if !indexPathsForVisibleRows.contains(indexPath) { return }
            guard let newCell = self.bookTableView.cellForRow(at: indexPath) as? BookListCell else { return }
               
            newCell.descriptionLabel.stopActivityIndicator()
            newCell.descriptionLabel.text = self.model.bookDescriptionArray[indexPath.row].text
        })
    }

    private func getDescriptionFromURL(descriptionID: String, completionHandler: @escaping ((String) -> Void) ) {
        
        let descriptionURL = Constants.main.API_URL + "/api/books?bibkeys=\(descriptionID)&jscmd=details&format=json"
        
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
}
