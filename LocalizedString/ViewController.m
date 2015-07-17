//
//  ViewController.m
//  LocalizedString
//
//  Created by qiandong on 6/17/15.
//  Copyright (c) 2015 qiandong. All rights reserved.
//

#import "ViewController.h"
#import "Item.h"


@interface ViewController()
{
    NSString *_currentDirectory;
}

@property (strong) IBOutlet NSTextField *mutilTextLabel;
@property (strong) IBOutlet NSTextField *resultLabel;

- (IBAction)btnAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    //release版本
//    _currentDirectory = [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByAppendingString:@"/"];
    
    //debug版本,设为你放置3个文件的目录
    _currentDirectory = @"/Users/qiandong/Desktop/";
    
    [_mutilTextLabel setStringValue:@"\
1:将ios工程的localized.string文件复制一份，改名为1.txt \n \
2:用page打开翻译文件，删除多余的列只剩ioskey和翻译的2列，并去掉最上面的一行（标题），然后复制2列黏贴到文本，命名为2.txt \n \
3：本app、1.txt、2.txt放在同一个目录下 \n \
4：点击generate按钮，生成的目标文件为同目录下的9.txt \n \
      \n \
TIPS:【一般不会发生的情况】 \n \
a)若1.txt含\"\"字符串，请替换为" "再按generate按钮。 \n \
b)若1.txt含\\\"字符串，请记下该key，在生成结束后，单独替换该value    \n \
c)1.txt里没有，而2.txt里有的行，不会被生成到9.txt里 \n \
d)本程序没处理异常及优化性能，看下最后结果行被生成了就OK \n \
     "];

}

//按钮事件，执行算法
- (IBAction)btnAction:(id)sender {
    
    [_resultLabel setStringValue:@""];
    
    NSArray *localizedArray = [self localizedArray];
    NSArray *translateArray = [self translateArray];
    
    NSFileHandle *fh = [self targetFileHandler];
    
    for (int i = 0; i < localizedArray.count; i++) {
        Item *item1 = [localizedArray objectAtIndex:i];
        
        BOOL find = NO;
        for (int j = 0; j < translateArray.count; j++) {
            Item *item2 = [translateArray objectAtIndex:j];
            
            if ([item1.key isEqualToString:item2.key]) {
                NSString *valueToWrite = [NSString stringWithFormat:@"\"%@\" = \"%@\";\r\n",item1.key,item2.value];
                [fh seekToEndOfFile];
                [fh writeData:[valueToWrite dataUsingEncoding:NSUTF8StringEncoding]];
                find = YES;
                break;
            }
        }
        if (!find) {
            NSString *valueToWrite = [NSString stringWithFormat:@"\"%@\" = \"%@\";\r\n",item1.key,item1.value];
            [fh seekToEndOfFile];
            [fh writeData:[valueToWrite dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [fh closeFile];
    
    [_resultLabel setStringValue:@"成功"];
}

//目标文件handler
-(NSFileHandle *)targetFileHandler
{
    NSString *path = [_currentDirectory stringByAppendingString:@"9.txt"];
    NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath:path];
    if (fh) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    fh = [NSFileHandle fileHandleForWritingAtPath:path];
    return fh;
}

//生成localized.string的NSArray
-(NSArray *)localizedArray
{
    NSString *filePath = [_currentDirectory stringByAppendingString:@"1.txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSMutableArray *localizedArray = [NSMutableArray array];
    
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        // Do something
        //        NSLog(@"%@",line);
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\"]+" options:0 error:nil];
        NSArray* matches = [regex matchesInString:line
                                          options:NSMatchingWithoutAnchoringBounds
                                            range:NSMakeRange(0, line.length)];
        if (matches.count == 4) {
            NSTextCheckingResult *result = [matches objectAtIndex:0];
            NSRange range = [result range];
            NSString *key = [line substringWithRange:range];
            
            
            result = [matches objectAtIndex:2];
            range = [result range];
            NSString *value = [line substringWithRange:range];
            
            Item *item = [[Item alloc] initWithKey:key Value:value];
            [localizedArray addObject:item];
        }
    }
    
    NSLog(@"%lu",(unsigned long)[localizedArray count]);
    return localizedArray;
}

//生成翻译文件的NSArray，仅包含key和value都有的数据（无key或无value不加入array）
-(NSArray *) translateArray
{
    NSString *filePath = [_currentDirectory stringByAppendingString:@"2.txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSMutableArray *translateArray = [NSMutableArray array];
    
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        // Do something
        //        NSLog(@"%@",line);
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\t]+" options:0 error:nil];
        NSArray* matches = [regex matchesInString:line
                                          options:NSMatchingWithoutAnchoringBounds
                                            range:NSMakeRange(0, line.length)];
        if (matches.count == 2) {
            NSTextCheckingResult *result = [matches objectAtIndex:0];
            NSRange range = [result range];
            NSString *key = [line substringWithRange:range];
            
            
            result = [matches objectAtIndex:1];
            range = [result range];
            NSString *value = [line substringWithRange:range];
            
            Item *item = [[Item alloc] initWithKey:key Value:value];
            [translateArray addObject:item];
        }
    }
    NSLog(@"%lu",(unsigned long)translateArray.count);
    return translateArray;
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
