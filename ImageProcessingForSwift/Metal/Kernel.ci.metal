//
//  Kernel.ci.metal
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/18.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

constant float3 kRec709Luma  = float3(0.2126, 0.7152, 0.0722);

extern "C" { namespace coreimage {
    
    float4 grayscaleFilter(sample_t image)
    {
        float3 inColor = float3(image.r, image.g, image.b);
        // dot積 == 内積
        half gray = dot(kRec709Luma, inColor);
        return float4(gray, gray, gray, image.a);
    }
    
    float4 channelSwapFilter(sample_t image, float rNum, float gNum, float bNum)
    {
        return float4(image.b, image.r ,image.g, image.a);
    }
    
    float4 binarizationFilter(sample_t image, float threshold)
    {
        float3 inColor = float3(image.r, image.g, image.b);
        float gray = dot(kRec709Luma, inColor);
        inColor = float3(step(threshold, gray));
        return float4(inColor.r, inColor.g ,inColor.b, image.a);
    }
    
    float4 backgroundSubtractionFilter(sample_t image, sample_t subImage, float threshold)
    {
        float3 inColor = float3(0, 0, 0);
        if (image.r == subImage.r && image.g == subImage.g && image.b == subImage.b) {
            inColor = float3(1, 1, 1);
        }
        
        float gray = dot(kRec709Luma, inColor);
        inColor = float3(step(threshold, gray));
        return float4(inColor.r, inColor.g ,inColor.b, image.a);
    }
    
}}
