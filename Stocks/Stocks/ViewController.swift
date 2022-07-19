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
    private var pickerViewDataSource = PickerViewDataSource()
    private var pickerViewDelegate = PickerViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requester.delegate = self
        mapper.request = requester
        mapper.delegate = self
        requester.mapper = mapper
        requester.requestCompanies()
        pickerViewDelegate.getData = self
        pickerViewDataSource.getData = self
        companyPickerView.dataSource = pickerViewDataSource
        companyPickerView.delegate = pickerViewDelegate
        activityIndicator.hidesWhenStopped = true
        requestQuoteUpdate()
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

}


extension ViewController: SetInfoDelegate {
    
    func setNewCompanies(newCompanies: [CompanyInformation]) {
        newCompanies.forEach {
            companies[$0.companyName] = $0.symbol
        }
        
        DispatchQueue.main.async {
            self.companyPickerView.reloadAllComponents()
        }
    }
    
    func displayStockInfo(companyInfo: StockInformation) {
        activityIndicator.stopAnimating()
        companyNameLabel.text = companyInfo.companyName
        companySymbolName.text = companyInfo.symbol
        pricelabel.text = "\(companyInfo.latestPrice)"
        priceChangeLabel.text = "\(companyInfo.change)"
        priceChangeLabel.textColor = companyInfo.change < 0 ? .red : .green
    }
    
    func setImage(data: Data) {
        companyImage.image = UIImage(data: data)
        companyImage.isHidden = false
    }
}

extension ViewController: PickerViewData {
    
    func getCompanies() -> [String: String] {
        return companies
    }
    
    func requestQuoteUpdate() {
        requestInit()
        let selectedRow = companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(companies.values)[selectedRow]
        requester.requestQuote(for: selectedSymbol)
        requester.setImage(for: selectedSymbol)
    }
    
    func startActiviryIndicator() {
        activityIndicator.startAnimating()
    }
    
}
