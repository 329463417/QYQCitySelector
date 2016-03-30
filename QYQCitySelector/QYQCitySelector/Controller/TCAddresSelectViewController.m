//
//  TCAddresSelectViewController.m
//  CosFundLife
//
//  Created by qiuyaqingMac on 16/1/6.
//  Copyright © 2016年 上海同传金融信息服务有限公司. All rights reserved.
//

#import "TCAddresSelectViewController.h"

#import "HisAddressCell.h"

#import "UIBarButtonItem+Create.h"

#import "AnchiveTool.h"
#import "UIView+Frame.h"

#import "LoationManger.h"        //定位的工具类

#import "ChineseString.h"

#import "ChineseToPinyin.h"

#import "MBProgressHUD+MJ.h"
#define fileName @"historyCitys.src"      //归档文件名
/**
 *  屏幕的物理高度
 */
#define ScreenHeight   [UIScreen mainScreen].bounds.size.height

/**
 *  屏幕的物理宽度
 */
#define ScreenWidth    [UIScreen mainScreen].bounds.size.width

@interface TCAddresSelectViewController ()<UITableViewDelegate,UITableViewDataSource,HisAddressCellDelegate,UIAlertViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,LoationMangerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) LoationManger *manger;

@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *dataArr;

//历史记录的数据源
@property (nonatomic, strong) NSMutableArray *hisCitys;
@property (nonatomic, strong) UITableView *searchResultTbView;
/**
 *  搜索时调用的数据源
 */
@property (nonatomic,strong) NSMutableArray *datas;

@property (nonatomic, strong) NSMutableArray *searchArr;
/**
 *  定位的城市
 */
@property (nonatomic, copy) NSString *locaCity;

@property (nonatomic, strong) UILabel *headerLabel;


@end


@implementation TCAddresSelectViewController

- (void) setSearchControllerHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0: _tbView.height;
  
   [self.searchResultTbView setFrame:CGRectMake(0, _tbView.y , ScreenWidth, height)];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self ConfigUI];
    //初始化数据源
    [self createData];

    [self creatSearchDatas];
    [self loaction];
}

#pragma mark - 定位
- (void)loaction
{
     [LoationManger sharedManager].delegate = self;
     [[LoationManger sharedManager] location];
    
}
#pragma mark - 初始化数据源
- (void)createData
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSDictionary *addDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"]];
    NSArray *arr = [addDict objectForKey:@"address"];
    for (NSDictionary *dict in arr) {
        
        NSArray *Newarr = [dict objectForKey:@"sub"];
        for (NSDictionary *Newdict in Newarr) {
            [array addObject:[Newdict objectForKey:@"name"]];
        }
    }
    
    self.titleArr = [ChineseString IndexArray:array];
    self.dataArr = [ChineseString LetterSortArray:array];
    
    //从归档文件中获访问历史取数据源
    _hisCitys = [NSMutableArray arrayWithArray:[AnchiveTool unAchiveWithFileName:fileName]];


}

