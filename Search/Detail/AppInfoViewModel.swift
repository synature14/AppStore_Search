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
    let updatedCellVMs = BehaviorRelay<[[TableCellRepresentable]]>(value: [[]])
    private(set) var searchResult: SearchResult
    private(set) var sections: [[TableCellRepresentable]] = [] {
        didSet {
            updatedCellVMs.accept(sections)
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
        
        let badgeWidth = (UIScreen.main.bounds.width - 15*2)/4
        let badges = [CollectionViewContainerCellViewModel(result,
                                                           cellSize: CGSize(width: badgeWidth, height: 75),
                                                           type: .BadgeCell)]
        let 새로운기능Title = [TitleCellViewModel("새로운 기능", buttonTitle: "버전 기록")]
        let 미리보기 = [TitleCellViewModel("미리보기")]
        
        guard let imageURL = result.screenshotUrls.first else { return [[]] }
        let originalSize = imageURL.size
        let cellSize = imageURL.isLandscape ? scaledSizeForLandscape(originalSize) : scaledSizeForPortrait(originalSize)
        let screenShots = [CollectionViewContainerCellViewModel(result,
                                                                cellSize: cellSize,
                                                                type: .PreviewCell)]
        let availableDevices = [AvailableDeviceScreenShotCellViewModel(result.ipadScreenshotUrls, supportedDevices: result.supportedDevices)]
        
        let 정보 = [TitleCellViewModel("정보")]
        let infoTexts = [InfoTextCellViewModel(.제공자, desc: result.sellerName),
                         InfoTextCellViewModel(.크기, desc: result.fileSizeBytes ?? "0"),
                         InfoTextCellViewModel(.카테고리, desc: result.genres.first ?? ""),
                         InfoTextCellViewModel(.호환성, desc: result.minimumOsVersion),
                         InfoTextCellViewModel(.언어, languages: result.languageCodesISO2A),
                         InfoTextCellViewModel(.연령등급, desc: result.trackContentRating),
                         InfoTextCellViewModel(.저작권, desc: "© \(result.sellerName)")
        ]
        
        section = [appIconBig, badges, 새로운기능Title, 미리보기, screenShots, availableDevices, 정보, infoTexts]
        return section
    }
    
}

private extension AppInfoViewModel {
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
