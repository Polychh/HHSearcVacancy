//
//  HHCellLabel.swift
//  HHSearch
//
//  Created by Polina on 17.11.2023.
//

import UIKit

final class HHLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, textColor: UIColor, textStyle: UIFont.TextStyle){
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        self.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
    
    private func configure(){
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        translatesAutoresizingMaskIntoConstraints = false
    }
}


