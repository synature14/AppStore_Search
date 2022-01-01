//
//  AvailableDeviceScreenShotCell.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit
import RxSwift

class AvailableDeviceScreenShotCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        AvailableDeviceScreenShotCell.self
    }
    
    private(set) var ipadScreenShotUrls: [String]
    private(set) var supportedDevices: [String]
    
    init(_ ipadScreenShotUrls: [String], supportedDevices: [String]) {
        self.ipadScreenShotUrls = ipadScreenShotUrls
        self.supportedDevices = supportedDevices
    }
}

class AvailableDeviceScreenShotCell: UITableViewCell, BindableTableViewCell {
    
    @IBOutlet weak var ipadIconView: UIView!
    @IBOutlet weak var watchIconView: UIView!
    @IBOutlet weak var descrptionLabel: UILabel!
    @IBOutlet weak var unfoldButton: UIImageView!
    
    private(set) var cellVM: AvailableDeviceScreenShotCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? AvailableDeviceScreenShotCellViewModel else { return }
        self.cellVM = cellVM
        
        var description = "iPhone"
        let ipadImages = cellVM.ipadScreenShotUrls
        ipadIconView.isHidden = ipadImages.isEmpty
        
        let supportWatch = !cellVM.supportedDevices
            .map { $0.lowercased() }
            .filter { $0.contains("watch") }
            .isEmpty
        watchIconView.isHidden = !supportWatch
        
        if !ipadImages.isEmpty {
            description = "iPhone 및 iPad용 앱"
            ipadImages.map { PreviewCellViewModel($0) }
        }
        
        if supportWatch {
            description = "iPhone, iPad 및 Apple Watch용 앱"
        }
        
        descrptionLabel.text = description
    }
    
}
