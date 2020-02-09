//
//  MyViewController.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/8/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {

    lazy var safeAreaView: UIView = {
        let safeAreaView = UIView()
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safeAreaView)
        
        NSLayoutConstraint.activate([
            safeAreaView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            safeAreaView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        return safeAreaView
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .gray
        activityIndicatorView.layer.zPosition = .greatestFiniteMagnitude
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: safeAreaView.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: safeAreaView.centerXAnchor),
        ])
        return activityIndicatorView
    }()
    
    
    var bookNavigationController: BookNavigationController? {
        return navigationController as? BookNavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
