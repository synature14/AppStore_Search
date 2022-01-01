//
//  UICollectionView+Ext.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit

extension UICollectionView {
    func register(cells: [UICollectionViewCell.Type], usingNib: Bool = true) {
        cells.forEach {
            if usingNib {
                register($0.nib, forCellWithReuseIdentifier: $0.className)
            } else {
                register($0, forCellWithReuseIdentifier: $0.className)
            }
        }
    }

    func resolveCell(_ cellRepresentable: CollectionCellRepresentable, indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = cellRepresentable.cellType.className
        let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let bindableCell = cell as? BindableCollectionViewCell {
            bindableCell.bindCellVM(cellRepresentable)
        }
        return cell
    }
}
