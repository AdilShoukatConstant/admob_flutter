//
//  FLTRequestFactory.h
//  Pods
//
//  Created by 유송이 on 2021/01/05.
//

#import "GoogleMobileAds/GoogleMobileAds.h"

@interface FLTRequestFactory : NSObject

- (instancetype)initWithTargetingInfo:(NSDictionary *)targetingInfo;
- (GADRequest *)createRequest;

@end
