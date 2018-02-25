//
//  BugConnector.h
//  SpeakToMe
//
//  Created by satorupan on 2018/02/08.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BugConnector : NSObject{
    
}

-(void)setupBle;
- (NSString*)setQue:(NSString *)argString;

- (NSString*)checkText:(NSString *)argString;

-(void)initBle:(id) mySender;

-(void)sendData:(int)key Value:(int)value;
@end
