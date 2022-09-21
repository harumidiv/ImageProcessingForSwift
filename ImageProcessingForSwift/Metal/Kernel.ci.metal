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
    
    float4 channelSwapFilter(sample_t image)
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
        // 差分の絶対値取得
        float r = abs(image.r - subImage.r);
        float g = abs(image.g - subImage.g);
        float b = abs(image.b - subImage.b);
        
        // 二値化
        float3 inColor = float3(r, g, b);
        float gray = dot(kRec709Luma, inColor);
        inColor = float3(step(threshold, gray));
        return float4(inColor.r, inColor.g ,inColor.b, image.a);
    }
    
    float4 frameSubtractionFilter(sample_t imageA, sample_t imageB, sample_t imageC, float threshold)
    {
        // 差分の絶対値取得
        float3 abDiff = abs(imageA.rgb - imageB.rgb);
        float3 bcDiff = abs(imageB.rgb - imageC.rgb);
        
        // 二値化
        float gray1 = dot(kRec709Luma, abDiff);
        abDiff = float3(step(threshold, gray1));
        
        float gray2 = dot(kRec709Luma, bcDiff);
        bcDiff = float3(step(threshold, gray2));
        
        // 二値化してるので比較は１つの要素で良い
        if (abDiff.r == bcDiff.r) {
            return float4(0, 0 ,0, 1);
        } else {
            return float4(1, 1 ,1, 1);
        }
    }
    
}}
