//
//  ResultInfoCell.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import UIKit

class ResultInfoCell: UITableViewCell {
    static let name = "ResultInfoCell"
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var userRatingCountLabel: UILabel!
    
    @IBOutlet weak var screenShotImageView: UIImageView!
    
    @IBOutlet weak var screenShotImageView01: UIImageView!
    @IBOutlet weak var screenShotImageView02: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
