//
//  ProtocolUtil.m
//  WebCache
//
//  Created by yu qin on 2019/5/6.
//  Copyright © 2019 yu qin. All rights reserved.
//

#import "ProtocolUtil.h"
#import "WebCache-Swift.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation ProtocolUtil

// 需缓存的静态资源后缀
+ (NSArray<NSString *> *)getSource
{
    return @[@"png",@"jpeg",@"gif",@"jpg",@"js",@"css"];
}


// web拦截功能，核心 （全局web静态缓存,在AppDelegate统一设置，部分web静态缓存，在web应用界面设置）
 + (void)setupProtocol
{
    [NSURLProtocol registerClass:[URLProtocolCustom class]];
    Class cls = NSClassFromString(@"WKBrowsingContextController");
    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:@"http"];
        [(id)cls performSelector:sel withObject:@"https"];
#pragma clang diagnostic pop
    }
}


// 删除静态资源缓存
+ (void)removeCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [cacheDirectory stringByAppendingPathComponent:@"test"];
    
    NSError *error;
    
    [fileManager removeItemAtPath:testDirectory error:&error];
    
    NSLog(@"remove_error:%@",error);
    
}

// 创建缓存
+ (NSString *)createCacheFilePathWithFolderName:(NSString *)folderName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [cacheDirectory stringByAppendingPathComponent:@"test"];
    // 创建目录
    [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *filePath = [testDirectory stringByAppendingPathComponent:folderName];
    
    return filePath;
}

// 移动文件
+ (BOOL)moveItemAtPath:(NSString*)fromPath toPath:(NSString*)toPath{
    BOOL result = NO;
    NSError * error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (fromPath.length == 0) {
        return result;
    }
    result = [fileManager moveItemAtPath:fromPath toPath:toPath error:&error];
    if (error){
        NSLog(@"moveFile Fileid：%@",[error localizedDescription]);
    }
    return result;
}


+ (NSString *)getMimeTypeWithFilePath:(NSString *)filePath{
    CFStringRef pathExtension = (__bridge_retained CFStringRef)[filePath pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    CFRelease(pathExtension);
    
    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    if (type != NULL)
        CFRelease(type);
    
    return mimeType;
}

// 获取请求的后缀
+ (NSString *)getPathExtensionWithRequest:(NSURLRequest *)request {
    
    NSString *extension = request.URL.pathExtension;
    if (extension.length == 0) {
        extension = [request.URL.absoluteString componentsSeparatedByString:@"&"].firstObject;
        extension = [extension componentsSeparatedByString:@"."].lastObject;
    }
    return extension;
}



@end
