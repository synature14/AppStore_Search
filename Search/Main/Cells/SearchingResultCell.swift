//
//  SearchingResultCell.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import UIKit

class SearchingResultCell: UITableViewCell {
    static let name = "SearchingResultCell"
    
    @IBOutlet weak var wordLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(_ vm: RecentSearchHistoryCellViewModel) {
        wordLabel.text = vm.item.word
    }
}
