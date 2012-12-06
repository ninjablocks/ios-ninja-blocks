//
//  NBSettings.m
//  NBUseApp
//
//  Created by jz on 6/12/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBSettings.h"

#import "NBDefinitions.h"

#import "NBDeviceManager.h"
#import "NBDevice.h"

#define kSettingsDefaultsKey @"kSettingsDefaultsKey"

#define kSettingsActiveKey          @"kSettingsActiveKey"
#define kSettingsPollIntervalKey    @"kSettingsPollIntervalKey"
#define kSettingsSensitivityKey     @"kSettingsSensitivityKey"
//...

@interface NBSettings (managerToStorageFunctions)

- (void) updateFromDeviceManager;
- (void) storeSettings;

@end

@interface NBSettings (storageToManagerFunctions)

- (bool) loadSettingsFromStorage;
- (void) updateDevicesWithSettings;

@end


@implementation NBSettings
{
    NSMutableDictionary *allSettings;
    NSMutableDictionary *currentDeviceSetting; //active, polling interval,...
}

- (id) init
{
    self = [super init];
    if (self)
    {
        if ([self loadSettingsFromStorage])
        {
            [self updateDevicesWithSettings];
        }
        else
        {
            allSettings = [[NSMutableDictionary alloc] init];
            [self updateFromDeviceManager];
            [self storeSettings];
        }
    }
    return self;
}

- (void) dealloc
{
    [self storeSettings];
    [super dealloc];
}

- (void) didUpdateSettingDevice:(NBDevice*)device
{
    currentDeviceSetting = [allSettings objectForKey:[device addressKey]];
    if (currentDeviceSetting == nil)
    {
        currentDeviceSetting = [NSMutableDictionary dictionary];
    }
    [currentDeviceSetting setObject:[NSNumber numberWithBool:device.active] forKey:kSettingsActiveKey];
    //... other device params here
    
    [allSettings setObject:currentDeviceSetting forKey:[device addressKey]];
    NBLog(kNBLogSettings, @"Updated device %@, settings %@", [device addressKey], allSettings);
}

- (void) saveSettings
{
    [self storeSettings];
}

@end


@implementation NBSettings (managerToStorageFunctions)

- (void) updateFromDeviceManager
{
    NBDeviceManager *deviceManager = [NBDeviceManager sharedManager];
    for (NBDevice *device in deviceManager.devices.allValues)
    {
        currentDeviceSetting = [NSMutableDictionary dictionary];
        [currentDeviceSetting setObject:[NSNumber numberWithBool:device.active] forKey:kSettingsActiveKey];
        //... other device params here
        
        [allSettings setObject:currentDeviceSetting forKey:[device addressKey]];
    }
    NBLog(kNBLogSettings, @"Updated from DM, settings: %@", allSettings);
}

- (void) storeSettings
{
    NBLog(kNBLogSettings, @"Storing settings: %@", allSettings);
    [[NSUserDefaults standardUserDefaults] setObject:allSettings forKey:kSettingsDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

@implementation NBSettings (storageToManagerFunctions)

- (bool) loadSettingsFromStorage
{
    allSettings = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsDefaultsKey];
    NBLog(kNBLogSettings, @"Loaded all settings: %@", allSettings);
    return (allSettings != nil);
}

- (void) updateDevicesWithSettings
{
    NBDeviceManager *deviceManager = [NBDeviceManager sharedManager];
    NBLog(kNBLogSettings, @"Updating DM (%@) with settings: %@", deviceManager, allSettings);
    for (NBDevice *device in deviceManager.devices.allValues)
    {
        currentDeviceSetting = [allSettings objectForKey:[device addressKey]];
        if (currentDeviceSetting != nil)
        {
            NSNumber *activeNumber = [currentDeviceSetting objectForKey:kSettingsActiveKey];
            if (activeNumber != nil)
            {
                [device setActive:activeNumber.boolValue];
            }
            //... other device params here
        }
    }
}

@end
