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
            AppIconBigCell.self, TitleCell.self, CollectionViewContainerCell.self,
            AvailableDeviceScreenShotCell.self, InfoTextCell.self, DescriptionCell.self
        ])

        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                
                print("\(indexPath.item) is Selected...!")
            })
            .disposed(by: disposeBag)
        
        viewModel?.updatedCellVMs
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] cellVMs in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)

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
        
        case _ as AvailableDeviceScreenShotCellViewModel:
            return 60
            
        case _ as InfoTextCellViewModel:
            return 45
            
        case let cellVM as DescriptionCellViewModel:
            // expanded냐 체크 후에 label 높이 계산해서 return
            if cellVM.expandCell {
                guard let height = cellVM.expandedCellHeight else {
                    cellVM.expandedCellHeight = fittedSizeHeight(for: UIScreen.main.bounds.width - 20*2,
                                                                    text: cellVM.description,
                                                                    font: cellVM.descriptionLabelFont)
                    return cellVM.expandedCellHeight ?? 0.0
                }
                
                return height
            } else {
                return 90
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = viewModel?.sections[indexPath.section] else {
            return
        }
        
        let selectedItem = section[indexPath.row]
        switch selectedItem {
        case let cellVM as AvailableDeviceScreenShotCellViewModel:
            if cellVM.ipadScreenShotUrls.isEmpty {
                return
            }
            
            viewModel?.showIpadScreenShotCell(at: indexPath)
//            tableView.performBatchUpdates({
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                tableView.insertRows(at: [
//                    indexPath,
//                    IndexPath(row: indexPath.row + 1, section: indexPath.section),
//                    IndexPath(row: indexPath.row + 2, section: indexPath.section)],
//                                     with: .fade)
//
//            })
            
        case let cellVM as DescriptionCellViewModel:
            cellVM.expandCell = true
            tableView.performBatchUpdates({
                tableView.reloadRows(at: [indexPath], with: .fade)
            })

        default:
            break
        }
    }
    
}

private extension AppInfoViewController {
    func fittedSizeHeight(for width: CGFloat, text: String, font: UIFont) -> CGFloat {
        let labelFrame = CGRect(x: 0, y: 0,
                                width: width,
                                height: 0)
        let label = UILabel(frame: labelFrame)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        let fitted = label.frame
        return fitted.height
    }
}
