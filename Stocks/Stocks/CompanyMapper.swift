//
//  CompanyMapper.swift
//  Stocks
//
//  Created by Alexandr Sokolov on 11.07.2022.
//

import Foundation
import UIKit

class CompanyMapper {
    
    weak var request: RequestDataProvider?
    weak var delegate: SetInfoDelegate?
    
    func parseQuote(data: Data) {
        guard let companyInfoObject = try? JSONDecoder().decode(StockInformation.self, from: data) else {
            DispatchQueue.main.async {
                UIAlertController.jsonAlert(from: self.delegate, message: "Unable to get company details")
            }
            
            return
        }
        
        DispatchQueue.main.async {
            self.delegate?.displayStockInfo(companyInfo: companyInfoObject)
        }
    }
    
    func getURLImage(data: Data) {
        guard let imageUrl = try? JSONDecoder().decode(CompanyImageUrl.self, from: data) else {
            DispatchQueue.main.async {
                UIAlertController.jsonAlert(from: self.delegate, message: "Unable to load company logo.")
            }
            
            return
        }
        
        self.request?.downloadImage(url: imageUrl.url)
    }
    
    func parseCompanies(data: Data) {
        guard let companies = try? JSONDecoder().decode([CompanyInformation].self, from: data) else {
            DispatchQueue.main.async {
                UIAlertController.jsonAlert(from: self.delegate, message: "Unable to get list of companies. Only five main companies are available.")
            }
            
            return
        }
        
        self.delegate?.setNewCompanies(newCompanies: companies)
    }
    
}
