//
//  HHTipsTableViewCell.swift
//  HHSearch
//
//  Created by Polina on 13.12.2023.
//

import UIKit

final class HHTipsTableViewCell: UITableViewCell {
    
    static let resuseID = "HHTipsTableViewCell"
    
    private let tipsLabel = HHLabel(textAlignment: .left, fontSize: 18, textColor: .label, textStyle: .body)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

//MARK: - Configure Cell UI
extension HHTipsTableViewCell{
    func configureTipsLabel(tipsText: String){
        tipsLabel.text = tipsText
    }
}

//MARK: - Constrains
extension HHTipsTableViewCell{
    private func configure(){
        self.backgroundColor = #colorLiteral(red: 1, green: 0.9607843137, blue: 0.8784313725, alpha: 1)
        addSubview(tipsLabel)
        let padding: CGFloat = 12
        NSLayoutConstraint.activate([
            tipsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            tipsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            tipsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            tipsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding)
        ])
    }
}
