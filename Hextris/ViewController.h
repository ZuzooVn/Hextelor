//
//  ViewController.h
//  Hextris
//
//  Created by Nam Vu on 1/26/15.
//  Copyright (c) 2015 Nam Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@class GADBannerView, GADRequest;

@interface ViewController : UIViewController<UIWebViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate>{
    NSInteger count;
}

@property(strong, nonatomic) GADBannerView *adBanner;
@property(nonatomic, strong) GADInterstitial *interstitial;

@property (weak, nonatomic) IBOutlet UIWebView *webview;


@end

