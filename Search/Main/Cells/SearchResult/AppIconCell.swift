//
//  AppIconCell.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//

import UIKit

class AppIconViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type
    
    
    
    
}

class AppIconCell: UITableViewCell, BindableTableViewCell {
    static let name = "AppIconCell"
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var userRatingCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = ""
        userRatingCountLabel.text = ""
    }
    
    func bindCellVM(_ viewModel: TableCellRepresentable?) {
        guard let vm = viewModel as? AppIconViewModel,
                let result = viewModel.searchResult else {
            return
        }
        trackNameLabel.text = result.trackName
        userRatingCountLabel.text = "\(result.userRatingCount)"
        
        bindings()
    }
  
    private func bindings() {
        guard let vm = self.vm else {
            return
        }
        
        vm.appIconImage
            .observeOn(MainScheduler.instance)
            .bind(to: self.appIconImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
}
