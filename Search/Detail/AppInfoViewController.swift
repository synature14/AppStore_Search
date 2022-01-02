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
        
        viewModel?.updateCellVMs
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
        if let cellVM = section[indexPath.row] as? AppIconBigCellViewModel {
            cellVM.delegate = self
        }
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
            switch cellVM.type {
            case .BadgeCell:
                return 76
                
            case .iPhonePreviewCell:
                guard let imageURL = cellVM.searchResult?.screenshotUrls.first else { return 0 }
                let cellSize = cellSize(imageURL)
                return cellSize.height
                
            case .iPadPreviewCell:
                guard let imageURL = cellVM.searchResult?.ipadScreenshotUrls.first else { return 0 }
                let cellSize = cellSize(imageURL)
                return cellSize.height
            }
        
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
    
    func cellSize(_ imageURL: String) -> CGSize {
        let originalSize = imageURL.size
        let cellSize = imageURL.isLandscape ? scaledSizeForLandscape(originalSize) : scaledSizeForPortrait(originalSize)
        return cellSize
    }
    
    // collectionView 좌우 패딩 = 20
    func scaledSizeForPortrait(_ originalImageSize: CGSize) -> CGSize {
        let resizedWidth = (UIScreen.main.bounds.width - 20*2) * 0.76
        let imageViewScaledHeight = originalImageSize.height * resizedWidth / originalImageSize.width
        return CGSize(width: resizedWidth, height: imageViewScaledHeight)
    }
    
    func scaledSizeForLandscape(_ originalImageSize: CGSize) -> CGSize {
        let resizedWidth = (UIScreen.main.bounds.width - 20*2)
        let imageViewScaledHeight = originalImageSize.height * resizedWidth / originalImageSize.width
        return CGSize(width: resizedWidth, height: imageViewScaledHeight)
    }
}

extension AppInfoViewController: AppIconBigCellVMProtocol {
    func didShareButtonTapped(_ downloadURL: String) {
        let vc = UIActivityViewController(activityItems: [URL(string: downloadURL)], applicationActivities: nil)
        vc.excludedActivityTypes = [.addToReadingList, .assignToContact]
        self.present(vc, animated: true, completion: nil)
    }
}
