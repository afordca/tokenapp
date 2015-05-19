//
//  TK_LinkViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/12/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TK_LinkViewController.h"
#import "TK_DescriptionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface TK_LinkViewController () <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textFieldLink;
@property (strong, nonatomic) IBOutlet UITextField *textFieldLinkTitle;

@property (strong, nonatomic) IBOutlet UIView *viewImage;

@property UIImagePickerController *imagePickerLink;
@property UIImage *imageLink;
@property UIImageView *imageViewLinkDefault;

@property BOOL isLink;

@end

@implementation TK_LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.textFieldLink.delegate = self;
    self.textFieldLinkTitle.delegate = self;
    self.imagePickerLink.delegate = self;
    self.isLink = YES;

    self.imageViewLinkDefault = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30 , 40, 40)];
    self.imageViewLinkDefault.contentMode = UIViewContentModeScaleAspectFill;

    UIImage *imageLink = [UIImage imageNamed:@"Link"];
    self.imageViewLinkDefault.image = imageLink;

    [self.viewImage addSubview:self.imageViewLinkDefault];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.viewImage addGestureRecognizer:tapGestureRecognizer];
    self.viewImage.userInteractionEnabled = YES;

}

#pragma mark - Button Methods

- (IBAction)onButtonCancel:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onButtonNext:(id)sender
{
    if (![self.textFieldLink.text isEqualToString:@""])
    {
        [self performSegueWithIdentifier:@"PushToDescription" sender:nil];
    }
}

#pragma mark - UITextfield Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}

// Clicking off any controls will close the keypad

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UIImagePicker Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker == self.imagePickerLink) {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

        // Check if photo
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
        {
            self.imageLink = [info objectForKey:UIImagePickerControllerOriginalImage];

            // Pictures taken from camera shot are stored to device
            if (self.imagePickerLink.sourceType == UIImagePickerControllerSourceTypeCamera)
            {
                //Save to Photos Album
                UIImageWriteToSavedPhotosAlbum(self.imageLink, nil, nil, nil);

            }

            [self dismissViewControllerAnimated:YES completion:^{

            UIImageView *imageViewLink = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , 100, 90)];
            imageViewLink.contentMode = UIViewContentModeScaleAspectFill;

            self.imageLink = [self resizeImage:self.imageLink scaledToSize:150];
            imageViewLink.image = self.imageLink;
        
            [self.imageViewLinkDefault removeFromSuperview];

            [self.viewImage addSubview:imageViewLink];


            }];
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
}

#pragma mark - UITapGesture Methods

-(void)imageTapped:(UITapGestureRecognizer*)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Link Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];

    [actionSheet showInView:self.view];
}

#pragma mark UIAction Sheet Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) //Camera
    {
        self.imagePickerLink = [[UIImagePickerController alloc]init];
        self.imagePickerLink.delegate = self;
        self.imagePickerLink.allowsEditing = YES;
        self.imagePickerLink.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerLink.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];

        [self presentViewController:self.imagePickerLink animated:YES completion:nil];

    }
    else if (buttonIndex == 1) //Library
    {
        self.imagePickerLink = [[UIImagePickerController alloc]init];
        self.imagePickerLink.delegate = self;
        self.imagePickerLink.allowsEditing = YES;
        self.imagePickerLink.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIColor *backgroundColor = [UIColor colorWithRed:0.38 green:0.51 blue:0.85 alpha:1.0];
        self.imagePickerLink.navigationBar.barTintColor = backgroundColor;
        self.imagePickerLink.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePickerLink.sourceType];
        [self presentViewController:self.imagePickerLink animated:YES completion:nil];
        
    }
}


#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TK_DescriptionViewController *tk_DescriptionVC =[segue destinationViewController];
    tk_DescriptionVC.stringLink = self.textFieldLink.text;
    tk_DescriptionVC.stringLinkTitle = self.textFieldLinkTitle.text;
    tk_DescriptionVC.isLink = self.isLink;
    tk_DescriptionVC.imageLink = self.imageLink;
}

#pragma mark - Helper Methods
- (UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGFloat)newSize
{
    CGAffineTransform scaleTransform;
    CGPoint origin;

    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);

        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);

        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }

    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);

    [image drawAtPoint:origin];

    image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return image;
}
@end