#pragma mark - 配置文件
- (void)ConfigUI
{
    self.title = @"定位";
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    if (iOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    
    self.mySearchBar.delegate = self;
    
    UIBarButtonItem *backItem = [UIBarButtonItem barButtonItemWithImage:@"close" highImage:nil target:self action:@selector(BackButtonClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self.tbView registerClass:[HisAddressCell class] forCellReuseIdentifier:@"HisAddressCellId"];
    [self.tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
    
    [self.searchResultTbView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchCellID"];
    
    self.searchResultTbView = [[UITableView alloc] initWithFrame:CGRectMake(0, _tbView.y, ScreenWidth, 0) style:UITableViewStylePlain];
    
    _searchResultTbView.delegate = self;
    _searchResultTbView.dataSource = self;
    
    [self.view addSubview:_searchResultTbView];
    
    [self creatHeaderView];
    
    
}
#pragma mark - 初始化搜索的数据源
- (void)creatSearchDatas
{
    self.datas = [NSMutableArray array];
    for (int i=0;i<self.dataArr.count;i++) {
        NSArray *arr = [self.dataArr objectAtIndex:i];
        for (int j=0; j<arr.count; j++) {
            
        
            [self.datas addObject:[arr objectAtIndex:j]];
            
    
        }
    }

    
}
#pragma mark - 退出的按钮
- (void)BackButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 创建头部视图
- (void)creatHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 44);
    _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, ScreenWidth, 44)];
    
     _headerLabel.text = @"正在定位中......";
    _headerLabel.textColor = [UIColor darkGrayColor];
   
    _headerLabel.font = [UIFont systemFontOfSize:15];
    
    _headerLabel.userInteractionEnabled = YES;
    
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerLabelTap:)];
    
    [_headerLabel addGestureRecognizer:tap];
    
    [headerView addSubview:_headerLabel];
    
    self.tbView.tableHeaderView = headerView;
}
//点击定位的方法
- (void)headerLabelTap:(UITapGestureRecognizer *)tap
{
    UIView *view = (UIView *) [tap.view superview];
    
    view.backgroundColor = kTCColor(220, 220, 220);
    
    [self performSelector:@selector(restore:) withObject:view afterDelay:0.3];
    if (_isLoaction== YES) {
        
        [_delegate TCAddresSelectViewControllerDidSelectTitle:_locaCity];
        
        [self saveHisArrayWithText:_locaCity];
    
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        
       
        [[LoationManger sharedManager] location];
        _headerLabel.text = @"正在定位中......";
        _headerLabel.userInteractionEnabled = NO;
         NSLog(@"重新定位");
    }
 
   
}
- (void)restore:(UIView *)view
{
    view.backgroundColor = [UIColor whiteColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchResultTbView]) {
        return _searchArr.count;
        
    }
    else
    {
        if (_hisCitys.count ==0) {
            
            NSArray *arr = [_dataArr objectAtIndex:section];
            
            return [arr count];
            
        }
        else
        {
            return section==0? 1:[[_dataArr objectAtIndex:section-1 ] count];

        }

    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.searchResultTbView]) {
        
        return 1;
    }
    else
    {
        if (_hisCitys.count == 0) {
            return _titleArr.count;
        }
        return _titleArr.count+1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.searchResultTbView]) {
        
        return 44;
    }
    else
    {
        if (_hisCitys.count ==0) {
            
            return 44;
        }
        else
        {
            if (indexPath.section==0) {
                return 84;
            }
            else
            {
                return 44;
            }
        }

    }
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"searchCellID";
    
    if ([tableView isEqual:self.searchResultTbView]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        cell.textLabel.text = [_searchArr objectAtIndex:indexPath.row];
        
        return cell;
        
    }
    else
    {
        if (_hisCitys.count ==0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            
            cell.textLabel.text = _dataArr[indexPath.section][indexPath.row];
            
            return cell;
        
        }
        else
        {
            if (indexPath.section == 0) {
                
            HisAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HisAddressCellId" forIndexPath:indexPath];
            cell.delegate = self;
            [cell configArray:_hisCitys];
            
            return cell;
            }
            else
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                
                cell.textLabel.text = _dataArr[indexPath.section-1][indexPath.row];
                            
                return cell;
            }
        }

    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if ([tableView isEqual:self.searchResultTbView]) {
       
        title = _searchArr[indexPath.row];

    }
    else
    {
        if (_hisCitys.count==0) {
            
            title = _dataArr[indexPath.section][indexPath.row];
            
        }
        else
        {
            if (indexPath.section==0) {
                return;
            }
            NSArray *subarr = [_dataArr objectAtIndex:indexPath.section-1];
                               
            title = [subarr objectAtIndex:indexPath.row] ;
        
        }

   }
    
    [self saveHisArrayWithText:title];
    if ([_delegate respondsToSelector:@selector(TCAddresSelectViewControllerDidSelectTitle:)]) {
        
        [_delegate TCAddresSelectViewControllerDidSelectTitle:title];
        
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//返回每组的标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchResultTbView]) {
        return nil;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
  
    bgView.backgroundColor = kTCColor(239, 239, 239);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-15, 35)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = kTCColor(143, 144, 145);
    
    [bgView addSubview:label];
    
    if (_hisCitys.count==0) {
        
        label.text = [_titleArr objectAtIndex:section];
        
    }
    else
    {
    if (section == 0) {
        label.text = @"历史访问城市";
        }
     else
        {
         label.text = [_titleArr objectAtIndex:section-1];
        }
    }
    
    return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchResultTbView]) {
        return 0;
    }
    return 35;
}
//返回每组的索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.searchResultTbView]) {
        return nil;
    }
    
    NSMutableArray *indexs=[NSMutableArray arrayWithArray:_titleArr] ;
    
    if (_hisCitys.count!=0) {
        
        [indexs insertObject:@" " atIndex:0];
    }

    return indexs;

}
#pragma mark - HisAddressCell代理方法点击了Label
- (void)HisAddressCellLabelClickWithLabelText:(NSString *)text
{
    NSLog(@"代理方法点击了Label%@",_hisCitys);

    [self saveHisArrayWithText:text];

    if ([_delegate respondsToSelector:@selector(TCAddresSelectViewControllerDidSelectTitle:)]) {
        
        [_delegate TCAddresSelectViewControllerDidSelectTitle:text];
        
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UISearchBar的代理方法

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        [self setSearchControllerHidden:YES]; //控制下拉列表的隐现
        
    }else{
        [self setSearchControllerHidden:NO];
//       NSPredicate *resultPredicate = [NSPredicate  predicateWithFormat:@"SELF contains[cd] %@",searchText];

//        _searchArr =(NSMutableArray *)[self.datas filteredArrayUsingPredicate:resultPredicate];
        
        _searchArr = [NSMutableArray array];
        for (int i = 0; i < _datas.count; i++) {
            if ([[ChineseToPinyin pinyinFromChiniseString:_datas[i]] hasPrefix:[searchText uppercaseString]] || [_datas[i] hasPrefix:searchText]) {
                [_searchArr addObject:[_datas objectAtIndex:i]];
            }
        }

        [_searchResultTbView reloadData];
        

    }
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;

    return YES;
}

