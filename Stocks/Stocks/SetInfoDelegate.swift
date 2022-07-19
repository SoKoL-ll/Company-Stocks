//
//  SetInformation.swift
//  Stocks
//
//  Created by Alexandr Sokolov on 18.07.2022.
//

import Foundation
import UIKit

protocol SetInfoDelegate: UIViewController {
    func displayStockInfo(companyInfo: StockInformation)
    func setNewCompanies(newCompanies: [CompanyInformation])
    func setImage(data: Data)
}
