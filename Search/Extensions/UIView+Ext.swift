//
//  UIView+Ext.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    class var nib: UINib {
        return UINib(nibName: self.className, bundle: self.bundle)
    }
}