#pragma mark - 结束编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  
    searchBar.showsCancelButton = NO;
    
}
//点击搜索框上的 取消按钮时 调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
     NSLog(@"cancle clicked");
    _mySearchBar.text = @"";
     [self setSearchControllerHidden:YES]; 
    [_mySearchBar resignFirstResponder];
   
}
#pragma mark - UIScrollerView的代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_searchResultTbView]) {
        
       [_mySearchBar endEditing:YES];
        
    }

    _mySearchBar.text = @"";
    [_mySearchBar endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
}

#pragma mark - ALertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    switch (buttonIndex) {
        case 0:
        {
            return;
        }
            break;
        case 1:
        {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 定位成功
- (void)loationMangerSuccessLocationWithCity:(NSString *)city;

{
    _headerLabel.userInteractionEnabled = YES;
    
    _locaCity = city;
    
    _headerLabel.text = [NSString stringWithFormat:@"GPS定位-%@",city];

}
#pragma mark - 定位的代理方法
- (void)loationMangerFaildWithError:(NSError *)error
{
    _headerLabel.userInteractionEnabled = YES;
    NSLog(@"定位的代理方法%@",error);
    _headerLabel.text = [NSString stringWithFormat:@"定位失败,点击重试GPS定位!"];
    if ([error code] == kCLErrorLocationUnknown) {
        
        [self SHOWPrompttext:@"获取位置信息失败,请稍后再试"];
        
        
    }
    else if ([error code] == 1)
    {
        if (iOS8) {
            
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"定位功能未开启" message:@"请在系统设置中开启定位服务" delegate:self cancelButtonTitle:nil otherButtonTitles:@"暂不",@"去设置", nil];
            [al show];
        }
        else{
            Alert(@"您未允许咖范@生活访问您的位置,请到设置中设置允许访问位置");
        }
    }
    
}

#pragma mark - 存储历史数据数组并且归档
- (void)saveHisArrayWithText:(NSString *)text
{
    [_hisCitys  insertObject:text atIndex:0];
   
    if (_hisCitys.count ==2) {
        if ([text isEqualToString:[_hisCitys objectAtIndex:1]]) {
            
            [_hisCitys removeLastObject];
            
        }
    }
    if (_hisCitys.count ==3) {
        
        if ([text isEqualToString:[_hisCitys objectAtIndex:2]]) {
            [_hisCitys removeLastObject];
        }
        if ([text isEqualToString:[_hisCitys objectAtIndex:1]]) {
            [_hisCitys removeObjectAtIndex:1];
            
        }
    }
    if (_hisCitys.count>3) {
        
        if ([text isEqualToString:[_hisCitys objectAtIndex:2]]) {
            [_hisCitys removeObjectAtIndex:2];
            
        }
        else if ([text isEqualToString:[_hisCitys objectAtIndex:1]])
        {
            [_hisCitys removeObjectAtIndex:1];
        }
        else
        {
            [_hisCitys removeObjectAtIndex:3];
        }
    }
    
    [AnchiveTool achiveWithArray:_hisCitys FileName:fileName];
}

#pragma mark - 渐隐提示框
- (void)SHOWPrompttext:(NSString *)Text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = Text;
    hud.margin = 10.f;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.0f];
    
}
@end
