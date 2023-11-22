//
//  HHStackView.swift
//  HHSearch
//
//  Created by Polina on 21.11.2023.
//

import UIKit

class HHStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat, aligment: UIStackView.Alignment, distribut: UIStackView.Distribution){
        self.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.alignment = aligment
        self.distribution = distribut
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
    }
}


