//
//  ResultCellViewModel.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import RxSwift
import UIKit
import RxRelay

class ResultCellViewModel {
    var searchResult: SearchResult?
    private var disposeBag = DisposeBag()
    
    let firstScreenShot = BehaviorRelay<UIImage?>(value: nil)
    let scaledImageHeight = BehaviorRelay<CGFloat>(value: 0)
    
    lazy var appIconImage: Observable<UIImage?> = {
        return Observable.of(searchResult?.iconImage ?? "")
            .map { URL(string: $0)! }
            .map { URLRequest(url: $0) }
            .flatMap { request -> Observable<Data> in
              return URLSession.shared.rx.data(request: request)
            }
            .map { UIImage(data: $0) }
    }()
    
    lazy var screenShotUrls: [String] = {
        guard let searchResult = self.searchResult else {
            return []
        }

        var count = searchResult.screenshotUrls.count
        if count > 3 {
            count = 3
        }
        let urlStrings = searchResult.screenshotUrls[0..<count]
        return Array(urlStrings)
    }()

    init(_ searchResult: SearchResult) {
        self.searchResult = searchResult
        bindings()
    }
    
    func bindings() {
        guard let result = self.searchResult else {
            return
        }
        UIUtility.shared.loadImage(result.screenshotUrls[0])
            .subscribe(onNext: { image in
                self.firstScreenShot.accept(image)
            })
            .disposed(by: disposeBag)
    }
    
}
