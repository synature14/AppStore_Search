//
//  DiskStorage.swift
//  Search
//
//  Created by Suvely on 2021/12/30.
//

import Foundation
import UIKit

class DiskStorage {
    let fileManager = FileManager.default
    
    let metaChangingQueue: DispatchQueue
    let maybeCachedCheckingQueue = DispatchQueue(label: "maybeCachedCheckingQueue")
    var maybeCached: Set<String>?
    let directoryURL: URL?
    
    init(imageURL: String) {
        let path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        let cacheDirectory = path?.appendingPathComponent(imageURL)
        self.directoryURL = cacheDirectory
        
        metaChangingQueue = DispatchQueue(label: "DiskStorage")
        setupCacheCheck()
    }
    
    private func setupCacheCheck() {
        maybeCachedCheckingQueue.async {
            do {
                guard let diretoryURL = self.directoryURL else {
                    throw SYStorageError.diskError(reason: "No URL")
                }
                
                self.maybeCached = Set()
                try self.fileManager.contentsOfDirectory(atPath: diretoryURL.path).forEach { fileName in
                    self.maybeCached?.insert(fileName)
                }
            } catch {
                self.maybeCached = nil
            }
        }
    }
    
    // 저장
    func store(data: Data) throws {
        guard let directoryURL = self.directoryURL else {
            return
        }
        
        do {
            try data.write(to: directoryURL)
        } catch {
            throw SYStorageError.diskError(reason: "cannotCreateCacheFile")
        }
        
        maybeCachedCheckingQueue.async {
            self.maybeCached?.insert(directoryURL.lastPathComponent)
        }
        print("===== [complete] write Data =====")
    }
    
    // 조회
    func value(at fileURL: URL) throws -> UIImage? {
        let fileMaybeCached = maybeCachedCheckingQueue.sync {
            return maybeCached?.contains(fileURL.lastPathComponent) ?? true
        }
        
        guard fileMaybeCached else {
            return nil
        }
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let image = try UIImage(data: data)
            metaChangingQueue.async {
                // 파일 메타 데이터 업데이트
            }
            return image
            
        } catch {
            throw SYStorageError.diskError(reason: "cannotLoadDataFromDisk")
        }
    }
}
