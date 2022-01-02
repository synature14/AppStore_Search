//
//  DescriptionCell.swift
//  Search
//
//  Created by Suvely on 2022/01/02.
//

import UIKit

class DescriptionCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        DescriptionCell.self
    }
    
    private(set) var description: String
    init(_ descrption: String) {
        self.description = descrption
    }
}

class DescriptionCell: UITableViewCell, BindableTableViewCell {

    private(set) var cellVM: DescriptionCellViewModel?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? DescriptionCellViewModel else { return }
        self.cellVM = cellVM
        
        
        
        descriptionLabel.text = cellVM.description
    }
    

}
