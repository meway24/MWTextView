//
//  ViewController.m
//  TestRichTextView
//
//  Created by 孟伟 on 16/5/3.
//  Copyright © 2016年 yeapoo. All rights reserved.
//

#import "MWTextView.h"
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) MWTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self commitView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commitView
{
    _textView = [[MWTextView alloc] initWithFrame:CGRectMake(0.f, 20.f, [UIScreen mainScreen].bounds.size.width, 200.f)];
    _textView.font = [UIFont systemFontOfSize:16.f];
    _textView.textColor = [UIColor blackColor];

    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:@"写点什么？"];
    [atr setAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16.f],
                          NSForegroundColorAttributeName : [UIColor blueColor] }
                 range:NSMakeRange(0, atr.length)];
    _textView.attributedPlaceholder = atr;

    _textView.regexAttributes = [self highlightPatterns];

    [self.view addSubview:_textView];

    [_textView becomeFirstResponder];
}

- (NSDictionary *)highlightPatterns
{
    return @{
        @"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" : @{NSForegroundColorAttributeName : [UIColor redColor]},
        @"#[^@#]+?#" : @{NSForegroundColorAttributeName : [UIColor blueColor]},
        @"(\\*\\w+(\\s\\w+)*\\*)\\s" : @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16.f],
                                         NSForegroundColorAttributeName : [UIColor purpleColor]},
        @"(_\\w+(\\s\\w+)*_)\\s" : @{NSForegroundColorAttributeName : [UIColor brownColor]},
        @"(-\\w+(\\s\\w+)*-)\\s" : @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16.f],
                                     NSForegroundColorAttributeName : [UIColor greenColor]}
    };
}

@end
