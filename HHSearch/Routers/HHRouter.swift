//
//  HHRouter.swift
//  HHSearch
//
//  Created by Polina on 21.11.2023.
//

import UIKit

protocol HHRouterProtocolMain{
    var navigationController: UINavigationController? {get set}
    var builder: BuilderProtocol? {get set}
}

protocol HHRouterProtocol: HHRouterProtocolMain{
    func initialHhViewController()
    func showHHDetailViewController(from: Int?, to: Int?, currency: String?, id: String)
}

final class HHRouter: HHRouterProtocol{
    var navigationController: UINavigationController?
    var builder: BuilderProtocol?
    
    init(navigationController: UINavigationController, builder: BuilderProtocol) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func initialHhViewController() {
        if let navVC = navigationController{
            guard let mainHHVC = builder?.createHHViewController(router: self) else {return}
            navVC.viewControllers = [mainHHVC]
        }
    }
    
    func showHHDetailViewController(from: Int?, to: Int?, currency: String?, id: String) {
        if let navVC = navigationController{
            guard let detailHHVC = builder?.createDetailHHView(from: from, to: to, currency: currency, id: id) else {return}
            navVC.pushViewController(detailHHVC, animated: true)
        }
    }
}
