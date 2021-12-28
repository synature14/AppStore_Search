//
//  RecentSearchCoreDataManager.swift
//  Search
//
//  Created by SutieDev on 2021/12/28.
//

import Foundation
import UIKit
import CoreData

protocol InAppDataHandler {
    func save(_ word: String)
}

// MARK: UserDefaults에 저장할수도 있음..
class SYCoreDataManager: InAppDataHandler {
    static let shared = SYCoreDataManager()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    // 조회
    func loadData<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        guard let context = self.context else {
            return []
        }
        
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    // 저장
    func save(_ word: String) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: RecentSearchEntity.name, in: context) else {
            return
        }
        
        guard let recentSearchWords = NSManagedObject(entity: entity, insertInto: context) as? RecentSearchEntity else {
            return
        }
        // 1. 예전에 검색했던 검색어인가?
        // 1-1. 그렇다면 delete
        // 1-2. 다시 save
        
        // 2. 아니라면 그냥 save
        recentSearchWords.word = word
        recentSearchWords.date = Date()
        
        do {
            print("[CoreData - save complete] \(word)")
            try context.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }

    
    // 삭제
    func delete<T: NSManagedObject>(_ word: String, request: NSFetchRequest<T>) -> Bool {
        guard let context = self.context else {
            return false
        }
        
        do {
            let targetObject = try context.fetch(request)
            if targetObject.isEmpty {
                return false
            }
            
            context.delete(targetObject.first!)
            try context.save()
            return true
            
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
