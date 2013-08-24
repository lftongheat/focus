//
//  IWatchFetcher.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-11.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "IWatchFetcher.h"
#import "LSWebServiceRequest.h"
#import "LSSoapResultXMLParser.h"
#import "IWatch.h"
#import "FavourTeam.h"
#import "FavourTeamGames.h"
#import "DetailInfo.h"
#import "GameComments.h"
#import "JSONKit.h"

@implementation IWatchFetcher
+ (NSMutableArray *)fetchIWatch:(NSString *) dateParameter dropdown:(NSString *) dropdownItem userID:(NSString *) userIDParameter iWatchDropDownArray:(NSMutableArray *)iWatchDropDownArrayParameter segmentNumber:(NSString*)segmentNumberParameter
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/Game_Hot_LoadByDate";
    NSString *tmp = [ NSString stringWithFormat:@"<Game_Hot_LoadByDate xmlns=\"leisuresport\">"
                                     "<Datetime>%@</Datetime>"
                                     "<UserID>%@</UserID>"
                                     "</Game_Hot_LoadByDate>", dateParameter,userIDParameter];
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[LSWebServiceRequest alloc] init];
    NSMutableArray *iWatchTableArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
       //  NSLog(xmlParser.result);
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
//        id jsonObject = [LSJsonParser parse:xmlParser.result];
        
      //  NSLog(@"jsonObject:%@",jsonObject);
        for (id obj in jsonObject) {
            IWatch *iWatch = [[IWatch alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"GameID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.GameID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.HomeTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.AwayTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.GameTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamScore" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.HomeTeamScore = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamScore" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.AwayTeamScore = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.LeaugeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsFinished" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.IsFinished = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Report" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.Report = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Result" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.Result = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"RoundNum" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.RoundNum = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsHot" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.IsHot = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TVLiveAll" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.TVLiveAll = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NewsID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.NewsID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.HomeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.AwayName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Name" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.Name = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.GameTypeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.GameTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsWin" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    iWatch.IsWin = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }
            if([dropdownItem isEqualToString:@"我的关注"])
            {
                if([segmentNumberParameter isEqualToString:@"1"])
                {
                    for(int i=1;i<[iWatchDropDownArrayParameter count];i++)
                    {
                        if([iWatch.Name isEqualToString:[iWatchDropDownArrayParameter objectAtIndex:i]])
                        {
                            [iWatchTableArray addObject:iWatch];
                            //[iWatch release];
                            break;
                        }
                    }
                    
                }else
                {
                    [iWatchTableArray addObject:iWatch];
                    //[iWatch release];
                }
            }
            else if([iWatch.Name isEqualToString:dropdownItem])
            {
                [iWatchTableArray addObject:iWatch];
                //[iWatch release];
            }
            [iWatch release];
        }
    }
    //[iWatchDropDownArrayParameter release];
    [soapRequest release];
    return [iWatchTableArray autorelease];
}

+ (NSMutableArray *)fetchFocusedTeams:(NSString *) userID
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/Team_LoadByUserFavor";
    NSString *tmp = [NSString stringWithFormat:@"<Team_LoadByUserFavor xmlns=\"leisuresport\">"
                     "<UserID>%@</UserID>"
                     "</Team_LoadByUserFavor>",userID];
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *focusedTeamArray = [[NSMutableArray alloc] init];
    FavourTeam *favourTeam = [[FavourTeam alloc] init];
    favourTeam.Name = @"全部";
    favourTeam.TeamID=@"";
    favourTeam.LeagueID=@"";
    favourTeam.City=@"";
    favourTeam.ShortName=@"";
    favourTeam.ImageUrl=@"";
    favourTeam.GameTypeID=@"";
    favourTeam.LeagueName=@"";
    favourTeam.GameTypeName=@"";
    favourTeam.isfocus=@"";
    [focusedTeamArray addObject:favourTeam];
    [favourTeam release];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {     
//            NSLog(@"obj-----%@",obj);
            FavourTeam *favourTeam = [[FavourTeam alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"TeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favourTeam.TeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeagueID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favourTeam.LeagueID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Name" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favourTeam.Name = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"City" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favourTeam.City = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ShortName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favourTeam.ShortName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ImageUrl" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favourTeam.ImageUrl = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favourTeam.GameTypeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeagueName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favourTeam.LeagueName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favourTeam.GameTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"isfocus" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favourTeam.isfocus = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }   
            [focusedTeamArray addObject:favourTeam];
            [favourTeam release];
        } 
    }
    return [focusedTeamArray autorelease];
}
+ (NSMutableArray *)fetchFocusedTeamGames:(NSString *) dateParameter dropdown:(NSString *) dropdownItem  userID:(NSString *) userIDParameter
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/Game_LoadByUserFavorTeam";
    NSString *tmp = [ NSString stringWithFormat:@"<Game_LoadByUserFavorTeam xmlns=\"leisuresport\">"
                     "<userID>%@</userID>"
                     "<TimeStamp>%@</TimeStamp>"
                     "</Game_LoadByUserFavorTeam>",userIDParameter,dateParameter];
    
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[LSWebServiceRequest alloc] init];
    NSMutableArray *favorTeamGamesTableArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
          //NSLog(@"xmlParser.result:%@",xmlParser.result);
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        for (id obj in jsonObject) {
            //NSLog(@"obj-----%@",obj);
            FavourTeamGames *favorTeamGame = [[FavourTeamGames alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"GameID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.GameID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.HomeTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.AwayTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.GameTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamScore" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.HomeTeamScore = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamScore" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.AwayTeamScore = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.LeaugeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsFinished" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.IsFinished = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Report" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.Report = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Result" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.Result = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"WinTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.WinTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LoseTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.LoseTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsHot" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.IsHot = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TVLiveAll" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.TVLiveAll = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NewsID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.NewsID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FavorTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.FavorTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FavorName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.FavorName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.HomeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.AwayName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Name" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.Name = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.GameTypeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.GameTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsWin" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    favorTeamGame.IsWin = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }
            if([dropdownItem isEqualToString:@"我的关注"])
            {
                [favorTeamGamesTableArray addObject:favorTeamGame];
//                [favorTeamGame release];
            }
            else if([favorTeamGame.FavorName isEqualToString:dropdownItem])
            {
                [favorTeamGamesTableArray addObject:favorTeamGame];
//                [favorTeamGame release];
            }
            [favorTeamGame release];
        } 
    }
    [soapRequest release];
    return [favorTeamGamesTableArray autorelease];
}

