//
//  BinarizationViewController.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

final class BinarizationViewController: UIViewController {

    @IBOutlet private weak var comparisonConversionView: ComparisonConversionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comparisonConversionView.setup(target: self, action: #selector(convertImage), segmentedControlDelegate: self)
    }
    
    @objc func convertImage() {
        if let image = comparisonConversionView.beforeImage.image {
            let filter = BinarizationFilter(threshold: 0.3)
            filter.inputImage = CIImage(image: image)
            
            if let output = filter.outputImage {
                let bwUIImage = UIImage(ciImage: output)
                comparisonConversionView.afterImage.image = bwUIImage
            }
        } else {
            comparisonConversionView.afterImage.image = UIImage(named: "error")
        }
        
        
//        if let image = comparisonConversionView.beforeImage.image,
//           let pixelBuffer = PixelBuffer(uiImage: image) {
//            let (r, g, b, a) = pixelBuffer.getRGBA()
//            comparisonConversionView.afterImage.image = image.createBinarizedImage(r: r, g: g, b: b, a: a)
//
//        } else {
//            comparisonConversionView.afterImage.image = UIImage(named: "error")
//        }
    }
}

extension BinarizationViewController: CustomSegmentedControlViewDelegate {
    func changeSelectedRow(number: Int) {
        print("値が切り替えられたよ")
    }
}

extension UIImage {
    func createBinarizedImage(threshold: CGFloat = 128/255, r:[CGFloat], g: [CGFloat], b:[CGFloat], a:[CGFloat]) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width:Int = Int(size.width)
        let height:Int = Int(size.height)
        let threshold:CGFloat = threshold
        for w in 0..<width {
            for h in 0..<height {
                let index = (w * width) + h
                var color = 0.2126 * r[index] + 0.7152 * g[index] + 0.0722 * b[index]
                color = color > threshold ? 255 : 0
                UIColor(red: color, green: color, blue: color, alpha: a[index]).setFill()
                let drawRect = CGRect(x: w, y: h, width: 1, height: 1)
                UIRectFill(drawRect)
                draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
            }
        }
        let binarizeImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return binarizeImage
    }
}
