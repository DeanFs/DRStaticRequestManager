//
//  DRSandBoxManager.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/7.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRSandBoxManager : NSObject

#pragma mark - 磁盘信息获取
/**
 获取磁盘空间信息
 
 @param block 获取结果回调
 */
+ (void)getDiskSpaceInfoWithBlock:(void(^)(NSError *error, unsigned long long freeSpace, unsigned long long totalSpace))block;

/**
 获取指定路径文件或文件夹大小
 
 @param filePath 文件或文件夹绝对路径
 @param block 获取结果回调
 */
+ (void)getFileSizeWithPath:(NSString*)filePath
                  doneBlock:(void(^)(NSError *error, unsigned long long fileSize))block;


#pragma mark - 沙盒系统文件夹路径，文件管理
/**
 * 获取document目录路径
 */
+ (NSString *)getDocumentPath;

/**
 返回Document下的指定文件夹，不存在则自动创建文件夹，dirName
 
 @param dirName 文件夹名，可以是纯文件夹名称，如User，也可以是相对路径，如User/Audio，也可以是包含Document的绝对路径
 @param block 获取结果回调
 */
+ (void)getDirectoryInDocumentWithName:(NSString *)dirName
                             doneBlock:(void(^)(BOOL success, NSError *error, NSString *dirPath))block;

/**
 返回Document下dirName文件夹内的fileName文件路径，有需要时会自动创建文件夹
 
 @param fileName 单纯的文件名，如music.wav，不可包含带 ’/‘ 的文件夹路径
 @param dirName 文件夹名，可以是纯文件夹名称，如User，也可以是相对路径，如User/Audio，也可以是包含Document的绝对路径，
 为空则表示fileName是在document下
 @param block 获取结果回调
 */
+ (void)getFilePathWithName:(NSString *)fileName
                      inDir:(NSString *)dirName
                  doneBlock:(void(^)(NSError *error, NSString *filePath))block;

/**
 获取文件夹下的子目录列表
 
 @param dirPath 文件夹绝对路径
 @return 子目录列表
 */
+ (NSArray *)getSubpathsAtPath:(NSString *)dirPath;

/**
 移动文件
 
 @param path 文件原绝对路径
 @param targetPath 文件目标绝对路径
 @param block 移动完成回调
 */
+ (void)moveFileAtPath:(NSString *)path
                toPath:(NSString *)targetPath
             doneBlock:(void(^)(BOOL success, NSError *error))block;

/**
 检查是否存在文件
 
 @param filePath 文件绝对路径
 @return 检查结果
 */
+ (BOOL)isExistsFileAtPath:(NSString *)filePath;

/**
 检查是否存在文件夹
 
 @param folderPath 文件夹绝对路径
 @return 检查结果
 */
+ (BOOL)isExistsFolderAtPath:(NSString *)folderPath;

/**
 删除指定文件或文件夹
 
 @param filePath 文件或者文件夹绝对路径
 @param block 删除结果回调
 */
+ (void)deleteFileAtPath:(NSString *)filePath doneBlock:(void(^)(NSString *filePath, BOOL success, NSError *error))block;


#pragma mark- 获取文件的数据
/**
 读取文件 path问该文件绝对路径
 
 @param path 文件路径
 @return 文件内容
 */
+ (NSData *)getDataForPath:(NSString *)path;


#pragma mark - 保存图片到手机相册
/**
 保存指定照片到相册
 
 @param image 指定要保存的图片
 @param saveDoneBlock 保存完成回调
 */
+ (void)saveToDiskWithImage:(UIImage *)image
              saveDoneBlock:(void(^)(BOOL success, NSError *error))saveDoneBlock;

@end

NS_ASSUME_NONNULL_END
