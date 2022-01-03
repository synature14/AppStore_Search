//
//  AppInfoViewModel.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

class AppInfoViewModel {
    private var disposeBag = DisposeBag()
    
    let presentLargPreviewVC = PublishSubject<LargeViewController>()     // 미리보기 이미지셀 클릭과 바인딩
    let updateCellVMs = PublishSubject<[[TableCellRepresentable]]>()
    private(set) var searchResult: SearchResult
    private(set) var sections: [[TableCellRepresentable]] = [] {
        didSet {
            updateCellVMs.onNext(sections)
        }
    }
    
    init(_ result: SearchResult) {
        self.searchResult = result
        sections = configureCellVMs(result)
        bindings()
    }
    
    
    private func bindings() {
        
    }
    
    private func configureCellVMs(_ result: SearchResult) -> [[TableCellRepresentable]] {
        var section: [[TableCellRepresentable]] = []
        let appIconBig = [AppIconBigCellViewModel(result)]
        
        let badges = [CollectionViewContainerCellViewModel(result,
                                                           type: .BadgeCell, self)]
        let 새로운기능Title = [TitleCellViewModel("새로운 기능", buttonTitle: "버전 기록")]
        let 미리보기 = [TitleCellViewModel("미리보기")]
        
        let screenShots = [CollectionViewContainerCellViewModel(result,
                                                                type: .iPhonePreviewCell, self)]
        let availableDevices = [AvailableDeviceScreenShotCellViewModel(ipadScreenShotUrls: result.ipadScreenshotUrls,
                                                                       supportedDevices: result.supportedDevices)]
        
        let description = [DescriptionCellViewModel(result.description)]
        
        let 평가및리뷰 = [TitleCellViewModel("평가 및 리뷰", buttonTitle: "모두 보기")]
        
        let 정보 = [TitleCellViewModel("정보")]
        let infoTexts = [InfoTextCellViewModel(.제공자, desc: result.sellerName),
                         InfoTextCellViewModel(.크기, desc: result.fileSizeBytes ?? "0"),
                         InfoTextCellViewModel(.카테고리, desc: result.genres.first ?? ""),
                         InfoTextCellViewModel(.호환성, desc: result.minimumOsVersion),
                         InfoTextCellViewModel(.언어, languages: result.languageCodesISO2A),
                         InfoTextCellViewModel(.연령등급, desc: result.trackContentRating),
                         InfoTextCellViewModel(.저작권, desc: "© \(result.sellerName)")
        ]
        
        section = [appIconBig, badges, 새로운기능Title, 미리보기,
                   screenShots, availableDevices, description,
                   평가및리뷰, 정보, infoTexts]
        return section
    }
    
    func showIpadScreenShotCell(at indexPath: IndexPath) {
        let availableIPhone = [AvailableDeviceScreenShotCellViewModel(.iPhone)]
        let ipadScreenShots = [CollectionViewContainerCellViewModel(searchResult, type: .iPadPreviewCell, self)]
        let availableIPad = [AvailableDeviceScreenShotCellViewModel(.iPad)]
        
        var prepareSections = self.sections
        prepareSections.remove(at: indexPath.section)
        prepareSections.insert(availableIPhone, at: indexPath.section)
        prepareSections.insert(ipadScreenShots, at: indexPath.section + 1)
        prepareSections.insert(availableIPad, at: indexPath.section + 2)
        sections = prepareSections
    }
    
}

extension AppInfoViewModel: CollectionViewContainerCellProtocol {
    func showLargePreviewVC(_ type: PreviewCollectionCellType, items: [CollectionCellRepresentable]) {
        let previewCellVMs = items.compactMap { vm in
            return vm as? PreviewCellViewModel
        }
        
        let largeVC = LargeViewController()
        largeVC.vm = LargeViewModel(type: type, previewCellVMs)
        self.presentLargPreviewVC.onNext(largeVC)
    }
}
