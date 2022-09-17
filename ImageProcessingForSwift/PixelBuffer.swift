//
//  PixelBuffer.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

final class PixelBuffer {
    private var pixelData: Data
    var width: Int
    var height: Int
    private var bytesPerRow: Int
    private let bytesPerPixel = 4 //1ピクセル4バイトのデータ固定
    
    init?(uiImage: UIImage) {
        guard let cgImage = uiImage.cgImage,
              //R,G,B,A計8Bit
              cgImage.bitsPerComponent == 8,
              cgImage.bitsPerPixel == bytesPerPixel * 8 else {
            return nil
            
        }
        pixelData = cgImage.dataProvider!.data! as Data
        width = cgImage.width
        height = cgImage.height
        bytesPerRow = cgImage.bytesPerRow
    }
    
    func getRed(x: Int, y: Int) -> CGFloat {
        let pixelInfo = bytesPerRow * y + x * bytesPerPixel
        let r = CGFloat(pixelData[pixelInfo]) / CGFloat(255.0)
        
        return r
    }
    func getGreen(x: Int, y: Int) -> CGFloat {
        let pixelInfo = bytesPerRow * y + x * bytesPerPixel
        let green = CGFloat(pixelData[pixelInfo+1]) / CGFloat(255.0)
        
        return green
    }
    func getBlue(x: Int, y: Int) -> CGFloat {
        let pixelInfo = bytesPerRow * y + x * bytesPerPixel
        let blue = CGFloat(pixelData[pixelInfo+2]) / CGFloat(255.0)
        
        return blue
    }
    func getAlpha(x: Int, y: Int) -> CGFloat {
        let pixelInfo = bytesPerRow * y + x * bytesPerPixel
        let alpha = CGFloat(pixelData[pixelInfo+3]) / CGFloat(255.0)
        return alpha
    }
}
