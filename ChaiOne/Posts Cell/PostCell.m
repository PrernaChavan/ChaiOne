//
//  CustomCell.m
//  ChaiOne
//
//  Created by prerna chavan on 19/01/15.
//  Copyright (c) 2015 Synerzip. All rights reserved.
//

#import "PostCell.h"
#import "UIImageView+AFNetworking.h"

#define ImageViewFrame CGRectMake(10.0f, 10.0f, 50.0f, 50.0f)
#define NameLabelFrame CGRectMake(70.0f, 6.0f, 240.0f, 20.0f)
#define MaxWidthOfNameLabel 240.0

@implementation PostCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        self.detailTextLabel.numberOfLines = 0;
        self.imageView.layer.cornerRadius = 8;
        self.imageView.clipsToBounds = YES;

    }
    
    return self;
}

-(void)setPost:(Post *) post
{
    _post = post;

    self.textLabel.text = _post.person.name;
    self.detailTextLabel.text = _post.info;

    // Use lazy loading for downloading and displaying images

    NSURL *url = [NSURL URLWithString:_post.person.imageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];

    __weak UITableViewCell *weakCell = self;

    [self.imageView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success: ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakCell.imageView.image = image;
        [weakCell setNeedsLayout];
    }  failure:nil];
}

+ (CGFloat)heightForCellForPost:(Post *) post
{
    return (CGFloat)fmaxf(70.0f, (float)[self infoTextHeight:post.info] + 45.0f);
}

+ (CGFloat)infoTextHeight:(NSString *) text
{
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(MaxWidthOfNameLabel, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{
                                                    NSFontAttributeName:[UIFont systemFontOfSize:14.0f]
                                                   }
                                          context:nil];
    return rectToFit.size.height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.imageView.frame = ImageViewFrame;
    self.textLabel.frame = NameLabelFrame;

    // For dynamic height to display all the text, calculate the height of whole text

    CGRect infoTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    CGFloat calculatedHeight = [[self class] infoTextHeight:self.post.info];
    infoTextLabelFrame.size.height = calculatedHeight;
    self.detailTextLabel.frame = infoTextLabelFrame;
}

@end
