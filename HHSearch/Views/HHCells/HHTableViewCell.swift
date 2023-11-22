//
//  HHTableViewCell.swift
//  HHSearch
//
//  Created by Polina on 17.11.2023.
//

import UIKit

final class HHTableViewCell: UITableViewCell {

    static let resuseID = "HHTableViewCell"
    
    private let vacancyNameLabel = HHLabel(textAlignment: .left, fontSize: 18, textColor: .label, textStyle: .title3)
    private let salaryLabelFrom = HHLabel(textAlignment: .left, fontSize: 10, textColor: .black, textStyle: .headline)
    private let salaryLabelTo = HHLabel(textAlignment: .left, fontSize: 10, textColor: .black, textStyle: .headline)
    private let currencyLabel = HHLabel(textAlignment: .left, fontSize: 10, textColor: .black, textStyle: .headline)
    private let companyNameLabel = HHLabel(textAlignment: .left, fontSize: 16, textColor: .secondaryLabel, textStyle: .headline)
    private let logoImageView = HHImage(frame: .zero)
    private let requirementLabel = HHLabel(textAlignment: .left, fontSize: 15, textColor: .black, textStyle: .body)
    private let responsibilityLabel = HHLabel(textAlignment: .left, fontSize: 15, textColor: .black, textStyle: .body)
    private let stackViewH = HHStackView(axis: .horizontal, spacing: 0.5, aligment: .top, distribut: .equalSpacing)
    private let stackViewV = HHStackView(axis: .vertical, spacing: 2.0, aligment: .leading, distribut: .equalSpacing)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
    }
}

//MARK: - Configure Cell UI
extension HHTableViewCell{
    func configVacancyName(vacancyName: String){
        vacancyNameLabel.text = vacancyName
    }
    
    func configSalaryFrom(salaryFrom: Int?){
        if let salary = salaryFrom{
            salaryLabelFrom.isHidden = false
            salaryLabelFrom.text = "От \(String(salary))"
        } else{
            salaryLabelFrom.isHidden = true
        }
    }
    
    func configSalaryTo(salaryTo: Int?){
        if let salary = salaryTo{
            salaryLabelTo.isHidden = false
            salaryLabelTo.text = "До \(String(salary))"
        } else{
            salaryLabelTo.isHidden = true
        }
    }
    
    func configureCurrency(currency: String?){
        if let currency = currency{
            currencyLabel.isHidden = false
            currencyLabel.text = currency
        } else{
            currencyLabel.isHidden = true
        }
    }
    
    func configCompanyName(companyName: String){
        companyNameLabel.text = companyName
    }
    
    func configRequirement(requirement: String?){
        if let requirement = requirement{
            requirementLabel.isHidden = false
            let filterRequiment = requirement.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            requirementLabel.text = filterRequiment
        } else{
            requirementLabel.isHidden = true
        }
    }
    
    func configResponsibility(responsibility: String?){
        if let responsibility = responsibility{
            responsibilityLabel.isHidden = false
            let filterResponsobility = responsibility.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            responsibilityLabel.text = filterResponsobility
        } else{
            requirementLabel.isHidden = true
        }
    }
    
    func configlogoImageView(logoImage: UIImage?){
        if let logoImage = logoImage{
            logoImageView.image = logoImage
        } else {
            logoImageView.image = UIImage(named: Constant.defaultImage)
        }
    }
}

//MARK: - Constrains
extension HHTableViewCell{
    private func setStackViews(){
        stackViewH.addArrangedSubview(salaryLabelFrom)
        stackViewH.addArrangedSubview(salaryLabelTo)
        stackViewH.addArrangedSubview(currencyLabel)
        stackViewV.addArrangedSubview(vacancyNameLabel)
        stackViewV.addArrangedSubview(stackViewH)
        stackViewV.addArrangedSubview(companyNameLabel)
        stackViewV.addArrangedSubview(requirementLabel)
        stackViewV.addArrangedSubview(responsibilityLabel)
    }
    
    private func configure(){
        self.backgroundColor = #colorLiteral(red: 1, green: 0.9607843137, blue: 0.8784313725, alpha: 1)
        setStackViews()
        addSubview(logoImageView)
        addSubview(stackViewV)
                  
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor), // set verticaly in the cell
            logoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            stackViewV.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackViewV.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 24),
            stackViewV.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            stackViewV.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
