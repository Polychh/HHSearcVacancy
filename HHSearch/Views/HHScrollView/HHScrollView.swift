//
//  HHScrollView.swift
//  HHSearch
//
//  Created by Polina on 20.11.2023.
//

import UIKit

class HHScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init( hidden: Bool){
        self.init(frame: .zero)
        self.isHidden = hidden
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
