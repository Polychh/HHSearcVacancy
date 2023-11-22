//
//  HHImage.swift
//  HHSearch
//
//  Created by Polina on 17.11.2023.
//

import UIKit

final class HHImage: UIImageView {

    override init(frame: CGRect)  {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 15
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
