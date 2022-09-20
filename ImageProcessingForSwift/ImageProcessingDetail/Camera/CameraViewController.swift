//
//  CameraViewController.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/19.
//

import UIKit
import AVFoundation

final class CameraViewController: UIViewController, AVCaptureDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let avCapture = AVCapture()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        avCapture.delegate = self
    }
    
    func capture(image: UIImage) {
        
        // 何かしらの画像処理
        imageView.image = image
        
    }
}
