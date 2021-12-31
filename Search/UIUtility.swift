//
//  UIUtility.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//

import Foundation
import RxSwift

class UIUtility {
    static let shared = UIUtility()
    private var disposeBag = DisposeBag()
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    func loadImage(_ url: String) -> Observable<UIImage> {
        return ImageManager.shared.loadImage(url)
            .observeOn(MainScheduler.instance)
            .asObservable()
    }
}
