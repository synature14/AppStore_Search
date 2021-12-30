//
//  UIImageView+Ex.swift
//  Search
//
//  Created by Suvely on 2021/12/30.
//

import UIKit
import RxSwift

extension UIImageView {

    func loadImage(_ url: String) {
        ImageManager.shared.loadImage(url)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] img in
                self?.image = img
            })
            .dispose()
    }
    
}
