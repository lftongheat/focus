//
//  LSUtil.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-5-24.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "LSUtil.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>


@implementation LSUtil

+ (NSString *)now
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *)today
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate date]];
}

//图片缩放代码
+ (UIImage*)scaleToSize: (UIImage*)img size:(CGSize)size
{
    //创建一个bitmap的context
    UIGraphicsBeginImageContext(size);
    
    //绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //从当前context中创建以个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //从当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) 
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
//	BOOL isLocal = flags & kSCNetworkReachabilityFlagsIsWWAN;
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (UIImage *)fetchImage: (NSString *)imageID
{
    NSString *str = [NSString stringWithFormat:@"http://113.106.89.74:8081/leisuresport/image.aspx?id=%@", imageID];
    NSURL *url = [NSURL URLWithString: str];
    UIImage *headImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    return headImage;
}

+ (BOOL)uploadImage:(UIImage*)image UserID: (NSString *)userID 
{
    NSString *filename = [NSString stringWithFormat:@"%@.png", userID];
//    NSDictionary *params;
//    params = [[NSDictionary alloc] init];
//    [params setValue:[UIImage imageNamed:@"默认头像.png"] forKey:@"pic"];
//    [params setValue:@"file" forKey:@"name"];
    
    NSString *urlstr = @"http://113.106.89.74:8081/leisuresport/uploadImage.aspx";    
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
//    UIImage *image=[params objectForKey:@"pic"];
    //得到图片的data
    NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    /*
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];            
        }
    }*/
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明file字段，文件名为filename
    [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",filename];
    //声明上传文件的格式
//    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    [body appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
    NSLog(@"body:%@",body);
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"RequestData:%@",myRequestData);
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];  
    
//    //建立连接，设置代理
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    //设置接受response的data
//     NSMutableData *myResponseData=[[NSMutableData alloc] init];
//    if (conn) {
//        myResponseData = [[NSMutableData data] retain];
//    }
//    NSLog(@"response:%@",myResponseData);
    
    NSURLResponse *response;
    NSError *error;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(!result)
        return NO;
    else if([response expectedContentLength] < 0)
        return NO;
    else
    {
        NSMutableData *data = [NSMutableData dataWithData:result];
        NSString *soapResult = [[NSString alloc] initWithBytes: [data mutableBytes] length:[data length] encoding:NSUTF8StringEncoding];
        NSLog(@"resopnse:%@",soapResult);
        return YES;
    }
    return NO;
}

@end
