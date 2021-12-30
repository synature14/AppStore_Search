//
//  MemoryStorage.swift
//  Search
//
//  Created by Suvely on 2021/12/30.
//

import Foundation
import UIKit

enum SYStorageError: Error {
    case memoryError(reason: String)
    case diskError(reason: String)
}

class MemoryStorage {
    let cache = NSCache<NSString, UIImage>()
    
    // 조회
    func read(_ key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    // 저장
    func store(_ key: String, image: UIImage) {
        cache.setObject(image, forKey: key as NSString)
    }
}


//struct CacheStoreResult {
//    enum CacheType {
//        case none
//        case disk
//        case memory
//        
//        var cached: Bool {
//            switch self {
//            case .memory, .disk:
//                return true
//            case .none:
//                return false
//            }
//        }
//    }
//    
//    let memoryCacheReuslt: Result<(), Never>
//    let diskCacheResult: Result<(), SYMemoryError>
//}
