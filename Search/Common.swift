//
//  Common.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import Foundation

protocol CellDelegate {
    func selected<T>(_ item: T)
    func deleteRow(at indexPath: IndexPath)
}

struct Constants {
    static let leading_Trailing_Padding: CGFloat = 40.0
}

