//
//  HttpConnection.m
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import "HttpConnection.h"
#import "Reachability.h"

@implementation HttpConnection

static Reachability *hostReachability;
static Reachability *internetReachability;
static Reachability *wifiReachability;


-(id)initWithView:(UIView *)view
{
    self = [super init];
    if (self)
    {
        self.alert = [[AlertsUtil alloc]initWithView:view];
    }
    return self;
}


-(void)callGetMethod:(NSString *)url options:(NSDictionary *)options success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (options == nil) {
        options = @{};
    }
    BOOL exibirAlertas = [self getValue:options chave:@"exibirAlertas" default:@true];
    @try
    {
        
        NSDictionary *headersParams = @{
                                        @"Content-Type":@"application/x-www-form-urlencoded",
                                        @"Accept":@"application/json"
                                        };
        NSRange range = [url rangeOfString:@"?"];
        NSString *urlAux = url;
        NSMutableDictionary *newParams = [NSMutableDictionary new];
        
        if (range.length>0)
        {
            urlAux = [url substringToIndex:range.location];
            NSDictionary *params = [self stringParamsToDictionary:[url substringFromIndex:range.location+1]];
            newParams = [params mutableCopy];
        }
        
        [self callGetHttpMethod:urlAux parametros:newParams headersParams:headersParams options:options success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation,responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation,error);
        }];
        
        
        
    }
    @catch ( NSException *e )
    {
        NSLog(@"(callGetMethod) - Exception: %@",e);
        if (exibirAlertas)
        {
            [_alert exibirAlertaError: @"Desculpe, ocorreu um erro no processamento, por favor tente novamente."];
        }
    }
}



-(void)callGetHttpMethod:(NSString *)url parametros:(NSDictionary *)parametros headersParams:(NSDictionary *)headersParams options:(NSDictionary *)options success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    if (options == nil) {
        options = @{};
    }
    BOOL exibirAlertas = [self getValue:options chave:@"exibirAlertas" default:@true];
    NSString *textoAguarde = [self getValue:options chave:@"textoAguarde" default:nil];
    
    if ([self isInternetReachable])
    {
        
        if (exibirAlertas)
        {
            if (textoAguarde == nil)
            {
                [_alert exibirModalAguarde:@"Processando"];
            }
            else
            {
                [_alert exibirModalAguarde:textoAguarde];
            }
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        if (![headersParams isKindOfClass:[NSNull class]])
        {
            for (NSString* key in headersParams)
            {
                [manager.requestSerializer setValue:[headersParams objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        [manager GET:url parameters:parametros success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if (exibirAlertas)
             {
                 [_alert ocultarModalAguarde];
             }
#if DEBUG_MODE
             NSLog(@"Resposta da chamada http para a url [%@]:\n%@",operation.request.URL ,responseObject);
#endif
             success(operation,responseObject);
         }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             //NSDictionary *info = [error userInfo ];
             //            NSInteger status = [operation.response statusCode];
             //            NSDictionary *headers = [operation.response  allHeaderFields];
             //
             //            NSString *auth = [headers objectForKey:@"Www-Authenticate"];
             //            if (status == 401 || [PXFunctionsUtil containsString:auth contem:@"invalid_token"])
             //            {
             //                PXFunctionsUtil *func = [[PXFunctionsUtil alloc] init];
             //                [func addUserParameter:@"oauth_invalidate_token" valor:@1];
             //            }
             //[self tratarRetornoRequisicao:operation];
             if (exibirAlertas)
             {
                 [_alert ocultarModalAguarde];
             }
             NSLog(@"Error ocorrido na chamada http para a url [%@]: %@",operation.request.URL,[error description]);
             failure(operation,error);
         }];
    }
    else
    {
#if DEBUG_MODE
        NSLog(@"Error - Não há conexão de dados disponível");
#endif
        
        if (exibirAlertas)
        {
            [_alert exibirAlertaError: @"Não há conexão de dados disponível"];
        }
        NSError *erro = [NSError errorWithDomain:@"NotConnectedError" code:1001 userInfo:@{@"error":@"Error - Não há conexão de dados disponível"}];
        
        failure(nil,erro);
    }
}

- (BOOL)isInternetReachable
{
	internetReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [internetReachability currentReachabilityStatus];
    
    if (netStatus == NotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    //return [self isConnectionAvailable];
}



-(void)callPostMethod:(NSString *)url parametros:(NSDictionary *)parametros options:(NSDictionary *)options success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (options == nil) {
        options = @{};
    }
    //BOOL ignorarToken = [self getValue:options chave:@"ignorarToken" default:false];
    BOOL exibirAlertas = [self getValue:options chave:@"exibirAlertas" default:@true];
    //OAuthUtil *oauth = [[OAuthUtil alloc] initWithAlert:self.alert];
    @try
    {
        //[oauth verificarValidadeToken:ignorarToken success:^(NSString *newToken){
        
        NSDictionary *headersParams = @{
                                        @"Content-Type":@"application/x-www-form-urlencoded",
                                        @"Accept":@"application/json"
                                        };
        
        NSMutableDictionary *newParams = [parametros mutableCopy];
        //PXFunctionsUtil *func = [[PXFunctionsUtil alloc] init];
        //if (!ignorarToken) {
        //    [newParams setObject:[func getUserParameter:@"access_token"] forKey:@"access_token"];
        //}
        [self callPostHttpMethod:url parametros:newParams headersParams:headersParams parametrosBinarios:nil options:options success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation,responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation,error);
        }];
        
        //} failure:^{
        //    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]];
        //    NSError *error = [NSError errorWithDomain:@"OAUTHException" code:20001 userInfo:@{@"error":@"Error ao validar Token."}];
        //    failure(op,error);
        //}];
        
    }
    
    @catch ( NSException *e )
    {
        NSLog(@"(callPostMethod) - Exception: %@",e);
        if (exibirAlertas)
        {
            //[_alert exibirAlertaError: @"Desculpe, ocorreu um erro no processamento, por favor tente novamente."];
        }
    }
    
}


