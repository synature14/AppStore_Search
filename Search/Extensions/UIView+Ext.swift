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
    
    func setGradient(c1: UIColor, c2: UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [c1.cgColor, c2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
