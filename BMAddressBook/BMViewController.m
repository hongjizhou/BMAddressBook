//
//  BMViewController.m
//  BMAddressBook
//
//  Created by elvin on 16/8/16.
//  Copyright © 2016年 zhouhongji. All rights reserved.
//

#import "BMViewController.h"
#import "BMContantViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface BMViewController ()<ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *moblie;

@end

@implementation BMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//获取通讯录信息
- (IBAction)selectedContant:(id)sender {
    
    BMContantViewController *contantViewController  = [[BMContantViewController alloc] init];
    
    [contantViewController setSelectedContantBlock:^(NSString *userName, NSString *moblie){
        self.userName.text = userName;
        self.moblie.text = moblie;
    }];
    
    
    [self.navigationController pushViewController:contantViewController animated:YES];
}


//调取通讯录页面
- (IBAction)adressBook:(id)sender {
    
    ABPeoplePickerNavigationController * peoplePickerNavigationController= [[ABPeoplePickerNavigationController alloc] init];
    peoplePickerNavigationController.peoplePickerDelegate = self;
    
    //处理进入电话详情页面时，会出现自动退出的情况
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        peoplePickerNavigationController.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    
    [self presentViewController:peoplePickerNavigationController animated:YES completion:nil];
    
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long indexPhone = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, indexPhone);
    
    ABMultiValueRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *firstNameStr = (__bridge NSString *)firstName;
    
    ABMultiValueRef middleName = ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    NSString *middleNameStr = (__bridge NSString *)middleName;
    
    ABMultiValueRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *lastNameStr = (__bridge NSString *)lastName;
    
    NSString *userName = [NSString string];
    
    if (firstNameStr.length >0) {
        userName = [userName stringByAppendingString:firstNameStr];
    }
    if (middleNameStr.length > 0) {
        userName = [userName stringByAppendingString:middleNameStr];
    }
    if (lastNameStr.length > 0) {
        userName = [userName stringByAppendingString:lastNameStr];
    }

    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@:%@", userName,phoneNO);
    if (phone && phoneNO.length == 11) {
        self.userName.text = userName;
        self.moblie.text = phoneNO;
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"请选择正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person NS_DEPRECATED_IOS(2_0, 8_0)
{
    return YES;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_DEPRECATED_IOS(2_0, 8_0)
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (phone && phoneNO.length == 11) {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"请选择正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    return YES;
}

@end
