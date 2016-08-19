//
//  PushViewController.m
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/18.
//  Copyright © 2016年 Cocav. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "PushViewController.h"
#import "InputToolbar.h"
@interface PushViewController ()<MoreButtonViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,strong)InputToolbar *inputToolbar;
@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputToolbar = [[InputToolbar alloc] init];
    self.inputToolbar.moreButtonView.delegate = self;
    [self.view addSubview:self.inputToolbar];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputToolbar.textInput resignFirstResponder];
}

- (void)moreButtonView:(MoreButtonView *)moreButtonView didClickButton:(MoreButtonViewButtonType)buttonType
{
    switch (buttonType) {
        case MoreButtonViewButtonTypeImages:
        {
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            ipc.delegate = self;
            [self presentViewController:ipc animated:YES completion:nil];
        } break;
            
        case MoreButtonViewButtonTypeCamera:
        {
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.delegate = self;
            [self presentViewController:ipc animated:YES completion:nil];
        } break;
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //UIImage *image = info[UIImagePickerControllerOriginalImage];
    //图片选取成功
}

@end
