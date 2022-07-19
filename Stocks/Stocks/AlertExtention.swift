//
//  AlertExtention.swift
//  Stocks
//
//  Created by Alexandr Sokolov on 11.07.2022.
//

import Foundation
import UIKit

extension UIAlertController {
    static func networkAlert(from controller: UIViewController?) {
        let alert = UIAlertController(title: "Network error", message: "Restart the application with the internet connected", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Enter", style: .cancel, handler: nil))
        controller?.present(alert, animated: true)
    }
    
    static func jsonAlert(from controller: UIViewController?, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Enter", style: .cancel, handler: nil))
        controller?.present(alert, animated: true)
    }
}
