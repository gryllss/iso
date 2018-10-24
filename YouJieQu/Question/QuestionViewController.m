//
//  QuestionViewController.m
//  YouJieQu
//
//  Created by user on 2018/10/21.
//  Copyright © 2018年 user. All rights reserved.
//

#import "QuestionViewController.h"
#import "Question.h"

@interface QuestionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSArray *questions;
@end

@implementation QuestionViewController

#pragma mark -懒加载
- (NSArray *)questions
{
    if (_questions == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"question.plist" ofType:nil];
        NSArray *arrayDict =[NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *arrModels = [NSMutableArray array];
        for (NSDictionary *dict in arrayDict) {
            Question *model = [[Question alloc]initWithDict:dict];
            [arrModels addObject:model];
        }
        _questions = arrModels;
    }
    return _questions;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];//不设置会导致push时右上角黑影闪烁
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Question *model = self.questions[indexPath.row];
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text = model.title;
 
    if (model.icon) {
        cell.imageView.image = [UIImage imageNamed:model.icon];
    }
    cell.detailTextLabel.text = model.text;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.detailTextLabel.numberOfLines = 0;
       cell.detailTextLabel.font =  [UIFont systemFontOfSize:14];
   
    [cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;  //（这种是点击的时候有效果，返回后效果消失）
    
}

@end
