/*
 * <b>Copyright (c) 2016, Imagination Technologies Limited and/or its affiliated group companies
 *  and/or licensors. </b>
 *
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without modification, are permitted
 *  provided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice, this list of conditions
 *      and the following disclaimer.
 *
 *  2. Redistributions in binary form must reproduce the above copyright notice, this list of
 *      conditions and the following disclaimer in the documentation and/or other materials provided
 *      with the distribution.
 *
 *  3. Neither the name of the copyright holder nor the names of its contributors may be used to
 *      endorse or promote products derived from this software without specific prior written
 *      permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 *  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 *  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 *  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 *  WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import "AppDelegate.h"
#import <CreatorKit/CreatorKit.h>
#import "DataApi.h"
#import "DataApiProtocol.h"

@interface AppDelegate ()
@property(strong, nonatomic, nonnull) AppData *appData;
@end

@implementation AppDelegate
@synthesize authenticateToken = _authenticateToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[GlobalStyle class] setupAppearance];
    
    NSURL *launchUrl = launchOptions[UIApplicationLaunchOptionsURLKey];
    if (launchUrl) {
        self.authenticateToken = [[LoginApi class] tokenFromURL:launchUrl redirectUrlScheme:self.creatorRedirectUrlScheme];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[LoginApi class] loginViewControllerWithLoginDelegate:self];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if (self.openUrlDelegate) {
        return [self.openUrlDelegate processOpenUrl:url source:self];
    }
    return NO;
}

- (AppData *)appData {
    if (_appData == nil) {
        _appData = [AppData new];
    }
    return _appData;
}

#pragma mark - OpenUrlProtocol

- (UIViewController *)safariRootViewController {
    return self.window.rootViewController;
}

- (NSString *)creatorClientId {
    return @"1c6c7bee-b5d0-440c-9b5a-61f54a62c18d";
}

- (NSString *)creatorRedirectUrlScheme {
    return @"io.creatordev.kit.powerswitch";
}

- (void)presentMainViewControllerWithDeviceServerApi:(nonnull DeviceServerApi *)deviceServerApi {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navVc = [mainStoryboard instantiateInitialViewController];
    id<DataApiProtocol> dataApiReceiver = (id<DataApiProtocol>) navVc.topViewController;
    [dataApiReceiver setDataApi:[[DataApi alloc] initWithDeviceServerApi:deviceServerApi]];
    self.window.rootViewController = navVc;
}

@end
