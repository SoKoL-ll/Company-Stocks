//
//  DataSource.swift
//  Stocks
//
//  Created by Alexandr Sokolov on 19.07.2022.
//

import Foundation
import UIKit

class PickerViewDataSource: NSObject, UIPickerViewDataSource {
    
    weak var getData: PickerViewData?

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return getData?.getCompanies().keys.count ?? 0
    }
    
}
