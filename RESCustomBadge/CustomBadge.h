//
//  RESSyncBadge.h
//  RESCustomBadge
//
//  Created by Robert St. John on 6/15/17.
//  Copyright © 2017 Robert St. John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeStyle.h"

@interface CustomBadge : UIView

@property(nonatomic, strong) NSString *badgeText;
@property(nonatomic) CGFloat badgeCornerRoundness;
@property(nonatomic) CGFloat badgeScaleFactor;
@property(nonatomic, strong) BadgeStyle *badgeStyle;

+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString;
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withScale:(CGFloat)scale;
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStyle:(BadgeStyle*)style;
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withScale:(CGFloat)scale withStyle:(BadgeStyle*)style;

- (void) autoBadgeSizeWithString:(NSString *)badgeString;

@end
