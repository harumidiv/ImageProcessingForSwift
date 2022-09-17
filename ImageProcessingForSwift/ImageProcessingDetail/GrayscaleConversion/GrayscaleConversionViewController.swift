//
//  GrayscaleConversionViewController.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

class GrayscaleConversionViewController: UIViewController {
    @IBOutlet weak var comparisonConversionView: ComparisonConversionView!
    
    var r:[CGFloat] = []
    var g:[CGFloat] = []
    var b:[CGFloat] = []
    var a:[CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        comparisonConversionView.setup(target: self, action: #selector(convertImage))
    }

    @objc func convertImage() {
        
    }
}

extension UIImage {
    func createGrayImage(r:[CGFloat], g: [CGFloat], b:[CGFloat], a:[CGFloat]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let wid:Int = Int(size.width)
        let hei:Int = Int(size.height)
        
        for w in 0..<wid {
            for h in 0..<hei {
                let index = (w * wid) + h
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
