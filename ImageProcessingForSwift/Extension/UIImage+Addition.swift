//
//  UIImage+Addition.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/19.
//

import UIKit

extension UIImage {
    func toCIImage() -> CIImage? {
        if let ciImage = self.ciImage {
            return ciImage
        }
        if let cgImage = self.cgImage {
            return CIImage(cgImage: cgImage)
        }
        return nil
    }
}
