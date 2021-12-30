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
    static let shared = MemoryStorage()
    private let cache = NSCache<NSString, NSData>()
    
    // 조회
    func read(_ key: String) -> UIImage? {
        if let data = cache.object(forKey: key as NSString) {
            return UIImage(data: data as Data)
        }
        return nil
    }
    
    // 저장
    func store(_ key: String, data: Data) {
        let nsData = NSData(data: data)
        cache.setObject(nsData, forKey: key as NSString)
    }
    
    func remove(_ key: String) {
        cache.removeObject(forKey: key as NSString)
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
