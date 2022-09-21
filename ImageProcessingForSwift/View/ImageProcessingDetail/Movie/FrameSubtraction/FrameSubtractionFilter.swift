//
//  FrameSubtractionFilter.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/20.
//

import UIKit

final class FrameSubtractionFilter: CIFilter {
    private let imageA: CIImage
    private let imageB: CIImage
    private let imageC: CIImage
    private let threshold: CGFloat
    
    init(imageA: CIImage, imageB: CIImage, imageC: CIImage, threshold: CGFloat) {
        self.imageA = imageA
        self.imageB = imageB
        self.imageC = imageC
        self.threshold = threshold
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        let url = Bundle.main.url(forResource: "Kernel", withExtension: "ci.metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIColorKernel(functionName: "frameSubtractionFilter", fromMetalLibraryData: data)
    }()
    
    override var outputImage: CIImage? {
        get {
            return FrameSubtractionFilter.kernel.apply(extent: imageA.extent,
                                                       arguments: [imageA,
                                                                   imageB,
                                                                   imageC,
                                                                   threshold])
        }
    }
}
