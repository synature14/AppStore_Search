//
//  TitleCell.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit

class TitleCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        TitleCell.self
    }
    
    private(set) var title: String
    private(set) var buttonTitle: String
    
    init(_ title: String, buttonTitle: String = "") {
        self.title = title
        self.buttonTitle = buttonTitle
    }
}

class TitleCell: UITableViewCell, BindableTableViewCell {
    var cellVM: TitleCellViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sideButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? TitleCellViewModel else { return }
        self.cellVM = cellVM
        
        sideButton.isHidden = cellVM.buttonTitle.isEmpty
        titleLabel.text = cellVM.title
        sideButton.setTitle(cellVM.buttonTitle, for: .normal)
    }
    
}
