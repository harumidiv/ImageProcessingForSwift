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
           let pixelBuffer = PixelBuffer(uiImage: image) {
            let (r, g, b, a) = pixelBuffer.getRGBA()
            comparisonConversionView.afterImage.image = image.createBackgroundSubtractionImage(r: r, g: g, b: b, a: a)
            
        } else {
            comparisonConversionView.afterImage.image = UIImage(named: "error")
        }
    }

}

extension UIImage {
    func createBackgroundSubtractionImage(r:[CGFloat], g: [CGFloat], b:[CGFloat], a:[CGFloat]) -> UIImage{
        
        return UIImage()
    }
    
}
