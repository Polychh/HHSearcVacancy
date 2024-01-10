//
//  HHVCPresenter.swift
//  HHSearch
//
//  Created by Polina on 20.11.2023.
//

import Foundation

protocol HHVCProtocol: AnyObject{
    func updateTableView()
    func updateTipsTableView()
    func alertMessageValidate()
    func alertMessageNetwork(text: String)
    func alerMessageEndPages()
    func emptyVacanciesArray()
    func reloadTableView()
}

protocol HHVCPresenterProtocol: AnyObject{
    init(network: Network, imageDownload: NetworkImageClient, router: HHRouterProtocol)
    var vacanciesArray: [Item] {get set}
    var tipsArray: [TipsItem] {get set}
    var isLoadingMoreVacancies: Bool {get set}
    var currentPage: Int {get set}
    var searchWord: String {get set}
    var networService: Network {get}
    var imageDownload: NetworkImageClient {get}
    func getVacancies(vacancyName: String, page: Int)
    func getTips(tipsText: String)
    func validateTextField(text: String) -> Bool
    func incrementPage()
    func cleanVacancyArray()
    func nilCurrentPage()
    func tapOnVacancy(from: Int?, to: Int?, currency: String?, id: String)
}

final class HHVCPresenter: HHVCPresenterProtocol{
    let networService: Network
    let imageDownload: NetworkImageClient
    weak var viewHH: HHVCProtocol?
    var router: HHRouterProtocol?
    var vacanciesArray = [Item]()
    var tipsArray = [TipsItem]()
    var isLoadingMoreVacancies = false
    var currentPage = 0
    var searchWord = ""
    private let locker = NSLock()
    private var allPages = 0
    
    init(network: Network, imageDownload: NetworkImageClient, router: HHRouterProtocol ) {
        self.networService = network
        self.imageDownload = imageDownload
        self.router = router
    }
    
    func getVacancies(vacancyName: String, page: Int) {
        loadVacancies(text: vacancyName, page: page)
    }
    
    func getTips(tipsText: String){
        loadTips(tips: tipsText)
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
        let request = VacancyInfoRequest(word: text, page: page)
        networService.request(request) { [weak self] result in
            guard let self = self else { return }
            if currentPage > allPages{
                viewHH?.alerMessageEndPages()
            }else{
                switch result{
                case .success(let result):
                    locker.lock()
                    self.vacanciesArray.append(contentsOf: result.items)
                    self.allPages = result.pages
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
//MARK: - Loading Tips
extension HHVCPresenter{
    private func loadTips(tips: String){
        tipsArray = []
        let request = TipsRequest(word: tips)
        networService.request(request) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let result):
                locker.lock()
                tipsArray.append(contentsOf: result.items)
                locker.unlock()
                if !tipsArray.isEmpty{
                    viewHH?.updateTipsTableView()
                }
                
            case .failure(let error):
                print(error.rawValue)
            }
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

