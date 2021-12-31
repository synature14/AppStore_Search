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
            .bind(to: self.viewModel.searchText)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let text = self?.searchController.searchBar.text else { return }
                self?.viewModel.search(text)
            })
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(cells: [
            RecentSearchHistoryCell.self, SearchingResultCell.self, NoResultsCell.self, PortaitScreenShotCell.self, LandscapeScreenShotCell.self, AppIconCell.self
        ])

        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print("\(indexPath.item) is Selected...!")
            })
            .disposed(by: disposeBag)
        
        viewModel.updatedCellVMs
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
        case _ as AppIconCellViewModel:
            return 50.0
            
        case let portaitCellVM as PortaitCellViewModel:
            let imageHeight = portaitCellVM.imageSize.height
            
            return scaledPortraitHeight(padding: 20*2,
                                     originImageHeight: imageHeight) + 50.0
            
        case let landscapeCellVM as LandscapeCellViewModel:
            return scaledLandscapeHeight(padding: 20*2,
                                     originImageHeight: landscapeCellVM.imageSize.height) + 10.0
            
        default:
            return 0.0
        }
    }
                
}

private extension MainViewController {
    func scaledLandscapeHeight(padding leadingTrailing: CGFloat, originImageHeight: CGFloat) -> CGFloat {
        let resizedWidth = UIScreen.main.bounds.width - leadingTrailing
        let imageViewScaledHeight = originImageHeight * resizedWidth / resizedWidth
        return imageViewScaledHeight
    }
    
    func scaledPortraitHeight(padding leadingTrailing: CGFloat, originImageHeight: CGFloat) -> CGFloat {
        let eachImageViewWidth = CGFloat(UIScreen.main.bounds.width - leadingTrailing / 3)
        let imageViewScaledHeight = originImageHeight * eachImageViewWidth / eachImageViewWidth
        return imageViewScaledHeight
    }
}




