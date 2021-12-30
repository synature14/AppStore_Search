//
//  ImageCache.swift
//  Search
//
//  Created by Suvely on 2021/12/30.
//

import Foundation
import RxSwift
import RxRelay

class ImageCache {
    var disposeBag = DisposeBag()
   
    deinit {
        disposeBag = DisposeBag()
    }
    
    // 1. 조회 (memory first, 없으면 disk, 없으면 nil)
    func value(key imageFilePath: String) throws -> UIImage? {
        if let image = MemoryStorage.shared.read(imageFilePath) {
            return image
        }
        
        do {
            let imageFromDisk = try DiskStorage.shared.value(at: imageFilePath)
            return imageFromDisk
            
        } catch {
            throw SYStorageError.diskError(reason: "Can't find Image")
        }
    }
    
    // 2. 쓰기 (disk & memory)
    func write(key imageFilePath: String, image: UIImage) throws {
        guard let compressedData = image.jpegData(compressionQuality: 0.7) else { return }
        MemoryStorage.shared.store(imageFilePath, data: compressedData)
        do {
            try DiskStorage.shared.store(data: compressedData)
        } catch {
            throw SYStorageError.diskError(reason: "data writeError")
        }
    }
    
}


class ImageManager {
    static let shared = ImageManager()
    private let imageCache = ImageCache()
    private var disposeBag = DisposeBag()
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    // 🌟 조회 -> ImageCache에서 조회, 없으면 이미지 서버에서 요청한 뒤 ImageCache에 저장
    func loadImage(_ imageFilePath: String) -> Observable<UIImage> {
        do {
            if let cachedImage = try imageCache.value(key: imageFilePath) {
                return Observable.of(cachedImage)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        // 이미지 서버에서 요청
        return Observable.of(imageFilePath)
            .compactMap { URL(string: $0) }
            .map { URLRequest(url: $0) }
            .flatMapLatest { request -> Observable<Data> in
                return URLSession.shared.rx.data(request: request)
            }
            .compactMap { UIImage(data: $0) }
    }
}
