//
//  InfoTextCell.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit

class InfoTextCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        InfoTextCell.self
    }
    
    enum TitleType: String {
        case 제공자 = "제공자"
        case 크기 = "크기"
        case 카테고리 = "카테고리"
        case 호환성 = "호환성"
        case 언어 = "언어"
        case 연령등급 = "연령등급"
        case 저작권 = "저작권"
    }
    
    private(set) var title: String
    private(set) var description: String
    
    init(_ type: TitleType, desc: String) {
        self.title = type.rawValue
        self.description = desc
        
        if type == .크기 {
            self.description = byteFormatted(desc)
        }
    }
    
    private func byteFormatted(_ byte: String) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.countStyle = .file
        formatter.includesUnit = true
        formatter.isAdaptive = true
        let byteInt = Int64(byte) ?? 0
        return formatter.string(fromByteCount: byteInt) // '53.4 MB'
    }
}

class InfoTextCell: UITableViewCell, BindableTableViewCell {
    
    private(set) var cellVM: InfoTextCellViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? InfoTextCellViewModel else { return }
        self.cellVM = cellVM
        
        titleLabel.text = cellVM.title
        valueLabel.text = cellVM.description
    }
}
