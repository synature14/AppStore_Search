//
//  String+Ext.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import Foundation
import UIKit

extension String {
    // /406x228bb.jpg
    var size: CGSize {
        let imageSizeString = self.split(separator: "/").last
        let splited = imageSizeString?.split(separator: "x") ?? []
        let widthString = splited
            .first?
            .filter { $0.isNumber }
        let heightString = splited
            .last?
            .filter { $0.isNumber }
        
        guard let widthString = widthString, let heightString = heightString else {
            return .zero
        }
        guard let width = Int(widthString), let height = Int(heightString) else {
            return .zero
        }
        return CGSize(width: width, height: height)
    }
    
    var isLandscape: Bool {
        let size = self.size
        return size.width > size.height
    }
}
