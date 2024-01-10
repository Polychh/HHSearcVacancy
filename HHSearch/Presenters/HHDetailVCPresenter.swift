//
//  HHDetailVCPresenter.swift
//  HHSearch
//
//  Created by Polina on 21.11.2023.
//

import Foundation

protocol HHDetailVCProtocol:AnyObject{
    func configUI()
    func alertMessageNetwork(text: String)
}

protocol HHDetailVCPresenterProtocol: AnyObject{
    var from: Int? {get set}
    var to: Int? {get set}
    var currency: String? {get set}
    var id: String {get set}
    var detailVacancyInfo: HHDetailModel? {get set}
    func getDetailVacancyInfo()
}

final class HHDetailVCPresenter: HHDetailVCPresenterProtocol{

    weak var detailView: HHDetailVCProtocol?
    var detailVacancyInfo: HHDetailModel?
    var from: Int?
    var to: Int?
    var currency: String?
    var id: String
    private let networService: Network
    private let locker = NSLock()
    
    init(from: Int?, to: Int?, currency: String?, id: String, network: Network) {
        self.from = from
        self.to = to
        self.currency = currency
        self.id = id
        self.networService = network
    }
    func getDetailVacancyInfo(){
        loadDetailVacancyInfo()
    }
}

//MARK: - Loading DetailVacancyInfo
extension HHDetailVCPresenter{
    private func loadDetailVacancyInfo(){
        let request = DetailInfoRequest(id: id)
        networService.request(request) {[weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let result):
                locker.lock()
                self.detailVacancyInfo = result
                locker.unlock()
                detailView?.configUI()
            case .failure(let error):
                detailView?.alertMessageNetwork(text: error.rawValue)
            }
        }
    }
}
