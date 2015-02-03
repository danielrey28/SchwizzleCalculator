//
//  SchwizzleCalcViewController.m
//  SchwizzleCalc
//
//  Created by Epyon on 4/6/14.
//  Copyright (c) 2014 SchwizzleApps. All rights reserved.
//

#import "SchwizzleCalcViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "appID.h"


@interface SchwizzleCalcViewController ()



@end

@implementation SchwizzleCalcViewController
@synthesize bannerView = _bannerView_;
@synthesize loanAmount = _loanAmount;
@synthesize loanTerm = _loanTerm;
@synthesize loanRate = _loanRate;
@synthesize loanPaymentsLabel = _loanPaymentsLabel;
@synthesize logoView = _logoView;

NSMutableArray *amsItems;
UITableView *tableView;


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_loanAmount resignFirstResponder];
    [_loanRate resignFirstResponder];
    [_loanTerm resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _loanAmount.delegate = self;
    _loanTerm.delegate = self;
    _loanRate.delegate = self;
    UIImage *img = [UIImage imageNamed: @"logo.png"];
    [_logoView setImage:img];

    
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,[[UIScreen mainScreen] bounds].size.height-50, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    
    self.bannerView.adUnitID = MyAdUnitId;
    self.bannerView.delegate = self;
    [self.bannerView setRootViewController:self];
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:[self createRequest]];
                                                                       
}

-(GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    return request;
}

-(void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Ad Received");
    [UIView animateWithDuration:1.0 animations:^{
        adView.frame = CGRectMake(0.0, [[UIScreen mainScreen] bounds].size.height-50, adView.frame.size.width, adView.frame.size.height);
    }];
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad due to: %@", [error localizedFailureReason]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showAMSTable:(id)sender {
    
}
- (IBAction)CalculateLoan:(id)sender {
    
    double amount= [_loanAmount.text doubleValue];
    double rate = [_loanRate.text doubleValue];
    double term = [_loanTerm.text doubleValue];
    
        
    double r = rate/1200; // to optimize to handle different payment periods
    double n = term;
    double rPower = pow(1+r,n);
    
    double paymentAmt = amount * r * rPower / (rPower - 1);
    double totalPaymentd = paymentAmt * n;
    double totalInterestd = totalPaymentd - amount;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    NSNumber *n1 = [NSNumber numberWithDouble:paymentAmt];
    NSNumber *n2 = [NSNumber numberWithDouble:totalPaymentd];
    NSNumber *n3 = [NSNumber numberWithDouble:totalInterestd];
    
    NSString *paymentAmtString = [NSString stringWithFormat: @"$%@", [numberFormatter stringFromNumber:n1]];
    
    _loanPaymentsLabel.text = paymentAmtString;
    
    [self makeAmortization: &amount : &rate : &term :&paymentAmt];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
    
    
}
- (void)makeAmortization: (double *)amount :(double *) rate :(double *) term :(double *) monthly
{
    int i;
    double balance = *amount;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    
    

    for (i=0; i<*term; i++)
    {
        
        amsItems = [NSMutableArray array];
        double interestForMonth = balance * (*rate);
        double principalForMonth = *monthly - interestForMonth;
        balance -= *monthly;

        NSNumber *nb1 = [NSNumber numberWithDouble:*monthly];
        NSNumber *nb2 = [NSNumber numberWithDouble:interestForMonth];
        NSNumber *nb3 = [NSNumber numberWithDouble:principalForMonth];
        NSNumber *nb4 = [NSNumber numberWithDouble:balance];
        
        NSString *amsString = [NSString stringWithFormat:
        @"Monthly Payment: $%@          Interest: $%@           Principal: $%@          Balance: $%@", [numberFormatter stringFromNumber:nb1], [numberFormatter stringFromNumber:nb2], [numberFormatter stringFromNumber:nb3], [numberFormatter stringFromNumber:nb4]];
        
        [amsItems addObject: amsString];
    }
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [amsItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AmsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [amsItems objectAtIndex:indexPath.row];
    return cell;
}

@end
