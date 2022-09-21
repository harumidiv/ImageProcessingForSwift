//
//  GrayscaleConversionViewController.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

final class GrayscaleConversionViewController: UIViewController {
    @IBOutlet private weak var comparisonConversionView: ComparisonConversionView!
    private var selectedType: SelectedType = .metal
    private let indicatorViewController: IndicatorViewController = IndicatorViewController.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comparisonConversionView.setup(target: self,
                                       action: #selector(convertImage),
                                       segmentedControlDelegate: self)
    }

    @objc private func convertImage() {
        guard let image = comparisonConversionView.beforeImage.image,
              let pixelBuffer = PixelBuffer(uiImage: image) else {
            comparisonConversionView.afterImage.image = UIImage(named: "error")
            return
        }
        
        indicatorViewController.modalPresentationStyle = .overCurrentContext
        self.present(self.indicatorViewController, animated: false) {
            switch self.selectedType {
            case .metal:
                let filter = GrayscaleFilter()
                filter.inputImage = CIImage(image: image)
                
                if let output = filter.outputImage {
                    self.comparisonConversionView.afterImage.image = UIImage(ciImage: output)
                } else {
                    self.comparisonConversionView.afterImage.image = UIImage(named: "error")
                }
                
            case .uikit:
                let (r, g, b, a) = pixelBuffer.getRGBA()
                self.comparisonConversionView.afterImage.image = image.createGrayImage(r: r, g: g, b: b, a: a)
            }
        }
        indicatorViewController.dismiss(animated: false)
    }
}

extension GrayscaleConversionViewController: CustomSegmentedControlViewDelegate {
    func changeSelectedRow(number: Int) {
        selectedType = .init(rawValue: number) ?? .metal
    }
}

extension UIImage {
    func createGrayImage(r:[CGFloat], g: [CGFloat], b:[CGFloat], a:[CGFloat]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width:Int = Int(size.width)
        let height:Int = Int(size.height)
        
        for w in 0..<width {
            for h in 0..<height {
                let index = (w * width) + h
                let color = 0.2126 * r[index] + 0.7152 * g[index] + 0.0722 * b[index]
                UIColor(red: color, green: color, blue: color, alpha: a[index]).setFill()
                let drawRect = CGRect(x: w, y: h, width: 1, height: 1)
                UIRectFill(drawRect)
                draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
            }
        }
        let grayImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return grayImage
    }
}
