//
//  BinarizationFilter.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/18.
//

import UIKit


final class BinarizationFilter: CIFilter {
    var inputImage: CIImage?
    private var threshold: CGFloat
    
    init(threshold: CGFloat) {
        self.threshold = threshold
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        let url = Bundle.main.url(forResource: "Kernel", withExtension: "ci.metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIColorKernel(functionName: "binarizationFilter", fromMetalLibraryData: data)
    }()
        
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return BinarizationFilter.kernel.apply(extent: input.extent, arguments: [input, threshold])
        }
    }
}
