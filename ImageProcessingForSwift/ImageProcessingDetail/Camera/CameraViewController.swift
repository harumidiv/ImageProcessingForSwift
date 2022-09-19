//
//  CameraViewController.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/19.
//

import UIKit
import GLKit
import AVFoundation

class CameraViewController: UIViewController {
    let captureSession = AVCaptureSession()
    
    lazy var videoInput = { () -> AVCaptureDeviceInput in
        //デフォルトだと背面のカメラが使用される
        let videoDevice = AVCaptureDevice.default(for: .video)
        return try! AVCaptureDeviceInput.init(device: videoDevice!)
    }()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        return AVCaptureVideoPreviewLayer(session: self.captureSession)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //背面カメラで入力することを紐づける
        captureSession.addInput(videoInput)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        //重いので非同期！
        DispatchQueue.global(qos: .userInitiated).async {
            //こいつが開始されるとカメラの画像がViewに反映される
            self.captureSession.startRunning()
        }
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}
