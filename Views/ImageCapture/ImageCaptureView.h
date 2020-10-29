//
//  ImageCaptureView.h
//  doctor
//
//  Created by Muhammad Imran on 12/12/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCaptureView : UIView {
   
    IBOutlet UITextField *_titleTextField;
    IBOutlet UIImageView *_imageView;
    IBOutlet UIButton *_getImageButton;
    IBOutlet UILabel *_imageName;
}
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *imageName;
@property (strong, nonatomic) IBOutlet UIButton *getImageButton;

@end
