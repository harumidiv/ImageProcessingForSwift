//
//  GrayscaleFilter.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/18.
//

import UIKit

final class GrayscaleFilter: CIFilter {
    var inputImage: CIImage?
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        let url = Bundle.main.url(forResource: "Kernel", withExtension: "ci.metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIColorKernel(functionName: "grayscaleFilter", fromMetalLibraryData: data)
    }()
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return GrayscaleFilter.kernel.apply(extent: input.extent, arguments: [input])
        }
    }
}
