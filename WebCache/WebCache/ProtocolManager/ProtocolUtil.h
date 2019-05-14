//
//  ProtocolUtil.h
//  WebCache
//
//  Created by yu qin on 2019/5/6.
//  Copyright © 2019 yu qin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProtocolUtil : NSObject

+ (NSArray<NSString *> *)getSource;
+ (void)setupProtocol;
+ (void)removeCache;
+ (BOOL)moveItemAtPath:(NSString*)fromPath toPath:(NSString*)toPath;
+ (NSString *)getMimeTypeWithFilePath:(NSString *)filePath;
+ (NSString *)getPathExtensionWithRequest:(NSURLRequest *)request;
+ (NSString *)createCacheFilePathWithFolderName:(NSString *)folderName;
@end

NS_ASSUME_NONNULL_END
