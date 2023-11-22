//
//  HHDetailViewController.swift
//  HHSearch
//
//  Created by Polina on 20.11.2023.
//

import UIKit

class HHDetailViewController: UIViewController {
    var presenterHHDetail: HHDetailVCPresenterProtocol!
    
    private let vacancyNameLabel = HHLabel(textAlignment: .center, fontSize: 20, textColor: .black, textStyle: .title2)
    private let salaryFromLabel = HHLabel(textAlignment: .center, fontSize: 10, textColor: .black, textStyle: .headline)
    private let salaryToLabel = HHLabel(textAlignment: .center, fontSize: 10, textColor: .black, textStyle: .headline)
    private let salaryCurrencyLabel = HHLabel(textAlignment: .center, fontSize: 10, textColor: .black, textStyle: .headline)
    private let vacancyDescripLabel = HHLabel(textAlignment: .center, fontSize: 16, textColor: .black, textStyle: .body)
    private let vacancyAddressLabel = HHLabel(textAlignment: .center, fontSize: 16, textColor: .black, textStyle: .headline)
    private let scrollView = HHScrollView(hidden: false)
    private let stackViewH = HHStackView(axis: .horizontal, spacing: 0, aligment: .fill, distribut: .equalSpacing)
    private let stackViewV = HHStackView(axis: .vertical, spacing: 5.0, aligment: .leading, distribut: .equalSpacing)

    override func viewDidLoad() {
        super.viewDidLoad()
        presenterHHDetail.getDetailVacancyInfo()
        setConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5041968226, blue: 0.4857281446, alpha: 1)
    }
}

//MARK: - configUIElements
extension HHDetailViewController{
    private func config<T>(value: T?, label: UILabel, text: String? = nil) {
        if let value = value {
            label.isHidden = false
            label.text = (text ?? "") + " \(String(describing: value))"
        } else {
            label.isHidden = true
        }
    }

    private func configVacancyName(vacancyName: String){
        vacancyNameLabel.text = vacancyName
    }
    
    private func configureVacancyDescript(description: String?){
        if let description = description{
            vacancyDescripLabel.isHidden = false
            let filterDescription = description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            vacancyDescripLabel.text = filterDescription
        } else{
            vacancyDescripLabel.isHidden = true
        }
    }
}

//MARK: - HHDetailVCProtocol
extension HHDetailViewController: HHDetailVCProtocol{
    func alertMessageNetwork(text: String) {
        presentHHAlertOnMainThread(title: Constant.titleNetwork, message: text, buttonTitle: Constant.ok)
    }
    
    func configUI() {
        DispatchQueue.main.async{
            guard let vacancyInfo = self.presenterHHDetail.detailVacancyInfo else {return}
            self.configVacancyName(vacancyName: vacancyInfo.name)
            self.config(value: self.presenterHHDetail.from, label: self.salaryFromLabel, text: "От")
            self.config(value: self.presenterHHDetail.to, label: self.salaryToLabel, text: "До")
            self.config(value: self.presenterHHDetail.currency, label: self.salaryCurrencyLabel)
            self.configureVacancyDescript(description: vacancyInfo.description)
            self.config(value: vacancyInfo.address?.raw, label: self.vacancyAddressLabel)
        }
    }
}

//MARK: - Layout
extension HHDetailViewController{
    private func setConstrains(){
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9607843137, blue: 0.8784313725, alpha: 1)
        setStackViews()
        view.addSubview(scrollView)
        scrollView.addSubview(stackViewV)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackViewV.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stackViewV.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            stackViewV.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackViewV.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            stackViewV.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),
        ])
    }
    
    private func setStackViews(){
        stackViewH.addArrangedSubview(salaryFromLabel)
        stackViewH.addArrangedSubview(salaryToLabel)
        stackViewH.addArrangedSubview(salaryCurrencyLabel)
        
        stackViewV.addArrangedSubview(vacancyNameLabel)
        stackViewV.addArrangedSubview(stackViewH)
        stackViewV.addArrangedSubview(vacancyDescripLabel)
        stackViewV.addArrangedSubview(vacancyAddressLabel)
    }
}
