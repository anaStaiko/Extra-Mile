//
//  Filters.m
//  MyMedia
//
//  Created by Anastasiia Staiko on 4/5/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//


#import "Filters.h"

@class ThumbNail;

@implementation Filters


// Create and return the Array of Filters
+(NSArray *)getAllFilters{
    NSArray *myArray = [NSArray arrayWithObjects:@"Vintage", @"Black & White", @"Monochrome Blue", @"Invert", @"Noise", @"More Brightness", @"Increase Saturation",@"Shadow Adjust",@"Posterize", @"Hue Adjust", @"Gamma Adjust", @"Exposure Adjust", @"Vignette",@"Sepia", @"Photo Effect Transfer", @"Photo Effect Process", @"Motion Blur", @"Pointillize", @"Aquamarine", @"Monochrome Red", nil];
    
    //sorting the Array alphabetically
    myArray = [myArray sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
    
    return myArray;
}

//Definition of the Filters from above returning the output Image of the Filter(CIImage)
+(CIImage *) changeImage:(CIImage *) image withFilter:(NSString *) filter{
    if ([filter isEqualToString:@"Vintage"]) {
        
        CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
        [sepia setValue:image forKey:kCIInputImageKey];
        [sepia setValue:@(0.9) forKey:@"inputIntensity"];
        CIFilter *composite = [CIFilter filterWithName:@"CIHardLightBlendMode"];
        [composite setValue:sepia.outputImage forKey:kCIInputImageKey];
        CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
        [vignette setValue:composite.outputImage forKey:kCIInputImageKey];
        [vignette setValue:@(1.6) forKey:@"inputIntensity"];
        [vignette setValue:@(24) forKey:@"inputRadius"];
        return vignette.outputImage;
        
    } else if ([filter isEqualToString:@"Black & White"]) {
        CIFilter *filt = [CIFilter filterWithName:@"CIColorMonochrome"];
        [filt setValue:image forKey:kCIInputImageKey];
        [filt setValue:[CIColor colorWithRed:.5 green:.5 blue:.5] forKey:@"inputColor"];
        [filt setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
        return filt.outputImage;
        
    }else if ([filter isEqualToString:@"Monochrome Blue"]) {
        CIFilter *filt = [CIFilter filterWithName:@"CIColorMonochrome"];
        [filt setValue:image forKey:kCIInputImageKey];
        [filt setValue:[CIColor colorWithRed:0 green:0.5 blue:0.8] forKey:@"inputColor"];
        [filt setValue:[NSNumber numberWithFloat:0.8] forKey:@"inputIntensity"];
        return filt.outputImage;
        
    } else if ([filter isEqualToString:@"Invert"]) {
        CIFilter *invertFilter = [CIFilter filterWithName:@"CIColorInvert"];
        [invertFilter setDefaults];
        [invertFilter setValue: image forKey: @"inputImage"];
        return invertFilter.outputImage;
        
    }else if([filter isEqualToString:@"Noise"]){
        CIFilter *random = [CIFilter filterWithName:@"CIRandomGenerator"];
        CIImage *croppedImage = [random.outputImage imageByCroppingToRect:[image extent]];
        CIFilter *composite = [CIFilter filterWithName:@"CIHardLightBlendMode"];
        [composite setValue:image forKey:kCIInputImageKey];
        [composite setValue:croppedImage forKey:kCIInputBackgroundImageKey];
        return composite.outputImage;
        
    }else if([filter isEqualToString:@"More Brightness"]){
        CIFilter *brightnesContrastFilter = [CIFilter filterWithName:@"CIColorControls"];
        [brightnesContrastFilter setDefaults];
        [brightnesContrastFilter setValue: image forKey: @"inputImage"];
        [brightnesContrastFilter setValue: [NSNumber numberWithFloat:0.5f]
                                   forKey:@"inputBrightness"];
        [brightnesContrastFilter setValue: [NSNumber numberWithFloat:2.0f]
                                   forKey:@"inputContrast"];
                return [brightnesContrastFilter outputImage];
        
    }else if([filter isEqualToString:@"Increase Saturation"]){
        CIFilter *colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];
        [colorControlsFilter setDefaults];
        [colorControlsFilter setValue:image forKey:@"inputImage"];
        [colorControlsFilter setValue:[NSNumber numberWithFloat:1.5] forKey:@"inputSaturation"];
        [colorControlsFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputContrast"];
        return [colorControlsFilter outputImage];

    }else if([filter isEqualToString:@"Shadow Adjust"]){
        CIFilter *adjustFilter = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
        [adjustFilter setDefaults];
        [adjustFilter setValue:image forKey:kCIInputImageKey];
        [adjustFilter setValue:[NSNumber numberWithFloat:0.3] forKey:@"inputShadowAmount"];
        return adjustFilter.outputImage;
        
    }else if([filter isEqualToString:@"Posterize"]){
        CIFilter *posterize = [CIFilter filterWithName:@"CIColorPosterize"];
        [posterize setDefaults];
        [posterize setValue:image forKey:@"inputImage"];
        [posterize setValue:[NSNumber numberWithDouble:10.0] forKey:@"inputLevels"];
        return [posterize outputImage];
        
    }else if([filter isEqualToString:@"Hue Adjust"]){
        CIFilter *hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];
        [hueAdjust setDefaults];
        [hueAdjust setValue:image forKey:@"inputImage"];
        [hueAdjust setValue:[NSNumber numberWithFloat: 1.0f] forKey:@"inputAngle"];
        return [hueAdjust outputImage];

    }else if([filter isEqualToString:@"Gamma Adjust"]){
        CIFilter *gammaAdjust = [CIFilter filterWithName:@"CIGammaAdjust"];
        [gammaAdjust setDefaults];
        [gammaAdjust setValue: image forKey: @"inputImage"];
        [gammaAdjust setValue: [NSNumber numberWithFloat: 2.0f] forKey: @"inputPower"];
        return [gammaAdjust outputImage];

    }else if([filter isEqualToString:@"Exposure Adjust"]){
        CIFilter *expAdjust = [CIFilter filterWithName:@"CIExposureAdjust"];
        [expAdjust setDefaults];
        [expAdjust setValue: image forKey: @"inputImage"];
        [expAdjust setValue: [NSNumber numberWithFloat: 1.0f] forKey: @"inputEV"];
        return [expAdjust outputImage];
        
    }else if([filter isEqualToString:@"Vignette"]){
        CIFilter *filter = [CIFilter filterWithName:@"CIVignette"
                            keysAndValues: kCIInputImageKey, image,
                            @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
        return [filter outputImage];
        
    }else if([filter isEqualToString:@"Sepia"]){
        CIFilter *myFilter = [CIFilter filterWithName:@"CISepiaTone"];
        [myFilter setDefaults];
        [myFilter setValue:image forKey:@"inputImage"];
        [myFilter setValue:[NSNumber numberWithFloat:0.6f] forKey:@"inputIntensity"];
        return [myFilter outputImage];
        
    } else if([filter isEqualToString:@"Photo Effect Transfer"]){
        CIFilter *myFilterA = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
        [myFilterA setDefaults];
        [myFilterA setValue:image forKey:@"inputImage"];
        return [myFilterA outputImage];
        
    } else if([filter isEqualToString:@"Photo Effect Process"]){
        CIFilter *myFilterB = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
        [myFilterB setDefaults];
        [myFilterB setValue:image forKey:@"inputImage"];
        return [myFilterB outputImage];
        
    } else if([filter isEqualToString:@"Motion Blur"]){
        CIFilter *myFilterC = [CIFilter filterWithName:@"CIMotionBlur"];
        [myFilterC setDefaults];
        [myFilterC setValue:image forKey:@"inputImage"];
        [myFilterC setValue:[NSNumber numberWithFloat:13] forKey:@"inputRadius"];
        [myFilterC setValue:[NSNumber numberWithFloat:0] forKey:@"inputAngle"];
        return [myFilterC outputImage];

    } else if([filter isEqualToString:@"Pointillize"]){
        CIFilter *myFilterE = [CIFilter filterWithName:@"CIPointillize"];
        CIVector *vector = [CIVector vectorWithX:20 Y:20];
        [myFilterE setDefaults];
        [myFilterE setValue:image forKey:@"inputImage"];
        [myFilterE setValue:[NSNumber numberWithFloat:10.00] forKey:@"inputRadius"];
        [myFilterE setValue:vector forKey:@"inputCenter"];
        return [myFilterE valueForKey:@"outputImage"];
        
      }else if ([filter isEqualToString:@"Aquamarine"]) {
        CIFilter *filt = [CIFilter filterWithName:@"CIColorMonochrome"];
        [filt setValue:image forKey:kCIInputImageKey];
        [filt setValue:[CIColor colorWithRed:0.3 green:1.0 blue:0.9] forKey:@"inputColor"];
        [filt setValue:[NSNumber numberWithFloat:0.7] forKey:@"inputIntensity"];
        return [filt outputImage];

      } else if ([filter isEqualToString:@"Monochrome Red"]) {
          CIFilter *filt = [CIFilter filterWithName:@"CIColorMonochrome"];
          [filt setValue:image forKey:kCIInputImageKey];
          [filt setValue:[CIColor colorWithRed:0.8 green:0.4 blue:0.4] forKey:@"inputColor"];
          [filt setValue:[NSNumber numberWithFloat:0.8] forKey:@"inputIntensity"];
          return filt.outputImage;
      }
    
    return nil;
}



@end
