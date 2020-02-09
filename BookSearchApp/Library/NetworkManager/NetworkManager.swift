//
//  NetworkManager.swift
//  BookSearchApp
//
//  Created by Nazar NAUMENKO on 2/8/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    private init() {}
    static let shared = NetworkManager()
    
    
    func sendGETRequestResponseModel<T: Codable>(stringURL: String, successHandler: @escaping (T) -> Void, failureHandler: @escaping (String) -> Void) {
        
        guard let url = URL(string: stringURL) else {
            failureHandler("Invalid book title")
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil).validate().responseJSON { response in
            
            guard let json = response.result.value as? [String: Any] else {
                DispatchQueue.main.async { failureHandler(response.result.error?.localizedDescription ?? "Some error occured") }
                return
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                DispatchQueue.main.async { failureHandler("Some error occured") }
                return
            }
            
            guard let responseModel: T = try? JSONDecoder().decode(T.self, from: jsonData) else {
                DispatchQueue.main.async { failureHandler("Some error occured") }
                return
            }
            
            DispatchQueue.main.async { successHandler(responseModel) }
        }
    }
    
    func sendGETRequestResponseData(stringURL: String, successHandler: @escaping (Data) -> Void, failureHandler: @escaping (String) -> Void) {
        
        guard let url = URL(string: stringURL) else {
            failureHandler("Invalid book title")
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil).validate().responseData { response in
            
            guard let data = response.data else {
                DispatchQueue.main.async { failureHandler(response.error?.localizedDescription ?? "Some error occured") }
                return
            }
            
            DispatchQueue.main.async { successHandler(data) }
        }
    }
    
    func sendGETRequestResponseJSON(stringURL: String, successHandler: @escaping (Any) -> Void, failureHandler: @escaping (String) -> Void) {
        
        guard let url = URL(string: stringURL) else {
            failureHandler("Invalid book title")
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil).validate().responseJSON { response in
            
            guard let json = response.result.value else {
                DispatchQueue.main.async { failureHandler(response.error?.localizedDescription ?? "Some error occured") }
                return
            }
            
            DispatchQueue.main.async { successHandler(json) }
        }
    }
    
}

