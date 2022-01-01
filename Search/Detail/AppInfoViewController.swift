//
//  AppInfoViewController.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit
import RxSwift

class AppInfoViewController: UIViewController {
    var viewModel: AppInfoViewModel?
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    static func create(result: SearchResult) -> AppInfoViewController {
        let sb = UIStoryboard(name: "Detail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AppInfoViewController") as! AppInfoViewController
        vc.viewModel = AppInfoViewModel(result)
        return vc
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


private extension AppInfoViewController {
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(cells: [
            AppIconBigCell.self, TitleCell.self, CollectionViewContainerCell.self
        ])

        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                
                print("\(indexPath.item) is Selected...!")
            })
            .disposed(by: disposeBag)
        
//        viewModel.updatedCellVMs
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [weak self] cellVMs in
//                self?.tableView.reloadData()
//            }).disposed(by: disposeBag)
//
//        viewModel.searchHistory(.all)
    }
}

extension AppInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.sections[section].count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel?.sections[indexPath.section] else { return UITableViewCell() }
        return tableView.resolveCell(section[indexPath.row], indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = viewModel?.sections[indexPath.section] else {
            return 0
        }
        
        switch section[indexPath.row] {
        case _ as AppIconBigCellViewModel:
            return 130
            
        case _ as TitleCellViewModel:
            return 45
            
        case let cellVM as CollectionViewContainerCellViewModel:
            return cellVM.cellSize.height
        default:
            return 0
        }
    }
    
}
