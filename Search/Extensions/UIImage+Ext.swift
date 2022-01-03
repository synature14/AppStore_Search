//
//  UIImage+Ext.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//

import UIKit

extension UIImage {
    func resize(newSize: CGSize) -> UIImage {
        let scale = newSize.width / self.size.width
        let newHeight = self.size.height * scale
        let size = CGSize(width: newSize.width, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        print("origin: \(self), resize: \(renderImage)")
        return renderImage
    }


    // 이미지뷰 크기에 맞게 조절 + 해상도
    func downSampling(_ imageViewSize: CGSize? = nil) -> UIImage {
        let scale = UIScreen.main.scale
        let size = imageViewSize ?? self.size
        let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
        let data = self.pngData()! as CFData
        let imageSource = CGImageSourceCreateWithData(data, imageSourceOption)!
        let maxPixel = max(size.width, size.height) * scale
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel ] as CFDictionary
        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!
        let newImage = UIImage(cgImage: downSampledImage)
        print(newImage)
        return newImage
    }
  
}
