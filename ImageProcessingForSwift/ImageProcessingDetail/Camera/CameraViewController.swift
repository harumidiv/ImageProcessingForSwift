//
//  CameraViewController.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/19.
//

import UIKit
import GLKit
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

protocol AVCaptureDelegate {
    func capture(image: UIImage)
}

final class AVCapture:NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession: AVCaptureSession!
    var delegate: AVCaptureDelegate?
    
    private var prevImage: CIImage?
    
    // DISMISS_COUNT に1回画像処理 （captureの実行)
    var counter = 0
    let DISMISS_COUNT = 5
    
    override init(){
        super.init()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        
        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
        videoDevice?.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 30)
        
        
        let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice!)
        captureSession.addInput(videoInput)
        
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String : Int(kCVPixelFormatType_32BGRA)]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        // 先にセッションにOutput情報を追加
        captureSession.addOutput(videoDataOutput)
        
        // カメラの向きの変更
        for connection in videoDataOutput.connections {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
        }
        
        // 内部パラメーターの配信を有効にする
        // isCameraIntrinsicMatrixDeliverySupported がtrueの場合のみ
        videoDataOutput.connections.first?.isCameraIntrinsicMatrixDeliveryEnabled = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        
    }
    
    // 新しいキャプチャの追加で呼ばれる関数
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if (counter % DISMISS_COUNT) == 0 {
            
            let image = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
            delegate?.capture(image: image)
            
            // カメラの内部パラメーターの入手
            
            if let camData = CMGetAttachment(sampleBuffer,
                                             key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix,
                                             attachmentModeOut: nil) as? Data {
                
                let matrix: matrix_float3x3 = camData.withUnsafeBytes { $0.pointee }
                print(matrix)
            }
        }
        counter += 1
    }
    
    // SampleBufferからUIImageの作成
    func imageFromSampleBuffer(sampleBuffer :CMSampleBuffer) -> UIImage {
        
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        // イメージバッファのロック
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        // 画像情報を取得
        let base = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)!
        let bytesPerRow = UInt(CVPixelBufferGetBytesPerRow(imageBuffer))
        let width = UInt(CVPixelBufferGetWidth(imageBuffer))
        let height = UInt(CVPixelBufferGetHeight(imageBuffer))
        
        // ビットマップコンテキスト作成
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerCompornent = 8
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) as UInt32)
        let newContext = CGContext(data: base, width: Int(width), height: Int(height), bitsPerComponent: Int(bitsPerCompornent), bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)! as CGContext
        
        // イメージバッファのアンロック
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        // 画像作成
        let imageRef = newContext.makeImage()!
        let ciImage = CIImage(cgImage: imageRef, options: nil)
    
        guard let prevImage = prevImage else {
            self.prevImage = ciImage
            return UIImage(cgImage: imageRef, scale: 1.0, orientation: UIImage.Orientation.up)
        }

        
        let filter = BackgroundSubtractionFilter(inputImage: ciImage, threshold: 0.1, subImage: prevImage)
        
        if let output = filter.outputImage {
            self.prevImage = ciImage
            return UIImage(ciImage: output)
        }  else {
            self.prevImage = ciImage
            return UIImage(cgImage: imageRef, scale: 1.0, orientation: UIImage.Orientation.up)
        }
    }
}
