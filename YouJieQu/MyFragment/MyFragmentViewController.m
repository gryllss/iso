//
//  MyFragmentViewController.m
//  YouJieQu
//
//  Created by user on 2018/10/20.
//  Copyright © 2018年 user. All rights reserved.
//

#import "MyFragmentViewController.h"
#import "My.h"
#import "MBProgressHUD+XMG.h"
#import <BmobSDK/BmobUser.h>
#import "TimeChangeViewController.h"


@interface MyFragmentViewController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate>
@property(nonatomic,strong) NSArray *mys;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL needHidden;

@property (strong, nonatomic) IBOutlet UIButton *loginOrRegiBtn;
@property (strong, nonatomic) IBOutlet UILabel *labalTime;

@property(nonatomic,strong) UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UIButton *btnImage;

@property (assign, nonatomic) BOOL isLogin;

- (IBAction)imageClick:(id)sender;

@end




@implementation MyFragmentViewController


#pragma mark -懒加载
- (NSArray *)mys
{
    if (_mys == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"my.plist" ofType:nil];
        NSArray *arrayDict =[NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *arrModels = [NSMutableArray array];
        for (NSDictionary *dict in arrayDict) {
            My *model = [[My alloc]initWithDict:dict];
            [arrModels addObject:model];
        }
        _mys = arrModels;
    }
    return _mys;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView].rowHeight  = 60;
    
   
    
    [_loginOrRegiBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[self navigationController ]navigationBar].hidden = YES; //隐藏顶部导航拦
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:nil action:nil];
    
   
}

//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    My *model = self.mys[indexPath.row];

    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = model.name;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    if(indexPath.row == 4 &&_needHidden) {
      
            cell.hidden = YES;//重点
     
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;  //（这种是点击的时候有效果，返回后效果消失）
    
    if(indexPath.row == 0){
       [self performSegueWithIdentifier:@"timeChange" sender:nil];
       
    }
    if(indexPath.row == 1){
        [self performSegueWithIdentifier:@"contactMe" sender:nil];
        
    }
    
    
    if(indexPath.row == 2){
        [self performSegueWithIdentifier:@"question" sender:nil];
        
    }
  
    if (indexPath.row == 3) {
        
        [self clearFile];
        [MBProgressHUD showSuccess:@"已清除缓存"];
        
    }
    
    if (indexPath.row == 4) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"是否退出登陆"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _needHidden = YES;
            [_tableView reloadData];
            [[self labalTime]setText:@""];
            [[self loginOrRegiBtn]setTitle:@"登录/注册" forState:UIControlStateNormal];
            [BmobUser logout];
            _loginOrRegiBtn.enabled = YES;
            _btnImage.enabled = YES;

        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
           
        }];
        
        [alertController addAction:okAction];           // A
        [alertController addAction:cancelAction];       // B
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 4 && _needHidden)
    {
        
            return 0;//重点
       
        
    }
    return 60;
}



#pragma mark - 清楚缓存
- (void)clearFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",cachePath);
    NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:cachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}





-(void)viewWillAppear:(BOOL)animated{

//        [[self navigationController ]navigationBar].hidden = YES; //隐藏顶部导航拦
    
    [super viewWillAppear:animated];
     NSLog(@"%s", __func__);
    
    //设置代理即可
    self.navigationController.delegate = self;
    self.navController = self.navigationController;

    BmobUser *bUser = [BmobUser currentUser];
    if (bUser) {
        _needHidden = NO;
        [_tableView reloadData];
        _loginOrRegiBtn.enabled = NO;
        _btnImage.enabled = NO;
        
        NSString *userName = [bUser objectForKey:@"username"];
        NSString *outTime = [bUser objectForKey:@"outTime"];
        if (userName.length >= 8) {
            NSString *subName = [userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            [_loginOrRegiBtn setTitle:subName forState:UIControlStateNormal];
        }else {
            [_loginOrRegiBtn setTitle:userName forState:UIControlStateNormal];
        }
         NSString *subOutTime = [outTime substringToIndex:10];
        
        [_labalTime setText:[NSString stringWithFormat:@"体验时长：%@到期",subOutTime]];
        _isLogin = true;
        
    }else{
        _needHidden = YES;
    }
    
    
}

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if(viewController == self){
        [self.navController setNavigationBarHidden:YES animated:animated];
    }else{
        //不在本页时，显示真正的nav bar
        [self.navController setNavigationBarHidden:NO animated:animated];
        //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
        //之前将这段代码放在viewDidDisappear和dealloc中，这两种情况可能已经被pop了，self.navigationController为nil，这里采用手动持有navigationController的引用来解决
        if(self.navController.delegate == self){
            //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
            self.navController.delegate = nil;
        }
    }
}



- (IBAction)imageClick:(id)sender {
    [self performSegueWithIdentifier:@"login" sender:nil];
}


- (void)btnClick{
    [self performSegueWithIdentifier:@"login" sender:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"timeChange"]) {
        TimeChangeViewController *tc = segue.destinationViewController;
        tc.isLogin = _isLogin;
    }
}


@end
