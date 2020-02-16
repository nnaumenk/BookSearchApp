//
//  BookListViewController.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/8/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

final class BookListViewController: MyViewController {
    
    var myModel: BookListModel!
    var myView = BookListView()
    
    override func loadView() {
        self.view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = myModel.searchQuery
        
        myView.bookTableView.delegate = self
        myView.bookTableView.dataSource = self
        myView.bookTableView.register(BookListCell.self, forCellReuseIdentifier: "bookListCell")
    }
}

extension BookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myModel.bookListModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bookModel = myModel.bookListModelArray[safe: indexPath.row] else { return UITableViewCell() }
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
        guard let largeImageURL = myModel.bookListModelArray[safe: indexPath.row]?.largeImageURL else {
            showErrorAlert(message: "No additional information available")
            return
        }
        guard let editionTitle = myModel.bookListModelArray[safe: indexPath.row]?.title else {
            showErrorAlert(message: "No additional information available")
            return
        }
        guard let editionKey = myModel.bookListModelArray[safe: indexPath.row]?.edition_key?.first else {
            showErrorAlert(message: "No additional information available")
            return
        }
        
        bookNavigationController?.openBookDetailsVC(model: BookDetailsModel(editionTitle: editionTitle, imageURL: largeImageURL, editionKey: editionKey))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !scrollView.isNextPagination(percent: 0.6) { return }
        if activityIndicatorView.isAnimating { return }
        
        activityIndicatorView.startAnimating()
        
        myModel.loadMoreBooks(successHandler: { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicatorView.stopAnimating()
            self.myView.bookTableView.reloadData()
            
        }, failureHandler: { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicatorView.stopAnimating()
        })
    }
}

extension BookListViewController {
    private func setCellImage(indexPath: IndexPath, bookModel: OLBookListModel, cell: BookListCell) {
        
        cell.leftImageView.stopActivityIndicator()
        
        guard let imageURL = bookModel.mediumImageURL else {
            myModel.bookImageArray[indexPath.row].image = UIImage(named: "no_book_cover")
            cell.leftImageView.image = myModel.bookImageArray[safe: indexPath.row]?.image
            return
        }
        
        if let image = myModel.bookImageArray[indexPath.row].image {
            cell.leftImageView.image = image
            return
        }
        
        if myModel.bookImageArray[indexPath.row].isDownloading {
            cell.leftImageView.startActivityIndicator()
            return
        }
        
        cell.leftImageView.startActivityIndicator()
        cell.leftImageView.image = nil
        
        myModel.getImageForCellFromURL(cellIndex: indexPath.row, urlString: imageURL, completionHandler: { [weak self] in
            guard let self = self else { return }
                
            guard let indexPathsForVisibleRows = self.myView.bookTableView.indexPathsForVisibleRows else { return }
            if !indexPathsForVisibleRows.contains(indexPath) { return }
            guard let newCell = self.myView.bookTableView.cellForRow(at: indexPath) as? BookListCell else { return }
            
            newCell.leftImageView.stopActivityIndicator()
            newCell.leftImageView.image = self.myModel.bookImageArray[indexPath.row].image
        })
    }
    
    private func setCellDescription(indexPath: IndexPath, bookModel: OLBookListModel, cell: BookListCell) {
        
        cell.descriptionLabel.stopActivityIndicator()
        
        guard let descriptionID = bookModel.edition_key?.first else {
            self.myModel.bookDescriptionArray[safe: indexPath.row]?.text = "No description available"
            cell.descriptionLabel.text = "No description available"
            return
        }
        
        if let text = myModel.bookDescriptionArray[safe: indexPath.row]?.text {
            cell.descriptionLabel.text = text
            return
        }
        
        if myModel.bookDescriptionArray[safe: indexPath.row]?.isDownloading ?? false {
            cell.descriptionLabel.startActivityIndicator()
            return
        }
        
        myModel.bookDescriptionArray[safe: indexPath.row]?.isDownloading = true
        cell.descriptionLabel.startActivityIndicator()
        cell.descriptionLabel.text = ""
        
        myModel.getDescriptionForCellFromURL(cellIndex: indexPath.row, descriptionID: descriptionID, completionHandler: { [weak self] in
            guard let self = self else { return }
            
            guard let indexPathsForVisibleRows = self.myView.bookTableView.indexPathsForVisibleRows else { return }
            if !indexPathsForVisibleRows.contains(indexPath) { return }
            guard let newCell = self.myView.bookTableView.cellForRow(at: indexPath) as? BookListCell else { return }
               
            newCell.descriptionLabel.stopActivityIndicator()
            newCell.descriptionLabel.text = self.myModel.bookDescriptionArray[indexPath.row].text
        })
    }
}
