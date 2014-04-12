//
//  SingleMailViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SingleMailViewController.h"
#import "PostMailViewController.h"

#import "JsonParseEngine.h"

@interface SingleMailViewController ()

@end

@implementation SingleMailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *replyButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(reply:)];
    self.navigationItem.rightBarButtonItem = replyButton;
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mail/get.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",@"bGl4aWFuZ2ZseWlu%3A%3D%3DwxN2Rp0T%2B4FOVeCJCmo7cu"];
    [baseurl appendFormat:@"&type=%i",_rootMail.type];
    [baseurl appendFormat:@"&id==%i",_rootMail.ID];
    NSURL *myurl = [NSURL URLWithString:baseurl];
    _request = [ASIFormDataRequest requestWithURL:myurl];
    [_request setDelegate:self];
    [_request setDidFinishSelector:@selector(GetResult:)];
    [_request setDidFailSelector:@selector(GetErr:)];
    [_request startAsynchronous];
    
}

#pragma -mark asi Delegate
//ASI委托函数，错误处理
-(void) GetErr:(ASIHTTPRequest *)request
{
    NSLog(@"error!");
    
}

//ASI委托函数，信息处理
-(void) GetResult:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [request.responseString objectFromJSONString];
    NSLog(@"dic %@",dic);
    
    _mail = [JsonParseEngine parseSingleMail:dic Type:_rootMail.type];
    
    if (_mail.type == 0)
        [_authorLabel setText:[NSString stringWithFormat:@"%@", _mail.author]];
    if (_mail.type == 1)
        [_authorLabel setText:[NSString stringWithFormat:@"%@", _mail.author]];
    if (_mail.type == 2)
        [_authorLabel setText:[NSString stringWithFormat:@"%@", _mail.author]];
    
    [_titleLabel setText:_mail.title];
    [_contentLabel setText:_mail.content];
    [_timeLabel setText:[JsonParseEngine dateToString:_mail.time]];
    
    //[_scrollView addSubview:_realView];
    
    UIFont *font = [UIFont systemFontOfSize:17.0];
    CGSize size = [_mail.content sizeWithFont:font constrainedToSize:CGSizeMake(self.view.frame.size.width - 30, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    
    [_contentLabel setFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, self.view.frame.size.width - 30, size.height)];
    
    [_realView setFrame:CGRectMake(0, 0, self.view.frame.size.width, _contentLabel.frame.origin.y + size.height)];
    //[_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, _contentLabel.frame.origin.y + size.height+10)];
    if (_contentLabel.frame.origin.y + size.height+10 <= self.view.frame.size.height) {
        //[_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 10)];
    }
    
}

#pragma -mark 回复邮件
-(void)reply:(id)sender
{
    //发邮件
    PostMailViewController *postMailVC = [[PostMailViewController alloc]init];
    postMailVC.rootMail = _mail;
    postMailVC.postType = 1;
    [self presentViewController:postMailVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end