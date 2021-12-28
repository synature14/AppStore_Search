//
//  RecentSearchEntity+CoreDataProperties.swift
//  Search
//
//  Created by SutieDev on 2021/12/28.
//
//

import Foundation
import CoreData


extension RecentSearchEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearchEntity> {
        return NSFetchRequest<RecentSearchEntity>(entityName: "RecentSearchEntity")
    }

    @NSManaged public var word: String?
    @NSManaged public var date: Date?

}

extension RecentSearchEntity : Identifiable {

}
