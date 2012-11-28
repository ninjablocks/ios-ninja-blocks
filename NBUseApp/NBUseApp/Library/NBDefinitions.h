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
#define kNBLogNetwork   0//3
#define kNBLogCommands  4
#define kNBLogVideo     5
#define kNBLogReadings  6
#define kNBLogInit      7

#define NBLog(num, formatString, ...) if (num>kNBLogUnused) {NSLog(formatString, ##__VA_ARGS__);}


#endif
