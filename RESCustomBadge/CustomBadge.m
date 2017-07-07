//
//  RESSyncBadge.m
//  RESCustomBadge
//
//  Created by Robert St. John on 6/15/17.
//  Copyright © 2017 Robert St. John. All rights reserved.
//

#import "CustomBadge.h"


@interface CustomBadge ()

@property(nonatomic) UIFont *badgeFont;
@property (nonatomic) CGFloat lineSize;
@property (nonatomic) CGFloat arrowWidth;

- (void) drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect;
- (void) drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect;

@end


@implementation CustomBadge

// I recommend to use one of the allocators like customBadgeWithString
- (id) initWithString:(NSString *)badgeString withScale:(CGFloat)scale withStyle:(BadgeStyle*)style
{
    self = [super initWithFrame:CGRectMake(0, 0, 25, 25)];
    if(self!=nil) {
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor clearColor];
        self.badgeText = badgeString;
        self.badgeStyle = style;
        self.badgeCornerRoundness = 0.4;
        self.badgeScaleFactor = scale;
        [self autoBadgeSizeWithString:badgeString];
    }
    return self;
}


// Use this method if you want to change the badge text after the first rendering
- (void) autoBadgeSizeWithString:(NSString *)badgeString
{
    CGSize retValue;
    CGFloat rectWidth, rectHeight;
    NSDictionary *fontAttr = @{ NSFontAttributeName : [self fontForBadgeWithSize:12] };
    CGSize stringSize = [badgeString sizeWithAttributes:fontAttr];
    CGFloat flexSpace;
    CGFloat scale = self.badgeScaleFactor;
    if ([badgeString length]>=2) {
        flexSpace = [badgeString length];
        rectWidth = 25 + (stringSize.width + flexSpace); rectHeight = 25;
        retValue = CGSizeMake(rectWidth * scale, rectHeight * scale);
    } else {
        retValue = CGSizeMake(25 * scale, 25 * scale);
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
    self.badgeText = badgeString;
    [self setNeedsDisplay];
}


// Creates a Badge with a given Text in default BadgeStyle and normal scale
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString
{
    return [[self alloc] initWithString:badgeString withScale:1.0 withStyle:[BadgeStyle defaultStyle]];
}

// Creates a Badge with a given Text in default BadgeStyle and given scale
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withScale:(CGFloat)scale {

    return [[self alloc] initWithString:badgeString withScale:scale withStyle:[BadgeStyle defaultStyle]];

}

// Creates a Badge with a given Text in given BadgeStyle and normal scale
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStyle:(BadgeStyle*)style
{
    return [[self alloc] initWithString:badgeString withScale:1.0 withStyle:style];
}


// Creates a Badge with a given Text in given BadgeStyle and a given scale
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withScale:(CGFloat)scale withStyle:(BadgeStyle*)style {

    return [[self alloc] initWithString:badgeString withScale:scale withStyle:style];

}


// Draws the Badge with Quartz
-(void) drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextSaveGState(context);

    CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
    CGFloat puffer = CGRectGetMaxY(rect)*0.10;
    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;

    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [self.badgeStyle.badgeInsetColor CGColor]);
    CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
    CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
    CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
    CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
    if (self.badgeStyle.badgeShadow) {
        CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 3, [[UIColor blackColor] CGColor]);
    }
    CGContextFillPath(context);

    CGContextRestoreGState(context);

}

// Draws the Badge Shine with Quartz
-(void) drawShineWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextSaveGState(context);

    CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
    CGFloat puffer = CGRectGetMaxY(rect)*0.10;
    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;
    CGContextBeginPath(context);
    CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
    CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
    CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
    CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
    CGContextClip(context);


    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 0.4 };
    CGFloat components[8] = {  0.92, 0.92, 0.92, 1.0, 0.82, 0.82, 0.82, 0.4 };

    CGColorSpaceRef cspace;
    CGGradientRef gradient;
    cspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);

    CGPoint sPoint, ePoint;
    sPoint.x = 0;
    sPoint.y = 0;
    ePoint.x = 0;
    ePoint.y = maxY;
    CGContextDrawLinearGradient (context, gradient, sPoint, ePoint, 0);

    CGColorSpaceRelease(cspace);
    CGGradientRelease(gradient);

    CGContextRestoreGState(context);
}


