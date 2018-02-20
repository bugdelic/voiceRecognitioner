//
//  BugConnector.m
//  SpeakToMe
//
//  Created by satorupan on 2018/02/08.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

#import "BugConnector.h"
#import "SQLiteManager.h"


@implementation BugConnector


- (NSString*)checkText:(NSString *)argString;{
    
    int flag1=0;
    int flag2=0;
    NSRange range;
    range = [argString rangeOfString:@"ネズミ"];
    if (range.location == NSNotFound) {
    }else{
        flag1=1;
    }
    range = [argString rangeOfString:@"牛"];
    if (range.location == NSNotFound) {
    }else{
        flag1=2;
    }
    range = [argString rangeOfString:@"トラ"];
    if (range.location == NSNotFound) {
    }else{
        flag1=3;
    }
    range = [argString rangeOfString:@"うさぎ"];
    if (range.location == NSNotFound) {
    }else{
        flag1=4;
    }
    
    range = [argString rangeOfString:@"前"];
    if (range.location == NSNotFound) {
    }else{
        flag2=1;
    }
    range = [argString rangeOfString:@"後"];
    if (range.location == NSNotFound) {
    }else{
        flag2=2;
    }
    range = [argString rangeOfString:@"左"];
    if (range.location == NSNotFound) {
    }else{
        flag2=3;
    }
    range = [argString rangeOfString:@"右"];
    if (range.location == NSNotFound) {
    }else{
        flag2=4;
    }
    
        
        NSMutableDictionary*bugReturner=[NSMutableDictionary dictionary];
        
        [bugReturner setObject:argString forKey:@"title"];
        [bugReturner setObject:[NSNumber numberWithInteger:flag1] forKey:@"animal"];
        [bugReturner setObject:[NSNumber numberWithInteger:flag2] forKey:@"direction"];
        
        NSError* error;
        NSString*jsonBug;
        if([NSJSONSerialization isValidJSONObject:bugReturner]){
            NSData *json = [NSJSONSerialization dataWithJSONObject:bugReturner    options:NSJSONWritingPrettyPrinted error:&error];
            NSLog(@"json %@", [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding] );
            jsonBug=[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            
        }
        
        return [NSString stringWithFormat:@"%d,%d",flag1,flag2 ];

}
- (NSString*)setQue:(NSString *)argString{
    
    NSLog(@"%@",argString);
    NSString*t=[self getCharCodeUTF16:argString];
    NSString*t2=[self getCharCode:argString encoding:@"NSUTF8StringEncoding"];
    
    //NSLog(@"%@",t);
    
    
    NSData* sjisData = [ argString dataUsingEncoding:NSShiftJISStringEncoding // SJIS変換指定
                          allowLossyConversion:YES // 変換不能でもとにかく変換
                         ];
    
    NSString *str =[self serializeDeviceToken:sjisData];
    NSLog(@"%@",t);
    NSLog(@"%@",str);
    
    NSMutableArray*bugSet=[NSMutableArray array];
    
    SQLiteManager*fotnModel=[[SQLiteManager alloc] init];
    
    NSArray *array = [t componentsSeparatedByString:@" "];
    
    for(int i=1; i<[array count]; i++){
        // 処理
        NSDictionary*returner=[fotnModel fotnSelect:[array objectAtIndex:i]];
        if(returner){
            [bugSet addObject:returner];
        }
        else{
            NSLog(@"Error: %@",[array objectAtIndex:i]);
        }
        
    }
    
    NSMutableDictionary*bugReturner=[NSMutableDictionary dictionary];
    [bugReturner setObject:t forKey:@"unicodeSet"];
    [bugReturner setObject:argString forKey:@"title"];
    [bugReturner setObject:bugSet forKey:@"data"];
    
    NSError* error;
    NSString*jsonBug;
    if([NSJSONSerialization isValidJSONObject:bugReturner]){
        NSData *json = [NSJSONSerialization dataWithJSONObject:bugReturner    options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"json %@", [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding] );
        jsonBug=[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        
    }
    
    return jsonBug;
    
    

}
- (NSString *)getCharCodeUTF16:(NSString *)input
{
    int stringLength = (int)[input length];
    NSString *utf16 = @"";
    for (int i = 0; i < stringLength; i++) {
        unichar c = [input characterAtIndex:i];
        utf16 = [utf16 stringByAppendingFormat:@" 0x%02X",c];
    }
    return utf16;
}
- (NSString *)getCharCode:(NSString *)string encoding:(NSStringEncoding)encoding
{
    NSData *data = [string dataUsingEncoding:encoding];
    NSUInteger length = data.length;
    NSString *code = @"";
    for (NSUInteger i=0;i<length;++i) {
        unsigned char aBuffer[1];
        [data getBytes:aBuffer range:NSMakeRange(i,1)];
        code = [code stringByAppendingFormat:@"0x%02X", aBuffer[0]];
    }
    return code;
}


- (NSString*) serializeDeviceToken:(NSData*) deviceToken

{
    NSMutableString *str = [[NSMutableString alloc] init];
    int length = [deviceToken length];
    char *bytes = malloc(sizeof(char) * length);
    [deviceToken getBytes:bytes length:length];
    for (int i = 0; i < length; i++)
    {
        [str appendFormat:@"%02.2hhX", bytes[i]];
    }
    free(bytes);
    return str;
}

@end
