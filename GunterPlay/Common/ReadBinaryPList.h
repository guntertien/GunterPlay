//
//  ReadBinaryPList.h
//  GunterPlay
//
//  Created by TianYuan on 2020/4/15.
//  Copyright © 2020 TianYuan. All rights reserved.
//

#import <Foundation/Foundation.h>



#if 0
#define BPListLog NSLog
#else
#define BPListLog(...)
#endif

#if 0
#define BPListLogVerbose BPListLog
#else
#define BPListLogVerbose(...)
#endif


typedef struct BPListTrailer
{
    uint8_t                unused[6];
    uint8_t                offsetIntSize;
    uint8_t                objectRefSize;
    uint64_t            objectCount;
    uint64_t            topLevelObject;
    uint64_t            offsetTableOffset;
} BPListTrailer;


enum
{
    kHeaderSize            = 8,
    kTrailerSize        = sizeof (BPListTrailer),
    kMinimumSaneSize    = kHeaderSize + kTrailerSize
};


enum
{
    // Object tags (high nybble)
    kTagSimple            = 0x00,    // Null, true, false, filler, or invalid
    kTagInt                = 0x10,
    kTagReal            = 0x20,
    kTagDate            = 0x30,
    kTagData            = 0x40,
    kTagASCIIString        = 0x50,
    kTagUnicodeString    = 0x60,
    kTagUID                = 0x80,
    kTagArray            = 0xA0,
    kTagDictionary        = 0xD0,
    
    // "simple" object values
    kValueNull            = 0x00,
    kValueFalse            = 0x08,
    kValueTrue            = 0x09,
    kValueFiller        = 0x0F,
    
    kValueFullDateTag    = 0x33    // Dates are tagged with a whole byte.
};


static const char kHeaderBytes[kHeaderSize] = "bplist00";


typedef struct BPListInfo
{
    uint64_t            objectCount;
    const uint8_t        *dataBytes;
    uint64_t            length;
    uint64_t            offsetTableOffset;
    uint8_t                offsetIntSize;
    uint8_t                objectRefSize;
    NSMutableDictionary    *cache;
} BPListInfo;


//static uint64_t ReadSizedInt(BPListInfo bplist, uint64_t offset, uint8_t size);
//static uint64_t ReadOffset(BPListInfo bplist, uint64_t index);
//static BOOL ReadSelfSizedInt(BPListInfo bplist, uint64_t offset, uint64_t *outValue, size_t *outSize);
//
//static id ExtractObject(BPListInfo bplist, uint64_t objectRef);
//
//static id ExtractSimple(BPListInfo bplist, uint64_t offset);
//static id ExtractInt(BPListInfo bplist, uint64_t offset);
//static id ExtractReal(BPListInfo bplist, uint64_t offset);
//static id ExtractDate(BPListInfo bplist, uint64_t offset);
//static id ExtractData(BPListInfo bplist, uint64_t offset);
//static id ExtractASCIIString(BPListInfo bplist, uint64_t offset);
//static id ExtractUnicodeString(BPListInfo bplist, uint64_t offset);
//static id ExtractUID(BPListInfo bplist, uint64_t offset);
//static id ExtractArray(BPListInfo bplist, uint64_t offset);
//static id ExtractDictionary(BPListInfo bplist, uint64_t offset);



NS_ASSUME_NONNULL_BEGIN

@interface ReadBinaryPList : NSObject

@end

NS_ASSUME_NONNULL_END
