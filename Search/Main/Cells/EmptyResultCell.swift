//
//  EmptyResultCell.swift
//  Search
//
//  Created by SutieDev on 2022/01/03.
//

import UIKit

class EmptyResultCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        EmptyResultCell.self
    }
    
    let searchText: String
    
    init(searchText: String) {
        self.searchText = searchText
    }
}

class EmptyResultCell: UITableViewCell, BindableTableViewCell {

    @IBOutlet weak var searchedTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? EmptyResultCellViewModel else {
            return
        }
        
        searchedTextLabel.text = "'\(cellVM.searchText)'"
    }
}
