//
//  BackgroundSubtractionViewController.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

final class BackgroundSubtractionViewController: UIViewController {

    @IBOutlet private weak var comparisonConversionView: ComparisonConversionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comparisonConversionView.setup(target: self, action: #selector(convertImage))
    }
    
    @objc func convertImage() {
        if let image = comparisonConversionView.beforeImage.image,
           let inputImage = CIImage(image: image),
           let subImage = UIImage(named: "backgroundSubtraction"),
           let subCIImage = subImage.toCIImage() {
            let filter = BackgroundSubtractionFilter(inputImage: inputImage,
                                                     threshold: 0.8,
                                                     subImage: subCIImage)
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
//            comparisonConversionView.afterImage.image = image.createBackgroundSubtractionImage(subtractionImage: UIImage(named: "backgroundSubtraction"), r: r, g: g, b: b, a: a)
//
//        } else {
//            comparisonConversionView.afterImage.image = UIImage(named: "error")
//        }
    }
    
    @IBAction func tapAction(_ sender: Any) {
        self.present(FrameSubtractionViewController.loadFromNib(), animated: true)
//        self.present(GrayscaleConversionViewController.loadFromNib(), animated: true)
    }
}

extension UIImage {
    func createBackgroundSubtractionImage(subtractionImage: UIImage?, r:[CGFloat], g: [CGFloat], b:[CGFloat], a:[CGFloat]) -> UIImage? {
        guard let subtractionImage = subtractionImage,
              let pixelBuffer = PixelBuffer(uiImage: subtractionImage) else {
            return UIImage(named: "error")
        }
        
        let (subR, subG, subB, _) = pixelBuffer.getRGBA()
        
        
        let width:Int = Int(size.width)
        let height:Int = Int(size.height)
     
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        for w in 0..<width {
            for h in 0..<height {
                let index = (w * width) + h
                let isMatchColor: Bool = r[index] == subR[index]
                                      && g[index] == subG[index]
                                      && b[index] == subB[index]
                let color: CGFloat = isMatchColor ? 255 : 0
                UIColor(red: color, green: color, blue: color, alpha: a[index]).setFill()
                let drawRect = CGRect(x: w, y: h, width: 1, height: 1)
                UIRectFill(drawRect)
                draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
            }
        }
        let differenceImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return differenceImage
    }
    
    private func binarization(width: Int, height: Int, r:[CGFloat], g: [CGFloat], b:[CGFloat]) -> (r:[CGFloat], g: [CGFloat], b:[CGFloat]) {
        let threshold:CGFloat = 128/255
        var binarizedColor:[CGFloat] = []
       
        for w in 0..<width {
            for h in 0..<height {
                let index = (w * width) + h
                var color = 0.2126 * r[index] + 0.7152 * g[index] + 0.0722 * b[index]
                color = color > threshold ? 255 : 0
                binarizedColor.append(color)
            }
        }
        return (r: binarizedColor, g: binarizedColor, b: binarizedColor)
    }
}
