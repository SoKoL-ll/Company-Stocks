//
//  ViewController.swift
//  Stocks
//
//  Created by SoKoL on 13.02.2022.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    
    
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var companySymbolName: UILabel!
    @IBOutlet weak var pricelabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    private var companies: [String : String] = ["Apple Inc": "AAPL",
                                                "Microsoft Corporation": "MSFT",
                                                "Alphabet Inc - Class C": "GOOG",
                                                "Amazon.com Inc.": "AMZN",
                                                "Meta Platforms Inc - Class A": "FB"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestCompanies()
        self.companyPickerView.dataSource = self
        self.companyPickerView.delegate = self
        self.activityIndicator.hidesWhenStopped = true
        self.requestQuoteUpdate()
    }
    
    private func requestCompanies() {
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/gainers?&token=pk_1b0b1154ec5d4ecfa2eb73a48c692401")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Network error", message: "Restart the application with the internet connected", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Enter", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }
            
            self.parseCompanies(data: data)
            DispatchQueue.main.async {
                self.companyPickerView.reloadAllComponents()
            }
            
        }
        dataTask.resume()
    }
    private func parseCompanies(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard
                let json = jsonObject as? [[String: Any]]
            else {
                print("Invalid JSON format")
                return
            }
            for item in json {
                guard
                    let company = item["companyName"] as? String,
                    let symbol = item["symbol"] as? String
                    
                else {
                    print("Invalid JSON format")
                    return
                }
                companies[company] = symbol
            }
        } catch {
            print(" JSON parsing error: " + error.localizedDescription)
        }
    }
    private func requestQuote(for symbol: String) {
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?&token=pk_1b0b1154ec5d4ecfa2eb73a48c692401")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Network error", message: "Restart the application with the internet connected", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Enter", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }
            
            self.parseQuote(data: data)
        }
        
        dataTask.resume()
    }
    
    private func setImage(for symbol: String) {
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/logo?&token=pk_1b0b1154ec5d4ecfa2eb73a48c692401")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Network error", message: "Restart the application with the internet connected", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }
            self.getURLImage(data: data)
        }
        dataTask.resume()
    }
    
    private func getURLImage(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard
                let json = jsonObject as? [String: Any],
                let url = json["url"] as? String
            else {
                print("Invalid JSON format")
                return
            }
            self.downloadImage(url: url)
        } catch {
            print(" JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func downloadImage(url: String) {
        let finalURL = URL(string: url)!
        DispatchQueue.global().async {
                if let data = try? Data(contentsOf: finalURL) {
                    DispatchQueue.main.async {
                        self.companyImage.image = UIImage(data: data)
                        self.companyImage.isHidden = false
                    }
                }
            }
    }
    private func parseQuote(data: Data) {
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
                self.displayStockInfo(companyName: companyName,
                                      symbol: companySymbol,
                                      price: price,
                                      priceChange: priceChange)
            }
        } catch {
            print(" JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func displayStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double) {
        self.activityIndicator.stopAnimating()
        self.companyNameLabel.text = companyName
        self.companySymbolName.text = symbol
        self.pricelabel.text = "\(price)"
        self.priceChangeLabel.text = "\(priceChange)"
        self.priceChangeLabel.textColor = priceChange < 0 ? .red : .green
    }
    
    private func requestInit() {
        self.activityIndicator.startAnimating()
        self.companyNameLabel.text = "-"
        self.companySymbolName.text = "-"
        self.pricelabel.text = "-"
        self.priceChangeLabel.text = "-"
        self.priceChangeLabel.textColor = .black
        self.companyImage.isHidden = true
    }
    
    private func requestQuoteUpdate() {
        requestInit()
        let selectedRow = self.companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(self.companies.values)[selectedRow]
        self.requestQuote(for: selectedSymbol)
        self.setImage(for: selectedSymbol)
    }

}

