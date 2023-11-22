//
//  HHVCPresenter.swift
//  HHSearch
//
//  Created by Polina on 20.11.2023.
//

import Foundation

protocol HHVCProtocol: AnyObject{
    func updateTableView()
    func alertMessageValidate()
    func alertMessageNetwork(text: String)
    func alerMessageEndPages()
    func emptyVacanciesArray()
    func reloadTableView()
}

protocol HHVCPresenterProtocol:AnyObject{
    init(network: Network, view: HHVCProtocol?, router: HHRouterProtocol)
    var vacanciesArray: [Item] {get set}
    var isLoadingMoreVacancies: Bool {get set}
    var currentPage: Int {get set}
    var searchWord: String {get set}
    var networService: Network {get}
    func getVacancies(vacancyName: String, page: Int)
    func validateTextField(text: String) -> Bool
    func incrementPage()
    func cleanVacancyArray()
    func nilCurrentPage()
    func tapOnVacancy(from: Int?, to: Int?, currency: String?, id: String)
}

final class HHVCPresenter: HHVCPresenterProtocol{
    
    let networService: Network
    weak var viewHH: HHVCProtocol?
    var router: HHRouterProtocol?
    var vacanciesArray = [Item]()
    var isLoadingMoreVacancies = false
    var currentPage = 0
    var searchWord = ""
    private let locker = NSLock()
    
    init(network: Network, view: HHVCProtocol?,router: HHRouterProtocol ) {
        self.networService = network
        self.viewHH = view
        self.router = router
    }
    
    func getVacancies(vacancyName: String, page: Int) {
        loadVacancies(text: vacancyName, page: page)
    }
    
    func incrementPage(){
        currentPage += 1
    }
    
    func validateTextField(text: String) -> Bool{
        handleSearchTextField(text: text)
    }
    
    func cleanVacancyArray(){
        vacanciesArray = []
    }
    
    func nilCurrentPage() {
        currentPage = 0
    }
    
    func tapOnVacancy(from: Int?, to: Int?, currency: String?, id: String) {
        router?.showHHDetailViewController(from: from, to: to, currency: currency, id: id)
    }
}
//MARK: - Loading VacanciesInfo
extension HHVCPresenter{
    private func loadVacancies(text: String, page: Int){
        isLoadingMoreVacancies = true
        searchWord = text
        networService.getVacanciesInfo(for: text, page: page) { [weak self] results in
            guard let self = self else { return }
            if currentPage > networService.allPages{
                viewHH?.alerMessageEndPages()
            }else{
                switch results{
                case .success(let result):
                    locker.lock()
                    self.vacanciesArray.append(contentsOf: result)
                    locker.unlock()
                    if vacanciesArray.isEmpty{
                        viewHH?.emptyVacanciesArray()
                        viewHH?.reloadTableView()
                    } else{
                        viewHH?.updateTableView()
                    }
                case .failure(let error):
                    viewHH?.alertMessageNetwork(text: error.rawValue)
                }
            }
            isLoadingMoreVacancies = false
        }
    }
}
//MARK: - Validating UITextField
extension HHVCPresenter{
    private func handleSearchTextField(text: String) -> Bool{
        switch text.isEmpty {
        case false:
            if text.count >= Constant.validateNumber {
                return true
            } else {
                break
            }
        case true:
            viewHH?.alertMessageValidate()
            return false
        }
        return false
    }
}

