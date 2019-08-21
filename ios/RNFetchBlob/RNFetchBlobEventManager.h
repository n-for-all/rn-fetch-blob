//
//  RNFetchBlobEventManager.h
//
//  Created by Naji Amer on 8/20/19.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RNFetchBlobEventManager : RCTEventEmitter <RCTBridgeModule>

@property(nonnull, nonatomic) NSMutableArray<NSString *> * _supportedEvents;
+ (void)dispatchEvent:(NSString *)name body:(id)body;
+ (void)addSupportedEvent:(NSString *)name;
+ (void)removeSupportedEvent:(NSString *)name;
@end

