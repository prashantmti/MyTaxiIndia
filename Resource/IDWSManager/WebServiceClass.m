//
//  WebServiceClass.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/20/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "WebServiceClass.h"

@implementation WebServiceClass



void(^getServerResponseForUrlCallback)(BOOL success, NSDictionary *response, NSError *error);

// --------------
- (void)getServerResponseForUrl:(NSDictionary*)dataParams serviceURL:(NSString*)serviceURL isPOST:(BOOL)isPOST withCallback:(ASCompletionBlock)callback
{
    getServerResponseForUrlCallback = callback;
    // Start doing some time consuming tasks like sending a request to the backend services
    
    //  1
    //NSURL *WSurl = [NSURL URLWithString:@"http://api.geonames.org/citiesJSON"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    //  2
    NSMutableURLRequest *request = [self createUrlRequest:dataParams serviceURL:serviceURL isPOST:YES];
    
    //Create task
    NSURLSessionDataTask * dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Handle your response here
        
        if (error) {
            [self onBackendResponse:nil withSuccess:NO error:error];
            NSLog(@"error==>%@",error.description);
        }else
        {
            resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            if (error == nil){
                [self onBackendResponse:resultDic withSuccess:YES error:error];
                NSLog(@"responseDic==>%@",resultDic);
            }
            else{
                [self onBackendResponse:nil withSuccess:NO error:error];
                NSLog(@"JSON Response:%@",error.localizedDescription);
            }
        }
    }];
    [dataTask resume];
}

// --------------
- (void)onBackendResponse:(NSDictionary *)response withSuccess:(BOOL)success error:(NSError *)error
{
    getServerResponseForUrlCallback(success, response, error);
}


/*
-(NSDictionary*)setServiceClass:(NSString*)baseUrl serviceUrl:(NSString*)serviceUrl dataDic:(NSDictionary*)dataDic isPOST:(BOOL)isPOST
{
    //  1
    NSURL *url = [NSURL URLWithString:@"http://api.geonames.org/citiesJSON"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    //  2
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *params = @"username=demo";
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = @"POST";
    
    //Create task
    NSURLSessionDataTask * dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Handle your response here
        
        if (error) {
            NSLog(@"error==>%@",error.description);
        }else
        {
            resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            if (error == nil){
                NSLog(@"responseDic==>%@",resultDic);
            }
            else{
                NSLog(@"JSON Response:%@",error.localizedDescription);
            }
        }
    }];
    
    [dataTask resume];
    return  resultDic;
}
*/

//-(void)setServiceClass1:(NSString*)baseUrl serviceUrl:(NSString*)serviceUrl dataDic:(NSDictionary*)dataDic isPOST:(BOOL)isPOST
//{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
//    
//    
//    NSMutableURLRequest * request;
//    
//    NSMutableDictionary *serviceParams=[[NSMutableDictionary alloc]init];
//    
//    [serviceParams setValue:baseUrl forKey:@"baseUrl"];
//    [serviceParams setValue:serviceUrl forKey:@"serviceUrl"];
//    [serviceParams setValue:dataDic forKey:@"dataDic"];
//    
//    NSURL *requestURL = [self createRequestUrl:serviceParams isPOST:isPOST];
//    
//    if(isPOST){
//        request=[self makeRequestForPost:requestURL dataDic:dataDic];
//    }else{
//        request=[self makeRequestForGet:requestURL];
//    }
//    
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        if (error) {
//            
//            NSLog(@"error==>%@",error.description);
//        }else
//        {
//            NSDictionary *responseDic;
//            responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//            if (error == nil){
//                NSLog(@"responseDic==>%@",responseDic);
//            }
//            else{
//                
//                NSLog(@"JSON Response:%@",error.localizedDescription);
//            }
//        }
//        
//    }];
//    [postDataTask resume];
//}

/*
-(NSMutableURLRequest*)makeRequestForGet:(NSURL*)requestURL{
    NSLog(@"%@:%@",@"SM Get requestURL",requestURL);
    
    // Create the request
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:requestURL];
    return request;
}

-(NSMutableURLRequest*)makeRequestForPost:(NSURL*)requestURL dataDic:(NSDictionary*)dataDic{
    NSLog(@"%@:%@",@"SM Post requestURL",requestURL);
    
    // Create the request
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:requestURL];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    
    NSData *posting = [[self makeKeyUsingDictionary:dataDic] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:posting];
    return request;
}
*/

-(NSMutableURLRequest *)createUrlRequest:(NSDictionary *)dataParams serviceURL:(NSString*)serviceURL isPOST:(BOOL)isPOST
{
    NSURL *requestURL;
    NSMutableURLRequest *request;
    
    NSMutableString *urlStr=[[NSMutableString alloc]initWithString:@""];
    
    if (isPOST) {
        [urlStr appendFormat:@"%@%@",IDBaseURL,serviceURL];
    }else
    {
        [urlStr appendFormat:@"%@%@%@%@",IDBaseURL,serviceURL,@"?",[self makeKeyUsingDictionary:[dataParams valueForKey:@"dataParams"]]];
    }

    requestURL= [NSURL URLWithString:[urlStr stringByRemovingPercentEncoding]];
    NSLog(@"WS requestURL==>%@",requestURL);
    
    request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    
    if (isPOST) {
        NSString *params = [self makeKeyUsingDictionary:dataParams];
        NSLog(@"params===>%@",params);
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        request.HTTPMethod = @"POST";
    }
    return request;
}

-(NSMutableString*) makeKeyUsingDictionary:(NSDictionary*)SetDataDic
{
    NSMutableString *ps;   //parameter string
    ps=[[NSMutableString alloc]initWithString:@""];
    NSArray *dicKeyArray = [SetDataDic allKeys];
    
    if (dicKeyArray.count!=0)
    {
        int i=0;
        for (NSString *key in dicKeyArray)
        {
            if(i == 0){
                [ps appendFormat:@"%@=%@",key,[SetDataDic objectForKey:key]];
            }
            else{
                [ps appendFormat:@"&%@=%@",key,[SetDataDic objectForKey:key]];
            }
            i++;
        }
    }
    return ps;
}
@end
