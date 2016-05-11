//
//  PayTmConfig.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 4/13/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#ifndef PayTmConfig_h
#define PayTmConfig_h


//for production
#define     PayTm_MID                   @"mytaxi98101561891490"
#define     PayTm_CHANNEL_ID            @"WAP"
#define     PayTm_INDUSTRY_TYPE_ID      @"Retail105"
#define     PayTm_WEBSITE               @"mytaxiindiawap"
#define     PayTm_checksumGenerationURL @"http://api.mytaxiindia.com/meta/getPaytmCode"
#define     PayTm_checksumValidationURL @"http://tms.mytaxiindia.com/payment/verifyPaytm"
#define     PayTm_serverUrl             eServerTypeProduction



//for test
//#define     PayTm_MID                   @"WorldP64425807474247"
//#define     PayTm_CHANNEL_ID            @"WAP"
//#define     PayTm_INDUSTRY_TYPE_ID      @"Retail"
//#define     PayTm_WEBSITE               @"worldpressplg"
//#define     PayTm_checksumGenerationURL @"https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp"
//#define     PayTm_checksumValidationURL @"https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp"
//#define     PayTm_serverUrl             eServerTypeStaging


#endif /* PayTmConfig_h */
