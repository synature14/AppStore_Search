//
//  UIImage+Ext.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//

import UIKit

extension UIImage {
  enum ImageMode {
    case portrait
    case landscape
  }
  
  func imageMode() -> ImageMode {
    let width = self.size.width
    let height = self.size.height
    
    let mode: ImageMode = width > height ? .landscape : .portrait
    return mode
  }
  
  func scaledImageHeight(of resizedToWidth: CGFloat = UIScreen.main.bounds.width) -> CGFloat {
    let imageSize = self.size
    let imageViewScaledHeight = imageSize.height * resizedToWidth / imageSize.width
    return imageViewScaledHeight
  }
}
