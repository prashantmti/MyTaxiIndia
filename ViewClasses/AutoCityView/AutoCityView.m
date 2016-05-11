//
//  AutoCityView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/16/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "AutoCityView.h"

@interface AutoCityView ()


@end

@implementation AutoCityView

@synthesize TbLocation,locationArray,loctionTag,tripTag;
@synthesize isSearchAction;

- (void)viewDidLoad {
    [super viewDidLoad];
    isSearchAction=FALSE;
    
    //
    _plistLocationArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"location" ofType:@"plist"]];
    locationArray=_plistLocationArray;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self GATrackOnView:NSStringFromClass(self.class) kGAIScreenName:kGAIScreenName];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (locationArray.count==0 && isSearchAction==TRUE) {
        return 1;
    }else{
        return locationArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tbIdentifier;
    
    if (locationArray.count==0 && isSearchAction==TRUE) {
        tbIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tbIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tbIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text=@"No Result";
            cell.textLabel.textColor=[UIColor lightGrayColor];
        }
        return cell;
    }else{
        tbIdentifier = @"AutoCityCell";
        AutoCityCell *cell = [tableView dequeueReusableCellWithIdentifier:tbIdentifier forIndexPath:indexPath];
        
        //NSString *locality=[[locationArray objectAtIndex:indexPath.row] valueForKey:@"locality"];
        NSString *city=[[locationArray objectAtIndex:indexPath.row] valueForKey:@"city"];
        NSString *state=[[locationArray objectAtIndex:indexPath.row] valueForKey:@"state"];
        //NSString *country=[[locationArray objectAtIndex:indexPath.row] valueForKey:@"country"];
        
        NSString *location=[NSString stringWithFormat:@"%@, %@",city,state];
        cell.lblSearchLocation.text=[location capitalizedString];
        cell.lblSearchLocation.font=[UIFont systemFontOfSize:15];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (locationArray.count==0 && isSearchAction==TRUE) {
        return;
    }
    else{
        NSDictionary* postParmsDic=@{
                                     @"locationTag":[NSString stringWithFormat:@"%ld",(long)loctionTag],
                                     @"locationDic":[locationArray objectAtIndex:indexPath.row]
                                     };
        if (tripTag==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToAutoLocation" object:nil userInfo:postParmsDic];
        }else if (tripTag==2){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToAutoLocationforLocal" object:nil userInfo:postParmsDic];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)BTNdismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>2)
    {
        [operationQueue cancelAllOperations];
        operationQueue = [NSOperationQueue new];
        blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            //This is the worker block operation
            [self callService:searchText];
        }];
        [operationQueue addOperation:blockOperation];
    }else{
        
        locationArray=_plistLocationArray;
        return;
    }
}


//-(void)sampleCodeTwo
//{
//    NSOperationQueue *operationQueue = [NSOperationQueue new];
//    NSBlockOperation *blockCompletionOperation = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"The block operation ended, Do something such as show a successmessage etc");
//        //This the completion block operation
//    }];
//    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
//        //This is the worker block operation
//        [self methodOne];
//    }];
//    [blockCompletionOperation addDependency:blockOperation];
//    [operationQueue addOperation:blockCompletionOperation];
//    [operationQueue addOperation:blockOperation];
//    
//    
//}


-(void)callService:(NSString*)params{
    
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:merchantId forKey:@"merchantId"];
    [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
    
    [postDic setObject:params forKey:@"term"];
    
    dispatch_async (dispatch_get_main_queue(), ^{
        [WSC getServerResponseForUrl:postDic serviceURL:IDCityStartsWith isPOST:YES isLoder:NO auth:auth view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
            if (success) {
                if ([[response valueForKey:@"status"] isEqualToString:@"error"])
                {
                    [self alertWithText:@"Error!" message:[response valueForKey:@"error"]];
                    return ;
                }else{
                    NSLog(@"result===>%@",[response valueForKey:@"result"]);
                    locationArray=[response valueForKey:@"result"];
                    
                    dispatch_async (dispatch_get_main_queue(), ^{
                        [TbLocation reloadData];
                    });
                }
            }else{
                [self alertWithText:@"Error!" message:error.localizedDescription];
                return ;
            }
        }];
    });
}
@end
