//
//  CompanyMapper.swift
//  Stocks
//
//  Created by Alexandr Sokolov on 11.07.2022.
//

import Foundation
class CompanyMapper {
    
    weak var delegate: ViewController?
    weak var request: RequestDataProvider?
    
    func parseQuote(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double
            else {
                print("Invalid JSON format")
                return
            }
            
            DispatchQueue.main.async {
                self.delegate?.displayStockInfo(companyName: companyName,
                                                symbol: companySymbol,
                                                price: price,
                                                priceChange: priceChange)
            }
            
        } catch {
            print(" JSON parsing error: " + error.localizedDescription)
        }
    }
    
    func getURLImage(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let url = json["url"] as? String
            else {
                print("Invalid JSON format")
                return
            }
            
            self.request?.downloadImage(url: url)
        } catch {
            print(" JSON parsing error: " + error.localizedDescription)
        }
    }
    
    func parseCompanies(data: Data) {
        var newCompanies: [(String, String)] = []
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [[String: Any]]
            else {
                print("Invalid JSON format")
                return
            }
            
            json.forEach {
                guard
                    let company = $0["companyName"] as? String,
                    let symbol = $0["symbol"] as? String
                    
                else {
                    print("Invalid JSON format")
                    return
                }
                
                newCompanies.append((company, symbol))
            }
            
        } catch {
            print(" JSON parsing error: " + error.localizedDescription)
        }
        
        self.delegate?.setNewCompanies(newCompanies: newCompanies)
    }
    
}
