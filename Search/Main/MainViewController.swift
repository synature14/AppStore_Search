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
    
    private let viewModel = SearchViewModel()
    private var disposeBag = DisposeBag()
    
 
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBindings()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
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
            .subscribe(onNext: { [weak self] searchText in
                self?.viewModel.searchText.onNext(searchText)
            })
            .disposed(by: disposeBag)

        // 검색버튼
        searchController.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let text = self?.searchController.searchBar.text else { return }
                self?.viewModel.search(text)
            })
            .disposed(by: disposeBag)
        
        // 취소버튼
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.viewModel.searchHistory(.all)
            }).disposed(by: disposeBag)
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(cells: [
            RecentSearchHistoryCell.self, SearchingResultCell.self, NoResultsCell.self, PortaitScreenShotCell.self, LandscapeScreenShotCell.self, AppIconCell.self, ActivityViewCell.self
        ])
        
        // 검색어 request에 대한 응답값으로 tableView 리로드
        viewModel.updateCellVMs
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] cellVMs in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.searchHistory(.all)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = viewModel.sections[indexPath.section]
        return tableView.resolveCell(sections[indexPath.row], indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sections = viewModel.sections[indexPath.section]
        let cellVM = sections[indexPath.row]
        
        switch cellVM {
        case _ as RecentSearchHistoryCellViewModel: // 검색어 히스토리 띄우는 셀
            return 50.0
        
        case _ as SearchingResultCellViewModel:     // 검색어 타이핑할 때 띄우는 셀
            return 44.0
        
        case _ as ActivityViewModel:                // activityIndicatorView 띄우는 셀
            return UIScreen.main.bounds.height / 3
            
        case _ as NoResultsCellViewModel:           // 해당되는 검색어 히스토리가 없을 때 띄우는 셀
            return UIScreen.main.bounds.height / 3
            
        case _ as AppIconCellViewModel:
            return 60.0
            
        case let portaitCellVM as PortaitCellViewModel:
            let imageSize = portaitCellVM.imageSize
            
            return scaledPortraitHeight(padding: 20*2,
                                        originalImageSize: imageSize) + 40
            
        case let landscapeCellVM as LandscapeCellViewModel:
            let imageSize = landscapeCellVM.imageSize
            return scaledLandscapeHeight(padding: 20*2,
                                         originalImageSize: imageSize) + 30
            
        default:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = viewModel.sections[indexPath.section][indexPath.item]
        var result: SearchResult
        
        switch selectedItem {
        case let recentSearchCellVM as RecentSearchHistoryCellViewModel:
            let word = recentSearchCellVM.item.word ?? ""
            searchController.searchBar.text = word
            viewModel.search(word)
            return
            
        case let searchingCellVM as SearchingResultCellViewModel:
            let word = searchingCellVM.item.word ?? ""
            searchController.searchBar.text = word
            viewModel.search(word)
            return
            
        case let appInfoVM as AppIconCellViewModel:
            result = appInfoVM.searchResult
            
        case let screenShotVM as LandscapeCellViewModel:
            result = screenShotVM.searchResult
            
        case let screenShotVM as PortaitCellViewModel:
            result = screenShotVM.searchResult
        default:
            return
        }
        
        let vc = AppInfoViewController.create(result: result)
        self.navigationController?.pushViewController(vc, animated: true)
    }
                
}

private extension MainViewController {
    func scaledLandscapeHeight(padding leadingTrailing: CGFloat, originalImageSize: CGSize) -> CGFloat {
        let resizedWidth = UIScreen.main.bounds.width - leadingTrailing
        let imageViewScaledHeight = originalImageSize.height * resizedWidth / originalImageSize.width
        return imageViewScaledHeight
    }

    func scaledPortraitHeight(padding leadingTrailing: CGFloat, originalImageSize: CGSize) -> CGFloat {
        let stackViewSpacing: CGFloat = 6.0
        let eachImageViewWidth = CGFloat(UIScreen.main.bounds.width - leadingTrailing - stackViewSpacing*2) / 3
        let imageViewScaledHeight = originalImageSize.height * eachImageViewWidth / originalImageSize.width
        return imageViewScaledHeight
    }
}

