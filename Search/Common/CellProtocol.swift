//
//  CellProtocol.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import Foundation

protocol CellDelegate {
    func selected<T>(_ item: T)
    func deleteRow(at indexPath: IndexPath)
}

