//
//  PixelBuffer.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

final class PixelBuffer {
    private let pixelData: Data
    private let width: Int
    private let height: Int
    private var bytesPerRow: Int
    //1ピクセル4バイトのデータ固定
    private let bytesPerPixel = 4
    
    private var r:[CGFloat] = []
    private var g:[CGFloat] = []
    private var b:[CGFloat] = []
    private var a:[CGFloat] = []
    
    init?(uiImage: UIImage) {
        guard let cgImage = uiImage.cgImage,
              //R,G,B,A各8Bit
              cgImage.bitsPerComponent == 8,
              cgImage.bitsPerPixel == bytesPerPixel * 8 else {
            return nil
            
        }
        pixelData = cgImage.dataProvider!.data! as Data
        width = cgImage.width
        height = cgImage.height
        bytesPerRow = cgImage.bytesPerRow
    }
    
    func getRGBA() -> (r:[CGFloat], g: [CGFloat], b:[CGFloat], a:[CGFloat]) {
        for x in 0..<width {
            for y in 0..<height {
                r.append(getRed(x: x, y: y))
                g.append(getBlue(x: x, y: y))
                b.append(getGreen(x: x, y: y))
                a.append(getAlpha(x: x, y: y))
            }
        }
        return (r: r, g: g, b: b, a: a)
    }
}

private extension PixelBuffer {
    func getRed(x: Int, y: Int) -> CGFloat {
        let pixelInfo = bytesPerRow * y + x * bytesPerPixel
        let red = CGFloat(pixelData[pixelInfo]) / CGFloat(255.0)
        
        return red
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
