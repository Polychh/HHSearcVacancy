//
//  ViewController.swift
//  HHSearch
//
//  Created by Polina on 17.11.2023.
//

import UIKit
import Combine

final class HHViewController: UIViewController {
    
    var presenterHH: HHVCPresenterProtocol!
    
    private let searchTextField = HHTextField()
    private let tableView = UITableView()
    private var timerCombine: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureTableView()
        setConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

//MARK: - Configure CombineTimer
extension HHViewController{
    private func configureCombineTimer(){
        timerCombine = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink {[weak self] _ in
                guard let self = self else {return}
                if searchTextField.text!.count >= Constant.validateNumber{
                    searchTextField.resignFirstResponder()
                }
        }
    }
}

//MARK: - Configure TextField
extension HHViewController{
    private func configureTextField(){
        searchTextField.delegate = self
    }
}
//MARK: - Configure TableView
extension HHViewController{
    private func scrollToTop() {
        let topRow = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
    
    private func configureTableView() {
        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.9607843137, blue: 0.8784313725, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HHTableViewCell.self, forCellReuseIdentifier: HHTableViewCell.resuseID)
    }
}

//MARK: - UITextFieldDelegate
extension HHViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return presenterHH.validateTextField(text: textField.text!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        configureCombineTimer()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        timerCombine = nil
        presenterHH.nilCurrentPage()
        presenterHH.cleanVacancyArray()
        presenterHH.getVacancies(vacancyName: textField.text!, page: presenterHH.currentPage)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension HHViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenterHH.vacanciesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HHTableViewCell.resuseID, for: indexPath) as? HHTableViewCell else {
            return UITableViewCell()
        }
        
        let vacancyInfo = presenterHH.vacanciesArray[indexPath.row]
        cell.configVacancyName(vacancyName: vacancyInfo.name)
        cell.configSalaryFrom(salaryFrom: vacancyInfo.salary?.from)
        cell.configSalaryTo(salaryTo: vacancyInfo.salary?.to)
        cell.configureCurrency(currency: vacancyInfo.salary?.currency)
        cell.configCompanyName(companyName: vacancyInfo.employer.name)
        cell.configRequirement(requirement: vacancyInfo.snippet?.requirement)
        cell.configResponsibility(responsibility: vacancyInfo.snippet?.responsibility)
        presenterHH.networService.downloadImage(with: vacancyInfo.employer.logoUrls?.imageUrl ?? Constant.defaultURL) {result in
            switch result{
            case .success(let image):
                cell.configlogoImageView(logoImage: image)
            case .failure(let error):
                print(error.rawValue)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vacancyInfo = presenterHH.vacanciesArray[indexPath.row]
        presenterHH.tapOnVacancy(from: vacancyInfo.salary?.from, to: vacancyInfo.salary?.to, currency: vacancyInfo.salary?.currency, id: vacancyInfo.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenterHH.vacanciesArray.count - Constant.lastFiveVacancy{
            guard !presenterHH.isLoadingMoreVacancies else {return}
            presenterHH.incrementPage()
            presenterHH.getVacancies(vacancyName: presenterHH.searchWord, page: presenterHH.currentPage)
        }
    }
}

//MARK: - HHVCProtocol
extension HHViewController: HHVCProtocol {
    func reloadTableView() {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func emptyVacanciesArray() {
        presentHHAlertOnMainThread(title: Constant.titleEmptyArray, message: Constant.alertMassageEmptyArray, buttonTitle: Constant.ok)
        DispatchQueue.main.async() {
            self.searchTextField.text = ""
        }
    }
    
    func alerMessageEndPages() {
        presentHHAlertOnMainThread(title: Constant.titleEndPages, message: Constant.alertMessageEndPages, buttonTitle: Constant.ok)
    }
    
    func alertMessageNetwork(text: String) {
        presentHHAlertOnMainThread(title: Constant.titleNetwork, message: text, buttonTitle: Constant.ok)
    }
    
    func alertMessageValidate() {
        presentHHAlertOnMainThread(title: Constant.titleEmptyTextField, message: Constant.alertMessageEmptyTextField, buttonTitle: Constant.ok)
    }
    
    func updateTableView() {
        DispatchQueue.main.async{
            self.tableView.reloadData()
            if self.presenterHH.currentPage == 0{
                self.scrollToTop()
            }
        }
    }
}

//MARK: - Layout
extension HHViewController{
    private func setConstrains(){
        view.backgroundColor = #colorLiteral(red: 1, green: 0.5041968226, blue: 0.4857281446, alpha: 1)
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.heightAnchor.constraint(equalToConstant: 70),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0), 
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
}

