//
//  FrameSubtractionViewController.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/19.
//

import UIKit
import AVFoundation

final class FrameSubtractionViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    private var prevImageA: CIImage?
    private var prevImageB: CIImage?
    
    let avCapture = AVCapture()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        avCapture.delegate = self
    }
}

extension FrameSubtractionViewController: AVCaptureDelegate {
    
    func capture(image: CGImage) {
        
        let ciImage = CIImage(cgImage: image, options: nil)


        guard let prevImageA = prevImageA,
              let prevImageB = prevImageB else {
            self.prevImageB = prevImageA
            self.prevImageA = ciImage
            
            return
        }


        let filter = FrameSubtractionFilter(imageA: prevImageA,
                                            imageB: prevImageB,
                                            imageC: ciImage,
                                            threshold: 0.1)

        if let output = filter.outputImage {
            self.prevImageB = prevImageA
            self.prevImageA = ciImage
            imageView.image = UIImage(ciImage: output)
        }  else {
            self.prevImageB = prevImageA
            self.prevImageA = ciImage
            imageView.image = UIImage(cgImage: image, scale: 1.0, orientation: UIImage.Orientation.up)
        }        
    }
}