+ (NSMutableArray *)fetchDetailInfo:(NSString *) gameIDParameter  userID:(NSString *) userIDParameter
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/Game_DetailInfo_LoadByGameID";
    
    NSString *tmp = [ NSString stringWithFormat:@"<Game_DetailInfo_LoadByGameID xmlns=\"leisuresport\">"
                     "<GameID>%@</GameID>"
                     "<userID>%@</userID>"
                     "</Game_DetailInfo_LoadByGameID>", gameIDParameter,userIDParameter];
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *detailInfoTableArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
       // NSLog(@"xmlParser.result:%@",xmlParser.result);
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        //  NSLog(@"jsonObject:%@",jsonObject);
        for (id obj in jsonObject) {
            //NSLog(@"obj-----%@",obj);
            DetailInfo *detailInfo = [[DetailInfo alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"GameID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.GameID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.HomeTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.AwayTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.GameTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamScore" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.HomeTeamScore = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamScore" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.AwayTeamScore = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.LeaugeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsFinished" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.IsFinished = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Report" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.Report = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Result" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.Result = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"WinTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.WinTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LoseTeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.LoseTeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsHot" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.IsHot = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TVLiveAll" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.TVLiveAll = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NewsID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.NewsID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LiveRoomID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.LiveRoomID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.HomeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.AwayName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Name" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.Name = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.GameTypeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.GameTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeUserBetsCount" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.HomeUserBetsCount = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeUserBetsPointCount" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.HomeUserBetsPointCount = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayUserBetsCount" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.AwayUserBetsCount = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayUserBetsPointCount" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.AwayUserBetsPointCount = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"CommentsCount" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.CommentsCount = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeRecentGameBox" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.HomeRecentGameBox = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayRecentGameBox" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.AwayRecentGameBox = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeBetweenRecentGameBox" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.HomeBetweenRecentGameBox = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayBetweenRecentGameBox" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.AwayBetweenRecentGameBox = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeSeasonGameBox" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.HomeSeasonGameBox = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwaySeasonGameBox" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.AwaySeasonGameBox = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsWin" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    detailInfo.IsWin = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }   
            [detailInfoTableArray addObject:detailInfo];
            [detailInfo release];
        } 
    }
    return [detailInfoTableArray autorelease];
}

+ (NSMutableArray *)fetchComment:(NSString *)time Count:(NSInteger) count gameID:(NSString *) gameIDParameter Index:(NSString *)index userID:(NSString *) userIDParameter
{
    NSString *soapAction = @"leisuresport/Comment_LoadByGameID_Time";
    NSString *tmp = [ NSString stringWithFormat:@"<Comment_LoadByGameID_Time xmlns=\"leisuresport\">"
                                     "<UserID>%@</UserID>"
                                     "<GameID>%@</GameID>"
                                     "<TimeStamp>%@</TimeStamp>"
                                     "<count>%d</count>"
                                     "<direction>0</direction>"
                                     "<CommentID>%@</CommentID>"
                                     "</Comment_LoadByGameID_Time>",userIDParameter
,gameIDParameter,time,count,index];

    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[LSWebServiceRequest alloc] init];
    NSMutableArray *commentTableArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        for (id obj in jsonObject) {       
            GameComments *comment = [[GameComments alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"CommentID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.CommentID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.UserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.GameID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Contents" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.Contents = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"time" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.time = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.NickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UserImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.UserImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.GameTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.HomeTeamName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"AwayTeamName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.AwayTeamName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.LeaugeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.GameTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }   
            [commentTableArray addObject:comment];
            [comment release];
        } 
    }
    [soapRequest release];
    return [commentTableArray autorelease];
}

+ (NSString *)fetchBetGame:(NSString *)userIDParameter gameID:(NSString *) gameIDParameter betSide:(NSString *) betSideParameter points:(NSString *) pointsPatameter;//对比赛下注
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/BetGame";

    NSString *tmp = [NSString stringWithFormat:@"<BetGame xmlns=\"leisuresport\">"
                     "<userID>%@</userID>"
                     "<gameID>%@</gameID>"
                     "<BetSide>%@</BetSide>"
                     "<points>%@</points>"
                     "</BetGame>", userIDParameter,gameIDParameter,betSideParameter,pointsPatameter];
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    //请求成功
    LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
    }
    return xmlParser.result;

}

+ (NSString *)fetchCommentID:(NSString *)userIDParameter gameID:(NSString *) gameIDParameter commentContent:(NSString *) commentContentPatameter;//发表评论，返回评论ID
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/Comment_Create";
    NSString *tmp = [NSString stringWithFormat:@"<Comment_Create xmlns=\"leisuresport\">"
                     "<UserID>%@</UserID>"
                     "<GameID>%@</GameID>"
                     "<commentContent>%@</commentContent>"
                     "</Comment_Create>", userIDParameter,gameIDParameter,commentContentPatameter];
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    //请求成功
    LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
    }
    return xmlParser.result;
}

@end
