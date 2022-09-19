//
//  BackgroundSubtractionFilter.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/18.
//

import UIKit

final class BackgroundSubtractionFilter: CIFilter {
    private let inputImage: CIImage
    private let threshold: CGFloat
    private let subImage: CIImage
    
    init(inputImage: CIImage, threshold: CGFloat, subImage: CIImage) {
        self.inputImage = inputImage
        self.threshold = threshold
        self.subImage = subImage
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        let url = Bundle.main.url(forResource: "Kernel", withExtension: "ci.metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIColorKernel(functionName: "backgroundSubtractionFilter", fromMetalLibraryData: data)
    }()
    
    override var outputImage: CIImage? {
        get {
            let input = inputImage
            return BackgroundSubtractionFilter.kernel.apply(extent: input.extent, arguments: [input, subImage, threshold])
        }
    }
}
