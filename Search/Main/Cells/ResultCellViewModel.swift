//
//  ResultCellViewModel.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import RxSwift
import UIKit

class ResultCellViewModel {
    var searchResult: SearchResult?
    
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
        
        
    }
    
}
