//
//  BookListDetailsViewController.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/9/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

final class BookDetailsViewController: MyViewController {

    private lazy var bookTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(BookDetailsCell.self, forCellReuseIdentifier: "bookDetailsCell")
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        imageView.contentMode = .scaleAspectFit
        imageView.imageFromURL(urlString: imageURL, completionHandler: nil)
        tableView.tableHeaderView = imageView
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.addSubview(tableView)
        return tableView
    }()
    
    var editionTitle: String!
    var imageURL: String!
    var editionKey: String!
    
    private var bookDetailsModelArray: [(key: String, value: Any)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = editionTitle
        
        setupConstraints()
        loadDetails()
    }
    
    private func setupConstraints() {
        let views: [String: UIView] = [
            "bookTableView": bookTableView,
        ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[bookTableView]-0-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bookTableView]-0-|", options: [], metrics: nil, views: views))
    }
}

extension BookDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookDetailsModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = bookDetailsModelArray[safe: indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookDetailsCell") as? BookDetailsCell else { return UITableViewCell() }
        
        cell.leftLabel.text = model.key
        if let dictArray = model.value as? [[String: Any]] {
            cell.rightLabel.text = dictArray.flatMap { Array($0) }.map { String(describing: $0.value) }.joined(separator: "\n")
        } else {
            cell.rightLabel.text = String(describing: model.value)
        }
        
        
        return cell
    }
}

extension BookDetailsViewController {
    
    private func loadDetails() {
        let descriptionURL = "https://openlibrary.org/api/books?bibkeys=\(editionKey!)&jscmd=details&format=json"
        
        activityIndicatorView.startAnimating()
        NetworkManager.shared.sendGETRequestResponseJSON(stringURL: descriptionURL, successHandler: { json in
            self.activityIndicatorView.stopAnimating()
            
            guard let model = self.parseModelDetailsBook(json: json, descriptionID: self.editionKey) else {
                self.showErrorAlertWithCompletion(message: "Some error occurred", handler: { action in
                    
                    self.bookNavigationController?.popViewController(animated: true)
                })
                return
            }
            
            self.bookDetailsModelArray = Array(model)
            self.bookTableView.reloadData()
            
        }, failureHandler: { errror in
            
            self.activityIndicatorView.stopAnimating()
            self.showErrorAlertWithCompletion(message: "Some error occurred", handler: { action in
                
                self.bookNavigationController?.popViewController(animated: true)
            })
        })
        
    }
    
    private func parseModelDetailsBook(json: Any, descriptionID: String) -> [String: Any]? {
        guard let dict1 = json as? [String: Any] else { return nil }
        guard let dict2 = dict1["\(descriptionID)"] as? [String: Any] else { return nil }
        guard let dict3 = dict2["details"] as? [String: Any] else { return nil }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict3, options: .prettyPrinted) else { return nil }
        guard let responseModel = try? JSONDecoder().decode(OLBookDetailsModel.self, from: jsonData) else { return nil }
        guard let dict = responseModel.dictionary else { return nil }
        
        return dict
    }
    
}
