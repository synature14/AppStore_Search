//
//  UIImageView+Ex.swift
//  Search
//
//  Created by Suvely on 2021/12/30.
//

import UIKit
import RxSwift

extension UIImageView {
    
    func loadImage(_ url: String) -> UIImage {
        SYFileManager.shared.
        
        return Observable.of(url)
            .map {  }
            .map { URL(string: $0)! }
            .map { URLRequest(url: $0) }
            .flatMapLatest { request -> Observable<Data> in
                return URLSession.shared.rx.data(request: request)
            }
            .map { UIImage(data: $0) }
            .map {}
    }
    
}
