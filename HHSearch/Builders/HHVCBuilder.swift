//
//  HHVCBuilder.swift
//  HHSearch
//
//  Created by Polina on 21.11.2023.
//

import UIKit

protocol BuilderProtocol{
    func createHHViewController(router: HHRouterProtocol) -> UIViewController
    func createDetailHHView(from: Int?, to: Int?, currency: String?, id: String) -> UIViewController
}

final class HHVCBuilder: BuilderProtocol{
    func createHHViewController(router: HHRouterProtocol) -> UIViewController {
        let view = HHViewController()
        let networkService = NetworkService()
        let presenter = HHVCPresenter(network: networkService, view: view, router: router)
        view.presenterHH = presenter
        return view
    }
    
    func createDetailHHView(from: Int?, to: Int?, currency: String?, id: String) -> UIViewController {
       let view = HHDetailViewController()
       let networkService = NetworkService()
       let presenter = HHDetailVCPresenter(from: from, to: to, currency: currency, id: id, detailView: view, network: networkService)
       view.presenterHHDetail = presenter
       return view
   }
}
