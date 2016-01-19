//
//  NSTimer+Category.m
//  Effective ObjC
//
//  Created by 汪安军 on 15/7/18.
//  code is modified from book named << Effective Objective-C 2.0 >>
//

#import "NSTimer+Category.h"

@implementation NSTimer (Category)

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void (^)())block {
    return [self timerWithTimeInterval:ti target:self selector:@selector(blockInvoke:) userInfo:[block copy] repeats:yesOrNo];
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void (^)())block {
    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(blockInvoke:) userInfo:[block copy] repeats:yesOrNo];
}

+ (void)blockInvoke:(NSTimer *)timer {
    
    void (^blcok)() = timer.userInfo;
    if (blcok) {
        blcok();
    }
}

@end
