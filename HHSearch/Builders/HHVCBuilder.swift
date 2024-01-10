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
        let networkService = DefaultNetworkService()
        let imageDownload = ImageClient()
        let presenter = HHVCPresenter(network: networkService, imageDownload: imageDownload, router: router)
        let view = HHViewController(presenter: presenter)
        presenter.viewHH = view
        view.presenterHH = presenter
        return view
    }
    
    func createDetailHHView(from: Int?, to: Int?, currency: String?, id: String) -> UIViewController {
        let networkService = DefaultNetworkService()
       let presenter = HHDetailVCPresenter(from: from, to: to, currency: currency, id: id, network: networkService)
       let view = HHDetailViewController(presenter: presenter)
       presenter.detailView = view
       view.presenterHHDetail = presenter
       return view
   }
}
