//
//  UITableView+Ext.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//

import UIKit

extension UITableView {
    func register(cells: [UITableViewCell.Type], usingNib: Bool = true) {
        cells.forEach {
            if usingNib {
                register($0.nib, forCellReuseIdentifier: $0.className)
            } else {
                register($0, forCellReuseIdentifier: $0.className)
            }
        }
    }

    func resolveCell(_ cellRepresentable: TableCellRepresentable, indexPath: IndexPath) -> UITableViewCell {
        let identifier = cellRepresentable.cellType.className
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let bindableCell = cell as? BindableTableViewCell {
            bindableCell.bindCellVM(cellRepresentable)
        }
        return cell
    }
}
