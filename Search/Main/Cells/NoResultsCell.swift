//
//  NoResultsCell.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import UIKit

class NoResultsCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        NoResultsCell.self
    }
    
}

class NoResultsCell: UITableViewCell, BindableTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
    }
}
