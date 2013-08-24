//
//  TVLiveFetcher.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-9.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "TVLiveFetcher.h"
#import "LSWebServiceRequest.h"
#import "LSSoapResultXMLParser.h"
#import "GameLive.h"
#import "JSONKit.h"

@implementation TVLiveFetcher

+ (NSMutableArray *)fetchLive 
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/Game_LoadByTV";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",
							 @"<Game_LoadByTV xmlns=\"leisuresport\">"
                             "<UserID>52</UserID>"
                             "</Game_LoadByTV>"
							 ];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *liveArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        //NSLog(xmlParser.tmpResult);
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        //NSLog(@"jsonObject:%@",jsonObject);
        for (id obj in jsonObject) {
         //   NSLog(@"44444444");
       // NSLog(@"obj-----%@",obj);
            GameLive *gameLive = [[GameLive alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"GameID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.GameID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.HomeTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.AwayTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.GameTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamScore" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.HomeTeamScore = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamScore" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.AwayTeamScore = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.LeaugeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsFinished" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.IsFinished = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Report" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.Report = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Result" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.Result = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"RoundNum" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.RoundNum = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsHot" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.IsHot = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TVLiveAll" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.TVLiveAll = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NewsID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.NewsID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.HomeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.AwayName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Name" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.Name = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.GameTypeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.GameTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamImageUrl" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.HomeTeamImageUrl = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamImageUrl" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.AwayTeamImageUrl = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }   
            [liveArray addObject:gameLive];
            [gameLive release];
        } 
    }
    return liveArray;
}

+ (NSMutableArray *)fetchLive: (NSInteger) count
{
    //从webservice获取数据
    
    NSString *tmp = [ NSString stringWithFormat:@"<Game_LoadByTV xmlns=\"leisuresport\">"
                     "<UserID>1</UserID>"
                     "</Game_LoadByTV>",count];
    NSString *soapAction = @"leisuresport/Game_LoadByTV";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"", tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *liveArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {      
            //            NSLog(@"obj-----%@",obj);
            GameLive *gameLive = [[GameLive alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"GameID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.GameID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.HomeTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.AwayTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.GameTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamScore" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.HomeTeamScore = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamScore" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.AwayTeamScore = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.LeaugeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsFinished" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.IsFinished = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Report" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.Report = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Result" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.Result = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"RoundNum" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.RoundNum = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsHot" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.IsHot = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TVLiveAll" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.TVLiveAll = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NewsID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.NewsID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.HomeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.AwayName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Name" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.Name = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.GameTypeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.GameTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamImageUrl" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.HomeTeamImageUrl = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamImageUrl" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    gameLive.AwayTeamImageUrl = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }   
            [liveArray addObject:gameLive];
            [gameLive release];
        } 
    }
    return liveArray;
}

@end
