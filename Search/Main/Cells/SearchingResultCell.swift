//
//  SearchingResultCell.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import UIKit

class SearchingResultCell: UITableViewCell, BindableTableViewCell {
    static let name = "SearchingResultCell"
    
    @IBOutlet weak var wordLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let vm = cellVM as? SearchingResultCellViewModel else { return }
        wordLabel.text = vm.item.word
    }
}
