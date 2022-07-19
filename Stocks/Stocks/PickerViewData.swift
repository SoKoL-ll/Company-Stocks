//
//  PickerViewData.swift
//  Stocks
//
//  Created by Alexandr Sokolov on 19.07.2022.
//

import Foundation

protocol PickerViewData: AnyObject {
    func getCompanies() -> [String: String]
    func requestQuoteUpdate()
    func startActiviryIndicator()
}
