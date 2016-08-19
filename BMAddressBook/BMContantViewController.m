//
//  BMContantViewController.m
//  BMAddressBook
//
//  Created by elvin on 16/8/16.
//  Copyright © 2016年 zhouhongji. All rights reserved.
//

#import "BMContantViewController.h"
#import "APContact.h"
#import "APAddressBook.h"

@interface BMContantViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)NSMutableArray *contantArray;
@property (nonatomic, strong) APAddressBook *addressBook;
@property (weak, nonatomic) IBOutlet UITableView *tableViewContact;


@end

@implementation BMContantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contantArray = [NSMutableArray array];
    
    self.addressBook = [[APAddressBook alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.addressBook startObserveChangesWithCallback:^
     {
         [weakSelf loadContacts];
     }];
    
    [self loadContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contantArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
    }
    
    APContact *contact = [self.contantArray objectAtIndex:indexPath.row];
    
    NSString *userName = [NSString string];
    if (contact.name.firstName.length > 0) {
        userName = [userName stringByAppendingString:contact.name.firstName];
    }
    if (contact.name.middleName.length > 0) {
        userName = [userName stringByAppendingString:contact.name.middleName];
    }
    if (contact.name.lastName.length > 0) {
        userName = [userName stringByAppendingString:contact.name.lastName];
    }
    
    NSLog(@"姓名：%@",userName);
    NSString *umber = [NSString stringWithFormat:@"%@",[[contact.phones objectAtIndex:0] number]];
    NSLog(@"号码：%@",umber);
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",userName,umber];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    APContact *contact = [self.contantArray objectAtIndex:indexPath.row];
    
    NSString *userName = [NSString string];
    if (contact.name.firstName.length > 0) {
        userName = [userName stringByAppendingString:contact.name.firstName];
    }
    if (contact.name.middleName.length > 0) {
        userName = [userName stringByAppendingString:contact.name.middleName];
    }
    if (contact.name.lastName.length > 0) {
        userName = [userName stringByAppendingString:contact.name.lastName];
    }

    NSLog(@"姓名：%@",userName);
    NSString *umber = [NSString stringWithFormat:@"%@",[[contact.phones objectAtIndex:0] number]];
    NSLog(@"号码：%@",umber);

    
    if (self.selectedContantBlock) {
        self.selectedContantBlock(userName,umber);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadContacts
{

    __weak __typeof(self) weakSelf = self;
    self.addressBook.fieldsMask = APContactFieldAll;
    self.addressBook.sortDescriptors = @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"name.firstName" ascending:YES],
                                         [NSSortDescriptor sortDescriptorWithKey:@"name.lastName" ascending:YES]];
    self.addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
    [self.addressBook loadContacts:^(NSArray<APContact *> *contacts, NSError *error) {
        if (contacts)
        {
            [weakSelf.contantArray addObjectsFromArray:contacts];
            [weakSelf.tableViewContact reloadData];
        }
        else if (error)
        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                                message:error.localizedDescription
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//            [alertView show];
        }
    }];
}

@end
