//
//  RecentSearchCoreDataManager.swift
//  Search
//
//  Created by SutieDev on 2021/12/28.
//

import Foundation
import UIKit
import CoreData
import RxSwift

protocol InAppDataHandler {
    func save(_ word: String)
}

// MARK: UserDefaults에 저장할수도 있음..
class SYCoreDataManager: InAppDataHandler {
    static let shared = SYCoreDataManager()
    private var disposeBag = DisposeBag()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context: NSManagedObjectContext? = {
        return appDelegate?.persistentContainer.viewContext
    }()
    
    deinit {
        disposeBag = DisposeBag()
    }
    
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
    func update(_ word: String) {
        // 1. 예전에 검색했던 검색어인가?
        let loadedData = loadData(request: RecentSearchEntity.fetchRequest())        // 데이터에 대한 참조(lazy load)만 가져온거라 성능에 이슈 없음.
        let hasWord = !loadedData.filter({ $0.word == word }).isEmpty
        
        if hasWord {
            // 1-1. 그렇다면 delete
            delete(word, request: RecentSearchEntity.fetchRequest())
                .subscribe(onNext: { [weak self] _ in
                    // 1-2. 다시 save
                    self?.save(word)
                })
                .disposed(by: disposeBag)
        } else {
            save(word)
        }
    }
    
    internal func save(_ word: String) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: RecentSearchEntity.name, in: context) else {
            return
        }
        
        guard let recentSearchWords = NSManagedObject(entity: entity, insertInto: context) as? RecentSearchEntity else {
            return
        }

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
    func delete<T: NSManagedObject>(_ word: String, request: NSFetchRequest<T>) -> Observable<Any> {
        return Observable.create { emitter in
            guard let context = self.context else {
                emitter.onError(SYCoreDataError.invalidContext)
                return Disposables.create()
            }
            
            do {
                let targetObject = try context.fetch(request)
                if targetObject.isEmpty {
                    emitter.onError(SYCoreDataError.fetchFail)
                }
                
                context.delete(targetObject.first!)
                try context.save()
                emitter.onNext(())
                emitter.onCompleted()
                
            } catch {
                print(error.localizedDescription)
                emitter.onError(SYCoreDataError.commonError(error.localizedDescription))
            }
            
            return Disposables.create()
        }
    }
    
    func find(_ keyword: String) -> [RecentSearchEntity] {
        let recentSearchHistory = self.loadData(request: RecentSearchEntity.fetchRequest())
        let secondaryResults = recentSearchHistory
            .filter { entity in
                let word = entity.word ?? ""
                return !word.hasPrefix(keyword)
            }
            .filter { entity in
                let word = entity.word ?? ""
                return word.contains(keyword)
            }
        
        var primaryResults = recentSearchHistory
            .filter { entity in
                let word = entity.word ?? ""
                return word.hasPrefix(keyword)
            }
        
        primaryResults.append(contentsOf: secondaryResults)
        
        return primaryResults
    }
    
    // MARK: 검색 날짜에 따른 최신순 정렬
    func sortByDate() -> [RecentSearchEntity] { return [] }
}
