//
//  NSObject+Ext.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }

    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    class var bundle: Bundle {
        return Bundle(for: self)
    }
}
