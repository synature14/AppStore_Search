//
//  RecentSearchCoreDataManager.swift
//  Search
//
//  Created by Suvely on 2021/12/28.
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
    private lazy var context: NSManagedObjectContext? = {
        return appDelegate?.persistentContainer.viewContext
    }()
    
    // 조회
    func loadAllData(predicate: NSPredicate? = nil, completion: (([RecentSearchEntity]?) -> Void)) {
        guard let context = self.context else { return }
        let fetchRequest = RecentSearchEntity.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            let cdTasks = try context.fetch(fetchRequest)
            completion(cdTasks)
        } catch {
            completion(nil)
        }
    }
    
    // 저장 (동일한 키워드 검색시 date 업데이트)
    func save(_ word: String) {
        // 1. 예전에 검색했던 검색어인가?
        guard let context = self.context else { return }
        let predicate = NSPredicate(format: "word == %@", word)
        
        // CoreData에서 조회할때 데이터에 대한 참조(lazy load)만 가져온거라 성능에 이슈 없음.
        loadAllData(predicate: predicate) { recentSearchEntities in
            guard let recentSearchEntities = recentSearchEntities else {
                return
            }
            
            if recentSearchEntities.isEmpty {
                saveNewWord(word)       // 검색어 히스토리에 없는 경우 새로 저장
                return
            }
            
            // date 수정 후 저장
            guard let searched = recentSearchEntities.first else { return }
            searched.date = Date()
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    
    // 삭제
    func delete(_ word: String, completion: (() -> Void)) {
        guard let context = self.context else {
            completion()
            return
        }
        
        let predicate = NSPredicate(format: "word == %@", word)
        
        loadAllData(predicate: predicate) { recentSearchEntities in
            guard let recentSearchEntities = recentSearchEntities else {
                completion()
                print(SYCoreDataError.fetchFail)
                return
            }
            
            guard let searched = recentSearchEntities.first else { return }
            context.delete(searched)
            do {
                try context.save()
                completion()
            } catch {
                completion()
                print(SYCoreDataError.commonError(error.localizedDescription))
            }
        }
    }
    
    // 특정 키워드 찾기
    func find(_ keyword: String, completion: (([RecentSearchEntity]) -> Void)) {
        loadAllData { recentSearchEntities in
            guard let recentSearchEntities = recentSearchEntities else {
                print(SYCoreDataError.fetchFail)
                completion([])
                return
            }
            let secondaryResults = recentSearchEntities
                .filter { entity in
                    let word = entity.word ?? ""
                    return !word.hasPrefix(keyword)
                }
                .filter { entity in
                    let word = entity.word ?? ""
                    return word.contains(keyword)
                }
            
            var primaryResults = recentSearchEntities
                .filter { entity in
                    let word = entity.word ?? ""
                    return word.hasPrefix(keyword)
                }
            
            primaryResults.append(contentsOf: secondaryResults)
            completion(primaryResults)
        }
    }
    
    // MARK: 검색 날짜에 따른 최신순 정렬
    func sortByDate() -> [RecentSearchEntity] { return [] }
}

private extension SYCoreDataManager {
    func saveNewWord(_ word: String) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: RecentSearchEntity.name, in: context) else {
            return
        }
        
        guard let recentSearchWords = NSManagedObject(entity: entity, insertInto: context) as? RecentSearchEntity else {
            return
        }

        recentSearchWords.word = word
        recentSearchWords.date = Date()
        
        do {
            print("[CoreData - save complete] \(word)")
            try context.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
