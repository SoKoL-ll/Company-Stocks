//
//  PickerViewDelegate.swift
//  Stocks
//
//  Created by Alexandr Sokolov on 19.07.2022.
//

import Foundation
import UIKit

class PickerViewDelegate: NSObject, UIPickerViewDelegate {
    
    weak var getData: PickerViewData?
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let keys = getData?.getCompanies().keys else { return "" }
        
        return Array(keys)[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getData?.startActiviryIndicator()
        getData?.requestQuoteUpdate()
    }
}
