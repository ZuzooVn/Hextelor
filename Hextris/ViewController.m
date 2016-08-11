//
//  ViewController.m
//  Hextris
//
//  Created by Nam Vu on 1/26/15.
//  Copyright (c) 2015 Nam Vu. All rights reserved.
//

#import "ViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"

#define admobUnit @"xxxxxxxxxxxxxx"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webview.scrollView.scrollEnabled = NO;
    self.webview.scrollView.bounces = NO;
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"hextris_iOS"]];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    
    if(IS_IPAD){
        self.adBanner.frame = CGRectMake(0, 0, [self getScreenWidth], CGSizeFromGADAdSize(kGADAdSizeSmartBannerLandscape).height);
    }else{
        self.adBanner.frame = CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height);
    }
    
    self.adBanner.adUnitID = admobUnit;
    self.adBanner.delegate = self;
    [self.adBanner setRootViewController:self];
}

- (float) getScreenWidth {
    float heightScreen = [[UIScreen mainScreen] bounds].size.height;
    float widthScreen = [[UIScreen mainScreen] bounds].size.width;
    //reasign value as widthScreen should always be longer
    if (heightScreen > widthScreen){
        heightScreen = widthScreen;
        widthScreen = [[UIScreen mainScreen] bounds].size.height;
    }
    return widthScreen;
}


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( [[[inRequest URL] scheme] isEqualToString:@"iosgameover"] ) {
        
        if(count > 0 && (count % 10 == 0)){
            [self loadInterstitialGADRequest];
        }else{
            [self.view addSubview:self.adBanner];
            [self.adBanner loadRequest:[self request]];
        }
        count ++;
        return NO;
    }else if( [[[inRequest URL] scheme] isEqualToString:@"iosrestart"] ){

        //    Remove adBaner
        [self.adBanner removeFromSuperview];
        return NO;
    }
    return YES;
}


#pragma mark GADBannerViewDelegate callbacks

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    DLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    DLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

#pragma mark GADInterstitialDelegate implementation

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [self.interstitial presentFromRootViewController:self];
    
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error {
    DLog    (@"%@", [error localizedDescription]);
}

- (void) interstitialDidDismissScreen:(GADInterstitial *)ad{
    
}

#pragma mark GADRequest implementation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[ GAD_SIMULATOR_ID ];
    
    return request;
}

#pragma mark Load GADRequest

- (void) loadInterstitialGADRequest {
    // Create a new GADInterstitial each time.  A GADInterstitial will only show one request in its
    // lifetime. The property will release the old one and set the new one.
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.delegate = self;
    
    self.interstitial.adUnitID = admobUnit;
    [self.interstitial loadRequest:[self request]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
