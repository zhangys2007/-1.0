

#import "Discover-NetWorkInterfaceBlock.h"
//延展
@interface Discover_NetWorkInterfaceBlock ()
@property (nonatomic, retain)NSMutableData *data;
@property (nonatomic, copy)SuccessfulBlock successBolck;
@property (nonatomic, copy)FailBlock failBlock;
@end
@implementation Discover_NetWorkInterfaceBlock

- (void)dealloc
{
    self.failBlock  = nil;
    self.successBolck =nil;
    self.data = nil;
    [super dealloc];
}
-(id)initWithSuccessful:(SuccessfulBlock)aSuccessBlock fail:(FailBlock)aFailBlock
{
    self = [super init];
    if (self) {
        self.successBolck  = aSuccessBlock;
        self.failBlock = aFailBlock;
    }
    return self;
}
-(void)get:(NSString *)urlString
{
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)post:(NSString *)urlString params:(NSString *)paramString
{
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSData * paramsData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:paramsData];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}
//已经接收相应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData dataWithCapacity:1];
}
//已经接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
//已经接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //id  dic = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:nil];
    //NSLog(@"-------%@", self.data);
    NSArray * array = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:nil];
    //NSLog(@"%@",dic);
    //回调
    self.successBolck(array);
}
//接收出错
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //回调
    BOOL result = self.failBlock(error);
    if (result) {
//        NSLog(@"错误已经处理!");
    }
}

@end
