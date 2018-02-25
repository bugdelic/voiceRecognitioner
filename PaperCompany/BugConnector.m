//
//  BugConnector.m
//  SpeakToMe
//
//  Created by satorupan on 2018/02/08.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

#import "BugConnector.h"
#import "SQLiteManager.h"
#import "PaperCompany-Swift.h"

@import CoreBluetooth;

@interface BugConnector () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *characteristic;
@property (nonatomic, strong) CBCharacteristic *characteristic2;
@property (nonatomic, strong) FotnViewController *sender;
@end

@implementation BugConnector

-(void)setupBle{
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

-(void)initBle:(id) mySender{
    
    _sender=(FotnViewController*)mySender;
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];

}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    NSLog(@"state:%ld", (long)central.state);
}

- (void)   centralManager:(CBCentralManager *)central
    didDiscoverPeripheral:(CBPeripheral *)peripheral
        advertisementData:(NSDictionary *)advertisementData
                     RSSI:(NSNumber *)RSSI
{
    NSLog(@"peripheral：%@", peripheral);
    
    NSRange range = [peripheral.name  rangeOfString: @"SATORUPAN" options: NSCaseInsensitiveSearch];
    NSLog(@"found: %@", (range.location != NSNotFound) ? @"Yes" : @"No");
    if (range.location != NSNotFound && range.location != nil) {
        // your code
        
        [self.centralManager stopScan];
        self.centralManager = central;
        self.peripheral = peripheral;
        [central connectPeripheral:self.peripheral options:nil];
    }


}
// ペリフェラルへの接続が成功すると呼ばれる
- (void)  centralManager:(CBCentralManager *)central
    didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"connected!");
    
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

// ペリフェラルへの接続が失敗すると呼ばれる
- (void)        centralManager:(CBCentralManager *)central
    didFailToConnectPeripheral:(CBPeripheral *)peripheral
                         error:(NSError *)error
{
    NSLog(@"failed...");
}

- (void)     peripheral:(CBPeripheral *)peripheral
    didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"error: %@", error);
        return;
    }
    
    NSArray *services = peripheral.services;
    NSLog(@"Found %lu services! :%@", (unsigned long)services.count, services);
    
    CBService * service=[services objectAtIndex:0];
    
    [peripheral discoverCharacteristics:nil forService:service];

}

- (void)                      peripheral:(CBPeripheral *)peripheral
    didDiscoverCharacteristicsForService:(CBService *)service
                                   error:(NSError *)error
{
    if (error) {
        NSLog(@"error: %@", error);
        return;
    }
    
    NSArray *characteristics = service.characteristics;
    
    
    //NSLog(@"Found %lu characteristics! : %@", (unsigned long)characteristics.count, characteristics);
    
    [characteristics enumerateObjectsUsingBlock:^(CBCharacteristic *obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%lu: %@", idx, obj);
        
        if ([[[obj UUID] UUIDString] isEqualToString:@"00035B03-58E6-07DD-021A-08123A000301"]) {
          //  result = idx;
           // *stop = YES;
            _characteristic=obj;
        }else if ([[[obj UUID] UUIDString] isEqualToString:@"00035B03-58E6-07DD-021A-08123A0003FF"]) {
            
            _characteristic2=obj;
        }
    }];
    
    [NSThread sleepForTimeInterval:1.0];
    [_peripheral setNotifyValue:YES
             forCharacteristic:_characteristic];

}


- (void)                 peripheral:(CBPeripheral *)peripheral
    didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
                              error:(NSError *)error
{
    if (error) {
        NSLog(@"Failed... error: %@", error);
        return;
    }
    
    NSLog(@"Succeeded！ service uuid:%@, characteristice uuid:%@, value%@",
          characteristic.service.UUID, characteristic.UUID, characteristic.value);
    NSString *string = [NSString stringWithFormat:@"%@",characteristic.value];
    if([string isEqualToString:@"<00>"]){
        [_sender pingWithMyValue:0];
    }else if([string isEqualToString:@"<11>"]){
        [_sender pingWithMyValue:1];
        
    }
}


-(void)sendData:(int)key Value:(int)value{
    
    NSString*string=[NSString stringWithFormat:@"%d:%d",key,value];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

    [_peripheral writeValue:data
         forCharacteristic:_characteristic2
                      type:CBCharacteristicWriteWithResponse];
}


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
    NSString*t2=[self getCharCode:argString encoding:NSUTF8StringEncoding];
    
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
        utf16 = [utf16 stringByAppendingFormat:@" 0x%04X",c];
    }
    return utf16;
}
- (NSString *)getCharCode:(NSString *)string encoding:(NSStringEncoding)encoding
{
   // NSData *data = [string dataUsingEncoding:encoding];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = data.length;
    NSString *code = @"";
    for (NSUInteger i=0;i<length;++i) {
        unsigned char aBuffer[1];
        [data getBytes:aBuffer range:NSMakeRange(i,1)];
        code = [code stringByAppendingFormat:@"0x%04X", aBuffer[0]];
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
