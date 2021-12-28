//
//  RecentSearchHistoryCell.swift
//  Search
//
//  Created by Suvely on 2021/12/28.
//

import UIKit
import RxSwift

class RecentSearchHistoryCell: UITableViewCell {
    static let name = "RecentSearchHistoryCell"
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wordLabel.text = ""
    }
    
    func setLabel(_ word: String) {
        wordLabel.text = word
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
