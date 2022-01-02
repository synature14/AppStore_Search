//
//  DescriptionCell.swift
//  Search
//
//  Created by Suvely on 2022/01/02.
//

import UIKit
import RxSwift
import RxCocoa

class DescriptionCellViewModel: TableCellRepresentable {

    var cellType: UITableViewCell.Type {
        DescriptionCell.self
    }
    var leadingTrailingMargin: CGFloat = 20
    
    private(set) var description: String
    var expandCell: Bool = false
    var expandedCellHeight: CGFloat?
    var descriptionLabelFont: UIFont = .systemFont(ofSize: 13)
    
    init(_ descrption: String) {
        self.description = descrption
    }
}

class DescriptionCell: UITableViewCell, BindableTableViewCell {

    private var disposeBag = DisposeBag()
    private(set) var cellVM: DescriptionCellViewModel?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? DescriptionCellViewModel else { return }
        self.cellVM = cellVM
        
        expandButton.isHidden = cellVM.expandCell
        
        let attributedStr = NSMutableAttributedString(string: cellVM.description)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle,
                                   value: paragraphStyle,
                                   range: NSMakeRange(0, attributedStr.length))
        descriptionLabel.attributedText = attributedStr
        cellVM.descriptionLabelFont = descriptionLabel.font
    }
}
