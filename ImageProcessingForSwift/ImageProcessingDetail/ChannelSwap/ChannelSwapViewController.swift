//
//  ChannelSwapViewController.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

final class ChannelSwapViewController: UIViewController {
    @IBOutlet private weak var comparisonConversionView: ComparisonConversionView!
    
    var r:[CGFloat] = []
    var g:[CGFloat] = []
    var b:[CGFloat] = []
    var a:[CGFloat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        comparisonConversionView.beforeImage.image = UIImage(named: "harumi")!
        
        if let image = comparisonConversionView.beforeImage.image,
            let pixelBuffer = PixelBuffer(uiImage: image) {
            for x in 0..<pixelBuffer.width {
                for y in 0..<pixelBuffer.height {
                    r.append(pixelBuffer.getRed(x: x, y: y))
                    g.append(pixelBuffer.getBlue(x: x, y: y))
                    b.append(pixelBuffer.getGreen(x: x, y: y))
                    a.append(pixelBuffer.getAlpha(x: x, y: y))
                }
            }
            comparisonConversionView.afterImage.image = image.createImage(r: g, g: b, b: r, a: a)
        } else {
            comparisonConversionView.afterImage.image = UIImage(named: "error")
        }
    }
}

extension UIImage {
    func createImage(r:[CGFloat], g: [CGFloat], b:[CGFloat], a:[CGFloat]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let wid:Int = Int(size.width)
        let hei:Int = Int(size.height)
        
        for w in 0..<wid {
            for h in 0..<hei {
                let index = (w * wid) + h
                UIColor(red: r[index], green: g[index], blue: b[index], alpha: a[index]).setFill()
                let drawRect = CGRect(x: w, y: h, width: 1, height: 1)
                UIRectFill(drawRect)
                draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
            }
        }
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return tintedImage
    }
}
