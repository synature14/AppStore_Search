//
//  AvailableDeviceScreenShotCell.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit
import RxSwift

protocol AvailableDeviceScreenShotCellVMProtocol {
    
}

class AvailableDeviceScreenShotCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        AvailableDeviceScreenShotCell.self
    }
    
    enum DeviceType {
        case iPhone
        case iPad
        case watch
    }
    
    private(set) var ipadScreenShotUrls: [String]
    private(set) var supportedDevices: [String]
    private(set) var soleType: DeviceType?
    private(set) var showUnfoldButton: Bool
    
    init(_ soleType: DeviceType? = nil, ipadScreenShotUrls: [String] = [], supportedDevices: [String] = []) {
        self.ipadScreenShotUrls = ipadScreenShotUrls
        self.supportedDevices = supportedDevices
        self.soleType = soleType
        self.showUnfoldButton = soleType == nil
    }
}

class AvailableDeviceScreenShotCell: UITableViewCell, BindableTableViewCell {
    
    @IBOutlet weak var iphoneIconView: UIView!
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
        
        unfoldButton.isHidden = !cellVM.showUnfoldButton
        
        var description = "iPhone"
        
        // 1. iphone용 스크린샷만 보이는 상태일때
        guard let type = cellVM.soleType else {
            let ipadImages = cellVM.ipadScreenShotUrls
            ipadIconView.isHidden = ipadImages.isEmpty
            
            let supportWatch = !cellVM.supportedDevices
                .map { $0.lowercased() }
                .filter { $0.contains("watch") }
                .isEmpty
            watchIconView.isHidden = !supportWatch
            
            if !ipadImages.isEmpty {
                description = "iPhone 및 iPad용 앱"
            }
            
            if supportWatch {
                description = "iPhone, iPad 및 Apple Watch용 앱"
            }
            
            descrptionLabel.text = description
            return
        }
        
        // 2. iPhone,iPad,watch 스크린샷 보여주어야 할때
        switch type {
        case .iPhone:
            ipadIconView.isHidden = true
            watchIconView.isHidden = true
            descrptionLabel.text = "iPhone"
        case .iPad:
            iphoneIconView.isHidden = true
            watchIconView.isHidden = true
            descrptionLabel.text = "iPad용 앱"
        case .watch:
            iphoneIconView.isHidden = true
            ipadIconView.isHidden = true
            descrptionLabel.text = "Apple Watch 앱"
        }
    }
    
}
