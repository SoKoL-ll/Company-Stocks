//
//  ViewController.swift
//  Stocks
//
//  Created by SoKoL on 13.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var companySymbolName: UILabel!
    @IBOutlet weak var pricelabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    private var companies: [String: String] = [
        "Apple Inc": "AAPL",
        "Microsoft Corporation": "MSFT",
        "Alphabet Inc - Class C": "GOOG",
        "Amazon.com Inc.": "AMZN",
        "Meta Platforms Inc - Class A": "FB",
    ]
    
    private var requester = RequestDataProvider()
    private var mapper = CompanyMapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requester.delegate = self
        mapper.request = requester
        mapper.delegate = self
        requester.mapper = mapper
        requester.requestCompanies()
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        activityIndicator.hidesWhenStopped = true
        requestQuoteUpdate()
    }
    
    func setNewCompanies(newCompanies: [(String, String)]) {
        newCompanies.forEach {
            companies[$0.0] = $0.1
        }
        
        DispatchQueue.main.async {
            self.companyPickerView.reloadAllComponents()
        }
    }
    
    func displayStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double) {
        activityIndicator.stopAnimating()
        companyNameLabel.text = companyName
        companySymbolName.text = symbol
        pricelabel.text = "\(price)"
        priceChangeLabel.text = "\(priceChange)"
        priceChangeLabel.textColor = priceChange < 0 ? .red : .green
    }
    
    private func requestInit() {
        activityIndicator.startAnimating()
        companyNameLabel.text = "-"
        companySymbolName.text = "-"
        pricelabel.text = "-"
        priceChangeLabel.text = "-"
        priceChangeLabel.textColor = .black
        companyImage.isHidden = true
    }
    
    private func requestQuoteUpdate() {
        requestInit()
        let selectedRow = companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(companies.values)[selectedRow]
        requester.requestQuote(for: selectedSymbol)
        requester.setImage(for: selectedSymbol)
    }

}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
    
    //MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activityIndicator.startAnimating()
        self.requestQuoteUpdate()
    }
}
