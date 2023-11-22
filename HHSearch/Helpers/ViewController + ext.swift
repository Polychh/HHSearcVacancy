//
//  ViewController + ext.swift
//  HHSearch
//
//  Created by Polina on 18.11.2023.
//

import UIKit

extension UIViewController{
    func presentHHAlertOnMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = HHAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
