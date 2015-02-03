//
//  SchwizzleCalcViewController.h
//  SchwizzleCalc
//
//  Created by Epyon on 4/6/14.
//  Copyright (c) 2014 SchwizzleApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@class GADBannerView, GADRequest;

@interface SchwizzleCalcViewController : UIViewController <GADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    GADBannerView *bannerView_;
    IBOutlet UITextField *loanAmount;
    IBOutlet UITextField *loanTerm;
    IBOutlet UITextField *loanRate;
    IBOutlet UITextField *loanPayments;
    IBOutlet UIImageView *logoView;

    

    
}
@property (nonatomic,strong)GADBannerView *bannerView;
-(GADRequest *)createRequest;

@property (nonatomic,retain) UITextField *loanAmount;
@property (nonatomic,retain) UITextField *loanTerm;
@property (nonatomic,retain) UITextField *loanRate;
@property (nonatomic,retain) UILabel *loanPaymentsLabel;
@property (nonatomic,retain) UIImageView *logoView;


-(IBAction)textFieldReturn:(id)sender;

@end
