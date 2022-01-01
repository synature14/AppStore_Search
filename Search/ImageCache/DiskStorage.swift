//
//  DiskStorage.swift
//  Search
//
//  Created by Suvely on 2021/12/30.
//

import Foundation
import UIKit

class DiskStorage {
    static let shared = DiskStorage()
    
    private let metaChangingQueue: DispatchQueue        // 파일의 메타정보 관리
    private let maybeCachedCheckingQueue = DispatchQueue(label: "maybeCachedCheckingQueue")    // FileManager.default는 싱글턴. thread unsafe함. directory 찾고 저장할때 thread safe를 보장하기 위해 사용
    private var maybeCached: Set<String>?
    private var directoryURL: URL?
    
    private let fileManager = FileManager.default
    
    init() {
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
    func store(at fileURL: String, data: Data) throws {
        let path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let cacheDirectory = path?.appendingPathComponent(fileURL) else {
            throw SYStorageError.diskError(reason: "Fail to Make path")
        }

        maybeCachedCheckingQueue.async {
            print("[STORE] Disk")
            self.fileManager.createFile(atPath: fileURL, contents: data)
            self.maybeCached?.insert(cacheDirectory.lastPathComponent)
        }
    }
    
    // 조회
    func value(at fileURL: String) throws -> UIImage? {
        let path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let cacheDirectory = path?.appendingPathComponent(fileURL) else {
            throw SYStorageError.diskError(reason: "Fail to Make path")
        }
        self.directoryURL = cacheDirectory
        
        let fileMaybeCached = maybeCachedCheckingQueue.sync {
            return maybeCached?.contains(cacheDirectory.lastPathComponent) ?? true
        }

        guard fileMaybeCached else {
            return nil
        }
        
        guard fileManager.fileExists(atPath: cacheDirectory.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: cacheDirectory)
            let image = UIImage(data: data)
            metaChangingQueue.async {
                // 파일 메타 데이터 업데이트
            }
            
            print("[READ] Disk")
            return image
            
        } catch {
            throw SYStorageError.diskError(reason: "cannotLoadDataFromDisk")
        }
    }
}
