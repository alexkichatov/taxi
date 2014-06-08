
#import "NSData+StringBytes.h"

static const char* const kHexDigits = "0123456789abcdef";

@implementation NSData (StringBytes)

- (NSString *)stringRepresentation
{
    NSUInteger dataSize = self.length;
    unsigned long memorySize = 2*sizeof(char)*dataSize+1;
    char *pHexCharsString = (char*)malloc(memorySize);
    char *pHexChars = pHexCharsString;
    const Byte *pHexBytes = (Byte*)self.bytes;
    memset(pHexChars, 0, memorySize);
    for (NSUInteger i = 0; i < self.length; ++i)
    {
        const Byte currentByte = *pHexBytes++;
        *pHexChars++ = kHexDigits[(currentByte >> 4) & 0x0F];
        *pHexChars++ = kHexDigits[currentByte & 0x0F];
    }
    NSString *result = [NSString stringWithUTF8String:pHexCharsString];
    free(pHexCharsString);
    return result;
}

@end