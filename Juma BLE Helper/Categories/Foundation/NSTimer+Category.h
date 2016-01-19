//
//  NSTimer+Category.h
//  Effective ObjC
//
//  Created by 汪安军 on 15/7/18.
//  code is modified from book named << Effective Objective-C 2.0 >>
//

#import <Foundation/Foundation.h>

@interface NSTimer (Category)

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void (^)())block;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void (^)())block;

@end
