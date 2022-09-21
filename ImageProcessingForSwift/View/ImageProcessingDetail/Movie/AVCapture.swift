//
//  AVCapture.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/20.
//

import UIKit
import AVFoundation

protocol AVCaptureDelegate: AnyObject {
    func capture(image: CGImage)
}

final class AVCapture:NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    weak var delegate: AVCaptureDelegate?
    
    private lazy var videoInput = { () -> AVCaptureDeviceInput in
        //デフォルトだと背面のカメラが使用される
        let videoDevice = AVCaptureDevice.default(for: .video)
        return try! AVCaptureDeviceInput.init(device: videoDevice!)
    }()
    
    private var captureSession: AVCaptureSession = AVCaptureSession()
    
    override init(){
        super.init()
        
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
        let image = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        delegate?.capture(image: image)
    }
    
    // SampleBufferからUIImageの作成
    func imageFromSampleBuffer(sampleBuffer :CMSampleBuffer) -> CGImage {
        
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
        return newContext.makeImage()!
    }
}

