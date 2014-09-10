/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License for anything not specifically marked as developed by a third party.
 Apple's code excluded.
 Use at your own risk
 */

#import <SystemConfiguration/SystemConfiguration.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import "UIDevice-Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation UIDevice (Reachability)
SCNetworkConnectionFlags connectionFlags;

// Matt Brown's get WiFi IP addy solution
// http://mattbsoftware.blogspot.com/2009/04/how-to-get-ip-address-of-iphone-os-v221.html
+ (NSString *) localWiFiIPAddress
{
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	
	success = getifaddrs(&addrs) == 0;
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) 
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
					return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return nil;
}

+ (NSString *) getIPAddress
{
    NSString *address = @"192.168.1.100";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *ifname = [UIDevice activeWWAN] ? @"pdp_ip0" : @"en0";
				if ([name isEqualToString:ifname])  // cellular adapter / Wi-Fi adapter
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

- (NSUInteger) getWifiBytesOut
{
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	
	success = getifaddrs(&addrs) == 0;
	
	NSUInteger oBytes = 0;
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_LINK && (cursor->ifa_flags & IFF_LOOPBACK) == 0) 
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                NSString *ifname = [UIDevice activeWWAN] ? @"pdp_ip0" : @"en0";
				if ([name isEqualToString:ifname])  // cellular adapter / Wi-Fi adapter
				{
					struct if_data *if_data = (struct if_data *)cursor->ifa_data;
					
					if(if_data){
						oBytes += if_data->ifi_obytes;
					}
				}
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	
	return oBytes;
}

- (NSUInteger) getWifiBytesIn
{
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	
	success = getifaddrs(&addrs) == 0;
	
	NSUInteger iBytes = 0;
	
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_LINK && (cursor->ifa_flags & IFF_LOOPBACK) == 0) 
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                NSString *ifname = [UIDevice activeWWAN] ? @"pdp_ip0" : @"en0";
				if ([name isEqualToString:ifname])  // cellular adapter / Wi-Fi adapter
				{
					struct if_data *if_data = (struct if_data *)cursor->ifa_data;
					
					if(if_data){
						iBytes += if_data->ifi_ibytes;
					}
				}
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	
	return iBytes;
}

#pragma mark Checking Connections

+ (void) pingReachabilityInternal
{
	BOOL ignoresAdHocWiFi = NO;
	struct sockaddr_in ipAddress;
	bzero(&ipAddress, sizeof(ipAddress));
	ipAddress.sin_len = sizeof(ipAddress);
	ipAddress.sin_family = AF_INET;
	ipAddress.sin_addr.s_addr = htonl(ignoresAdHocWiFi ? INADDR_ANY : IN_LINKLOCALNETNUM);
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *)&ipAddress);    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &connectionFlags);
    CFRelease(defaultRouteReachability);
	if (!didRetrieveFlags) 
        printf("Error. Could not recover network reachability flags\n");
}


//下面有一些测试驱动配置，测试各种网络情况下的提示是否正确
+ (BOOL) networkAvailable
{
	//test
	//return NO;
	[self pingReachabilityInternal];
	BOOL isReachable = ((connectionFlags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((connectionFlags & kSCNetworkFlagsConnectionRequired) != 0);
    
    BOOL nonWiFi = ((connectionFlags & kSCNetworkReachabilityFlagsTransientConnection) != 0);
	
	if (nonWiFi) {
		return YES;
	}
    
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (BOOL) activeWWAN
{
	// test
    //return YES;
	if (![self networkAvailable]) return NO;
	return ((connectionFlags & kSCNetworkReachabilityFlagsIsWWAN) != 0);
}

+ (BOOL) activeWLAN
{  
    BOOL bRet = ([UIDevice localWiFiIPAddress] != nil);
	return bRet;
}

+ (BOOL)isInUSA{
	CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
	if (netInfo) {
		CTCarrier *carrier = [netInfo subscriberCellularProvider];
		if (carrier) {
			NSString *mcc = [carrier mobileCountryCode];
			if ([mcc isEqualToString:@"310"] || [mcc isEqualToString:@"311"]) {
				return YES;
			}
		}
	}
	
	return NO;
}

+ (BOOL)isInChina{
	CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
	if (netInfo) {
		CTCarrier *carrier = [netInfo subscriberCellularProvider];
		if (carrier) {
			NSString *mcc = [carrier mobileCountryCode];
			if ([mcc isEqualToString:@"460"]) {
				return YES;
			}
		}
	}
	
	return NO;
}

+ (BOOL)isInHongkong{
	CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
	if (netInfo) {
		CTCarrier *carrier = [netInfo subscriberCellularProvider];
		if (carrier) {
			NSString *mcc = [carrier mobileCountryCode];
			if ([mcc isEqualToString:@"454"]) {
				return YES;
			}
		}
	}
	
	return NO;
}

+ (BOOL)isInTaiwan{
	CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
	if (netInfo) {
		CTCarrier *carrier = [netInfo subscriberCellularProvider];
		if (carrier) {
			NSString *mcc = [carrier mobileCountryCode];
			if ([mcc isEqualToString:@"466"]) {
				return YES;
			}
		}
	}
	
	return NO;
}


@end