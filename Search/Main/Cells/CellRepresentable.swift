//
//  CellRepresentable.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//


import UIKit

protocol TableCellRepresentable {
    var cellType: UITableViewCell.Type { get }
}

protocol BindableTableViewCell: UITableViewCell {
    func bindCellVM(_ cellVM: TableCellRepresentable?)
}

protocol CollectionCellRepresentable {
    var cellType: UICollectionViewCell.Type { get }
}

protocol BindableCollectionViewCell: UICollectionViewCell {
    func bindCellVM(_ cellVM: CollectionCellRepresentable?)
}
