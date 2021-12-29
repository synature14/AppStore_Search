//
//  MainViewController.swift
//  Search
//
//  Created by SutieDev on 2021/12/28.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    let searchController = UISearchController()
    private let searchVM = SearchViewModel()
    
    private var disposeBag = DisposeBag()
    
 
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBindings()
        setTableView()
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}


private extension MainViewController {
    func setUI() {
        self.searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        self.searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        navigationItem.title = "검색"
        navigationItem.searchController = searchController
    }
    
    func setBindings() {
       searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: self.searchVM.searchText)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let text = self?.searchController.searchBar.text else { return }
                self?.searchVM.requestKeyword.onNext(text)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func setTableView() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.register(UINib(nibName: RecentSearchHistoryCell.name, bundle: nil),
                           forCellReuseIdentifier: RecentSearchHistoryCell.name)
        tableView.register(UINib(nibName: SearchingResultCell.name, bundle: nil),
                           forCellReuseIdentifier: SearchingResultCell.name)
        tableView.register(UINib(nibName: NoResultsCell.name, bundle: nil),
                           forCellReuseIdentifier: NoResultsCell.name)
        
        searchVM.updatedCellVMs
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items) { (tableView, indexPathRow, cellType) in
                let indexPath = IndexPath(item: indexPathRow, section: 0)
                
                switch cellType {
                case .allResultsCell(let cellVM):
                    if let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchHistoryCell.name, for: indexPath) as? RecentSearchHistoryCell {
                        cell.setData(cellVM)
                        return cell
                    }
                    
                case .searchResultsCell(let cellVM):
                    if let cell = tableView.dequeueReusableCell(withIdentifier: SearchingResultCell.name, for: indexPath) as? SearchingResultCell {
                        cell.setData(cellVM)
                        return cell
                    }
                    
                case .noResultsCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: NoResultsCell.name, for: indexPath) as? NoResultsCell {
                        return cell
                    }
                }
                
                return UITableViewCell()
            }
            .disposed(by: disposeBag)
        
        searchVM.recentSearchHistory(.all)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("[selected] \(indexPath.row)")
    }
}




