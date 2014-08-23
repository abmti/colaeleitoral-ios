
#ifndef Global_h
#define Global_h

#define DEBUG_MODE 1
#define IQKEYBOARDMANAGER_DEBUG 1

//#define URL_BASE @"http://192.168.157.250:3000" //Michel
#define URL_BASE @"http://localhost:3000" //Local

#define URL_ESTADOS [NSString stringWithFormat:@"%@%@",URL_BASE, @"/estados"]
#define URL_COLA [NSString stringWithFormat:@"%@%@",URL_BASE, @"/cola"]
#define URL_CANDIDATOS [NSString stringWithFormat:@"%@%@",URL_BASE, @"/candidatos"]
#define URL_AVALIA [NSString stringWithFormat:@"%@%@",URL_BASE, @"/avalia"]
#define URL_REMOVE [NSString stringWithFormat:@"%@%@",URL_BASE, @"/remove"]
#define URL_PARTIDOS [NSString stringWithFormat:@"%@%@",URL_BASE, @"/partidos"]

#endif
