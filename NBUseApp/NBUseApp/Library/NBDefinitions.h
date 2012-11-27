//
//  NBDefinitions.h
//  NBUseApp
//
//  Created by jz on 28/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#ifndef NBUseApp_NBDefinitions_h
#define NBUseApp_NBDefinitions_h

#define kNBLogDefault   1
#define kNBLogNetwork   2
#define kNBLogCommands  3
#define kNBLogVideo     4
#define kNBLogReadings  5

#define NBLog(num, formatString, ...) if ((num==kNBLogDefault)  \
|| (num==kNBLogCommands)    \
|| (num==kNBLogReadings)    \
) {NSLog(formatString, ##__VA_ARGS__);}

//|| (num==kNBLogNetwork)     \


#endif
