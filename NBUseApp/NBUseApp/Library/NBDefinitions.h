//
//  NBDefinitions.h
//  NBUseApp
//
//  Created by jz on 28/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#ifndef NBUseApp_NBDefinitions_h
#define NBUseApp_NBDefinitions_h

#define kNBLogUnused    0

#define kNBLogError     1
#define kNBLogDefault   2
//#define kNBLogNetwork   3
#define kNBLogCommands  4
//#define kNBLogVideo     5
#define kNBLogReadings  6
//#define kNBLogInit      7
//#define kNBLogLogin     8
//#define kNBLogSettings  9
//#define kNBLogGestures  10

//#define kNBLogError     0
//#define kNBLogDefault   0
#define kNBLogNetwork   0
//#define kNBLogCommands  0
#define kNBLogVideo     0
//#define kNBLogReadings  0
#define kNBLogInit      0
#define kNBLogLogin     0
#define kNBLogSettings  0
#define kNBLogGestures  0


#define NBLog(num, formatString, ...) if (num>kNBLogUnused) {NSLog(formatString, ##__VA_ARGS__);}


#endif
