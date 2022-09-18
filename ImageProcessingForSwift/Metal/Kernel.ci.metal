//
//  Kernel.ci.metal
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/18.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {    
    float4 grayscaleFilter(sample_t image) {
        half y = 0.2126 * image.r + 0.7152 * image.g + 0.0722 * image.b;
        return float4(y, y, y, image.a);
    }
    
}}
