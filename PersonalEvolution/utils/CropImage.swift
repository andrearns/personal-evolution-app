//
//  CropImage.swift
//  PersonalEvolution
//
//  Created by André Arns on 12/09/21.
//

import Foundation
import UIKit

struct CropImage {
    static var shared = CropImage()
    
    public func crop(image: UIImage, aspectRatio: Float) -> UIImage? {
        let width = image.size.width
        
        let sourceSize = image.size
        let xOffset = CGFloat(0)
        let yOffset = sourceSize.width * (1 - CGFloat(1 / aspectRatio)) / 2
        
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: width,
            height: width / CGFloat(aspectRatio)
        ).integral
        
        let sourceCGImage = image.cgImage
        
        let croppedCGImage = sourceCGImage?.cropping(to: cropRect)
        return UIImage(cgImage: croppedCGImage!)
    }
}
