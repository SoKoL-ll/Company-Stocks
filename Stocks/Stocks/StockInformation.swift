//
//  CompanyInformation.swift
//  Stocks
//
//  Created by Alexandr Sokolov on 18.07.2022.
//

import Foundation

class StockInformation: Codable {
    let companyName: String
    let symbol: String
    let latestPrice: Double
    let change: Double
}
