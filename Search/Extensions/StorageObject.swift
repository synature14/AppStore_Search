//
//  StorageObject.swift
//  Search
//
//  Created by Suvely on 2021/12/30.
//

import Foundation
import UIKit

class StorageObject {
    var value: UIImage
    let key: String
    
    init(_ value: UIImage, key: String) {
        self.value = value
        self.key = key
    }
}
