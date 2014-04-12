//
//  CommentCell.m
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "CommentCell.h"
#import "JsonParseEngine.h"
#import "UIImageView+MJWebCache.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *clickHeadPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadPhoto:)];
        [_headPhotoImage addGestureRecognizer: clickHeadPhoto];
    }
    return self;
}

#pragma -mark tap
-(void) clickHeadPhoto:(id)sender
{
    //[_delegate tapHeadPhoto];
    NSLog(@"click headPhoto!");
}

-(void)setReadyToShow
{
    if (_isMan) {
        [_headPhotoImage setImage:[UIImage imageNamed:@"man.jpg"]];
    }
    else{
        [_headPhotoImage setImage:[UIImage imageNamed:@"girl.jpg"]];
    }
    
    [_numLabel setText:[NSString stringWithFormat:@"%@", _num]];
    [_userLabel setText:[NSString stringWithFormat:@"%@", _author]];
    //[_timeLabel setText:[JsonParseEngine dateToString:_time]];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_timeLabel setText:[date stringFromDate:_time]];
    date = nil;

    [_contentLabel setText:_content];

    NSString *str = [NSString stringWithFormat:@"【在%@(%@)的大作中提到:】\n : %@",_quoter,_name,_quote];
    [_commentToLabel setText:str];
    
    if ([_attachments count] > 0) {
    }

}

-(void)setReadyToShowOne
{
    if (_isMan) {
        [_headPhotoImage setImage:[UIImage imageNamed:@"man.jpg"]];
    }
    else{
        [_headPhotoImage setImage:[UIImage imageNamed:@"girl.jpg"]];
    }
    
    [_numLabel setText:[NSString stringWithFormat:@"%@", _num]];
    [_userLabel setText:[NSString stringWithFormat:@"%@", _author]];
    //[_timeLabel setText:[JsonParseEngine dateToString:_time]];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_timeLabel setText:[date stringFromDate:_time]];
    date = nil;
    //NSLog(@"CommentCell before frame: %@", NSStringFromCGRect(_contentLabel.frame));
    [_contentLabel setText:_content];
    //NSLog(@"CommentCell after frame: %@", NSStringFromCGRect(_contentLabel.frame));
    [_commentToLabel setText:@""];
    
    if ([_attachments count] > 0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont *font = [UIFont systemFontOfSize:15.0];
        CGSize size1 = [_content boundingRectWithSize:CGSizeMake(self.frame.size.width - 35, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        
        NSArray * picArray = [self getPicList];
        for (int i = 0; i < [picArray count]; i++) {
            Attachment * att = [picArray objectAtIndex:i];
            ImageAttachmentView * imageAttachmentView = [[ImageAttachmentView alloc] initWithFrame:CGRectMake(60, i*180 + _contentLabel.frame.origin.y + size1.height + 10, 200, 180)];
            [imageAttachmentView setAttachmentURL:[NSURL URLWithString:att.attUrl] NameText:att.attFileName];
            imageAttachmentView.indexNum = i;
            imageAttachmentView.mDelegate = self;
            [self addSubview:imageAttachmentView];
            [self.attachmentsViewArray addObject:imageAttachmentView];
        }
    }
    
}
    
-(NSArray *)getPicList
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_attachments count]; i++) {
        NSString * attUrlString=[[[_attachments objectAtIndex:i] attUrl] lowercaseString];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".tiff"] || [attUrlString hasSuffix:@".bmp"])
        {
            [picArray addObject:[_attachments objectAtIndex:i]];
        }
    }
    return picArray;
}

#pragma - ImageAttachmentViewDelegate
-(void)imageAttachmentViewTaped:(int)indexNum
{
    [_delegate imageAttachmentViewInCellTaped:_indexRow Index:indexNum];
}

#pragma - AttachmentViewDelegate
-(void)attachmentViewTaped:(BOOL)isPhoto IndexNum:(int)indexNum
{
    [_delegate attachmentViewInCellTaped:isPhoto IndexRow:_indexRow IndexNum:indexNum];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