-(void)callPostHttpMethod:(NSString *)url parametros:(NSDictionary *)parametros headersParams:(NSDictionary *)headersParams parametrosBinarios:(NSDictionary *)parametrosBinarios options:(NSDictionary *)options success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (options == nil) {
        options = @{};
    }
    BOOL exibirAlertas = [self getValue:options chave:@"exibirAlertas" default:@true];
    NSString *textoAguarde = [self getValue:options chave:@"textoAguarde" default:nil];
    if ([self isInternetReachable])
    {
        if (exibirAlertas)
        {
            if (textoAguarde == nil)
            {
                [_alert exibirModalAguarde:@"Processando"];
            }
            else
            {
                [_alert exibirModalAguarde:textoAguarde];
            }
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //manager.requestSerializer.timeoutInterval = 30;
        
        if (![headersParams isKindOfClass:[NSNull class]])
        {
            for (NSString* key in headersParams)
            {
                [manager.requestSerializer setValue:[headersParams objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        [manager POST:url parameters:parametros constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             if (![parametrosBinarios isKindOfClass:[NSNull class]])
             {
                 for(NSString *binaryParams in parametrosBinarios.allKeys)
                 {
                     NSData *valor = [[parametrosBinarios objectForKey:binaryParams]objectForKey:@"file"];
                     NSString *fileName = [[parametrosBinarios objectForKey:binaryParams]objectForKey:@"fileName"];
                     NSString *mimeType = [[parametrosBinarios objectForKey:binaryParams]objectForKey:@"mimeType"];
                     
                     [formData appendPartWithFileData:valor name:binaryParams fileName:fileName mimeType:mimeType];
                 }
             }
         }
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if (exibirAlertas)
             {
                 [_alert ocultarModalAguarde];
             }
#if DEBUG_MODE
             NSLog(@"Resposta da chamada http para a url [%@]:\n%@",operation.request.URL ,responseObject);
#endif
             success(operation,responseObject);
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             //[self tratarRetornoRequisicao:operation];
             
             if (exibirAlertas)
             {
                 [_alert ocultarModalAguarde];
             }
             NSLog(@"Error ocorrido na chamada http para a url [%@]: %@",operation.request.URL,[error description]);
             failure(operation,error);
         }];
        
    }
    else
    {
#if DEBUG_MODE
        NSLog(@"Error - Não há conexão de dados disponível");
#endif
        if (exibirAlertas)
        {
            [_alert exibirAlertaError: @"Não há conexão de dados disponível"];
        }
    }
}



-(NSDictionary *) stringParamsToDictionary:(NSString *)params
{
    NSArray *parametros = [params componentsSeparatedByString:@"&"];
    NSMutableDictionary *retorno = [NSMutableDictionary new];
    
    for (NSString * p in parametros)
    {
        NSArray *parametro = [p componentsSeparatedByString:@"="];
        
        [retorno setObject:parametro[1] forKey:parametro[0]];
    }
    
    return retorno;
}

-(id) getValue:(NSDictionary *) dicionario chave:(id)chave default:(id)valor_default {
    id retorno = [dicionario objectForKey:chave];
    if(retorno) {
        return retorno;
    }
    return valor_default;
}

@end
