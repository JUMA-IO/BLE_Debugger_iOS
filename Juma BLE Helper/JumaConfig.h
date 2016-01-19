//
//  JumaConfig.h
//  JumaBluetoothSDK
//
//  Created by 汪安军 on 15/6/24.
//  Copyright (c) 2015年 JUMA. All rights reserved.
//

#ifndef JumaDevice_JumaConfig_h
#define JumaDevice_JumaConfig_h

#ifdef __OBJC__

    // 自定义的打印函数
    #if DEBUG
    #define JMLog(...) NSLog(@"file = %@, line = %@, %@", [@__FILE__ lastPathComponent], @(__LINE__), [NSString stringWithFormat:__VA_ARGS__])
    #else
    #define JMLog(...) //NSLog(@"file = %@, line = %@, %@", [@__FILE__ lastPathComponent], @(__LINE__), [NSString stringWithFormat:__VA_ARGS__])
    #endif

#define FORMAT(...) ([NSString stringWithFormat:__VA_ARGS__])

#endif


#endif
