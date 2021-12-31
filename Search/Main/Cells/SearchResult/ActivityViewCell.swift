//
//  ActivityViewCell.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit

class ActivityViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        ActivityViewCell.self
    }
    
    
}

class ActivityViewCell: UITableViewCell, BindableTableViewCell {
    
    var cellVM: ActivityViewModel?
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        self.cellVM = cellVM as? ActivityViewModel
        
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
    }
    
}
