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
        comparisonConversionView.setup(target: self, action: #selector(convertImage))
    }
    
    @objc func convertImage() {
        if let image = comparisonConversionView.beforeImage.image,
           let pixelBuffer = PixelBuffer(uiImage: image) {
            let (r, g, b, a) = pixelBuffer.getRGBA()
            comparisonConversionView.afterImage.image = image.createImage(r: g, g: b, b: r, a: a)
            
        } else {
            comparisonConversionView.afterImage.image = UIImage(named: "error")
        }
    }
}

extension UIImage {
    func createImage(r:[CGFloat], g: [CGFloat], b:[CGFloat], a:[CGFloat]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width:Int = Int(size.width)
        let height:Int = Int(size.height)
        
        for w in 0..<width {
            for h in 0..<height {
                let index = (w * width) + h
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
