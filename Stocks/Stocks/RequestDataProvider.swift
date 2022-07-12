//
//  RequestDataProvider.swift
//  Stocks
//
//  Created by Alexandr Sokolov on 11.07.2022.
//

import Foundation
import UIKit
class RequestDataProvider {
    
    weak var delegate: ViewController?
    var mapper: CompanyMapper?
    
    func requestCompanies() {
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/gainers?&token=pk_1b0b1154ec5d4ecfa2eb73a48c692401") else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                DispatchQueue.main.async {
                    UIAlertController.networkAlert(from: self?.delegate)
                }
                
                return
            }
            
            self?.mapper?.parseCompanies(data: data)
        }
        
        dataTask.resume()
    }
    
    func requestQuote(for symbol: String) {
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?&token=pk_1b0b1154ec5d4ecfa2eb73a48c692401") else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                DispatchQueue.main.async {
                    UIAlertController.networkAlert(from: self?.delegate)
                }
                
                return
            }
            
            self?.mapper?.parseQuote(data: data)
        }
        
        dataTask.resume()
    }
    
    func downloadImage(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                DispatchQueue.main.async {
                    UIAlertController.networkAlert(from: self?.delegate)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self?.delegate?.companyImage.image = UIImage(data: data)
                self?.delegate?.companyImage.isHidden = false
            }
        }
        
        dataTask.resume()
    }
    
    func setImage(for symbol: String) {
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/logo?&token=pk_1b0b1154ec5d4ecfa2eb73a48c692401") else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                DispatchQueue.main.async {
                    UIAlertController.networkAlert(from: self?.delegate)
                }
                
                return
            }
            
            self?.mapper?.getURLImage(data: data)
        }
        
        dataTask.resume()
    }
}