// Draws the Badge Frame with Quartz
-(void) drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    CGFloat radius = CGRectGetMaxY(rect) * self.badgeCornerRoundness;
    CGFloat puffer = CGRectGetMaxY(rect) * 0.10;

    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;
    CGFloat midY = CGRectGetMidY(rect);

    CGFloat scale = self.badgeScaleFactor;
    CGColorRef strokeColor = self.badgeStyle.badgeFrameColor.CGColor;

    CGFloat lineSize = 2;
    if (scale > 1) {
        lineSize += scale * 0.25;
    }
    CGFloat arrowWidth = 1.75 * lineSize;
    CGFloat arrowHeight = 2 * arrowWidth;

    CGContextSaveGState(context);

    CGContextTranslateCTM(context, 0.0, CGRectGetHeight(rect));
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetStrokeColorWithColor(context, strokeColor);
    CGContextSetFillColorWithColor(context, strokeColor);

    // top-left to top-right
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, lineSize);

    // top-left
    CGContextAddArc(context, maxX - radius, maxY - radius, radius, M_PI / 3, M_PI / 2, 0);
    // top-right
    CGContextAddArc(context, minX + radius, minY + radius, radius, M_PI / 2, M_PI, 0);
    CGPoint endPoint = CGContextGetPathCurrentPoint(context);
    CGContextStrokePath(context);
    // arrow
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, endPoint.x - arrowWidth, endPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y - arrowHeight);
    CGContextAddLineToPoint(context, endPoint.x + arrowWidth, endPoint.y);
    CGContextFillPath(context);

    CGContextMoveToPoint(context, minX, midY);

    // bottom-left to bottom-right
    CGContextBeginPath(context);
    // bottom-left
    CGContextAddArc(context, minX + radius, maxY - radius, radius, M_PI + M_PI / 3, -M_PI / 2, 0);
    // bottom-right
    CGContextAddArc(context, maxX - radius, minY + radius, radius, -M_PI / 2, 0, 0);
    endPoint = CGContextGetPathCurrentPoint(context);
    CGContextStrokePath(context);
    // arrow
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, endPoint.x - arrowWidth, endPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y + arrowHeight);
    CGContextAddLineToPoint(context, endPoint.x + arrowWidth, endPoint.y);
    CGContextFillPath(context);

    CGContextRestoreGState(context);
}

- (UIFont*) fontForBadgeWithSize:(CGFloat)size {
    switch (self.badgeStyle.badgeFontType) {
        case BadgeStyleFontTypeHelveticaNeueMedium:
            return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
            break;
        default:
            return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
            break;
    }
}

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRoundedRectWithContext:context withRect:rect];

    if(self.badgeStyle.badgeShining) {
        [self drawShineWithContext:context withRect:rect];
    }

    if (self.badgeStyle.badgeFrame)  {
        [self drawFrameWithContext:context withRect:rect];
    }

    if ([self.badgeText length]>0) {
        CGFloat sizeOfFont = 13.5 * self.badgeScaleFactor;
        if ([self.badgeText length]<2) {
            sizeOfFont += sizeOfFont * 0.20f;
        }
        UIFont *textFont =  [self fontForBadgeWithSize:sizeOfFont];
        NSDictionary *fontAttr = @{ NSFontAttributeName : textFont, NSForegroundColorAttributeName : self.badgeStyle.badgeTextColor };
        CGSize textSize = [self.badgeText sizeWithAttributes:fontAttr];
        CGPoint textPoint = CGPointMake((rect.size.width/2-textSize.width/2), (rect.size.height/2-textSize.height/2) - 1 );
        [self.badgeText drawAtPoint:textPoint withAttributes:fontAttr];
    }
}


@end
