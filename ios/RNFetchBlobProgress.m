//
//  RNFetchBlobProgress.m
//  RNFetchBlob
//
//  Created by Ben Hsieh on 2016/9/25.
//  Copyright © 2016年 wkh237.github.io. All rights reserved.
//

#import "RNFetchBlobProgress.h"

@interface RNFetchBlobProgress ()
{
    float progress;
    int tick;
    double lastTick;
    double lastProgress;
}
@end

@implementation RNFetchBlobProgress

-(id)initWithType:(ProgressType)type interval:(NSNumber *)interval count:(NSNumber *)count
{
    self = [super init];
    self.count = count;
    self.interval = [NSNumber numberWithFloat:[interval floatValue] /1000];
    self.type = type;
    self.enable = YES;
    lastTick = 0;
    lastProgress = 0;
    tick = 1;
    return self;
}

-(BOOL)shouldReport:(NSNumber *)nextProgress
{
    double nextProgressObj = [nextProgress doubleValue];
    if(nextProgressObj < lastProgress){
        return NO;
    }
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    
    if(lastTick == 0){
        tick++;
        lastTick = [timeStampObj doubleValue];
        return YES;
    }
    
    BOOL shouldReport = tick*[self.interval doubleValue] + lastTick < timeStamp;
    if(shouldReport)
    {
        tick++;
    }
    lastProgress = [nextProgress doubleValue];
    return shouldReport;
}


@end
