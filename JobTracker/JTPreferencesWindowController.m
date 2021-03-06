//
//  JTPreferencesWindowController.m
//  JobTracker
//
//  Created by Brad Greenlee on 11/11/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import "JTPreferencesWindowController.h"
#import "LaunchAtLoginController.h"

@interface JTPreferencesWindowController ()

@end

@implementation JTPreferencesWindowController

@synthesize jobTrackerURLCell, usernamesCell, startingJobNotificationPreference,
    completedJobNotificationPreference, failedJobNotificationPreference, launchAtLoginPreference,
    okayButton, cancelButton, delegate;

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self loadCurrentSettings];
    [[self window] center];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)loadCurrentSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //BOOL configured = [defaults boolForKey:@"configured"];
    
    NSString *usernames = [defaults stringForKey:@"usernames"];
    if (usernames != nil) {
        [self.usernamesCell setStringValue:usernames];
    }

    NSString *jobTrackerURL = [defaults stringForKey:@"jobTrackerURL"];
    if (jobTrackerURL != nil) {
        [self.jobTrackerURLCell setStringValue:jobTrackerURL];
    }

    
    [self.startingJobNotificationPreference setState:[defaults boolForKey:@"startingJobNotificationsEnabled"] ? NSOnState : NSOffState];
    [self.completedJobNotificationPreference setState:[defaults boolForKey:@"completedJobNotificationsEnabled"] ? NSOnState : NSOffState];
    [self.failedJobNotificationPreference setState:[defaults boolForKey:@"failedJobNotificationsEnabled"] ? NSOnState : NSOffState];

    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    BOOL launchAtLoginEnabled = [launchController launchAtLogin];
    
    if (launchAtLoginEnabled) {
        [self.launchAtLoginPreference setState:NSOnState];
    } else {
        [self.launchAtLoginPreference setState:NSOffState];
    }    
}

- (IBAction)okayPressed:(id)sender {
    NSString *jobTrackerURL = [self.jobTrackerURLCell stringValue];
    NSString *usernames = [[self.usernamesCell stringValue] stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL startingJobNotificationsEnabled = [self.startingJobNotificationPreference state] == NSOnState;
    BOOL completedJobNotificationsEnabled = [self.completedJobNotificationPreference state] == NSOnState;
    BOOL failedJobNotificationsEnabled = [self.failedJobNotificationPreference state] == NSOnState;
    BOOL launchOnLoginEnabled = [self.launchAtLoginPreference state] == NSOnState;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Save the Launch-on-Login preference.
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
	[launchController setLaunchAtLogin:launchOnLoginEnabled];
    
    [defaults setObject:jobTrackerURL forKey:@"jobTrackerURL"];
    [defaults setObject:usernames forKey:@"usernames"];
    [defaults setBool:startingJobNotificationsEnabled forKey:@"startingJobNotificationsEnabled"];
    [defaults setBool:completedJobNotificationsEnabled forKey:@"completedJobNotificationsEnabled"];
    [defaults setBool:failedJobNotificationsEnabled forKey:@"failedJobNotificationsEnabled"];
    
    [[self window] close];
    [self.delegate preferencesUpdated];    
}


- (IBAction)cancelPressed:(id)sender {
    [[self window] close];
}


@end
