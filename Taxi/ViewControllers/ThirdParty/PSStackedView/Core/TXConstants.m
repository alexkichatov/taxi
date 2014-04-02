
//DEV
NSString* const kDefaultServerURL = @"http://frd03meapp01.test.invitrogen.net";
NSString* const kDefaultServerPort = @"8080";

//QA
//NSString* const kDefaultServerURL = @"https://frd03meapp01.test.invitrogen.net/TX-rest/";

//UAT
//NSString* const kDefaultServerURL = @"https://frd02meapp01.stage.invitrogen.net/TX-rest/";

NSString *const kErrorDomain = @"com.amindsolutions.TX";
NSInteger const kHoursInDay = 24;
NSInteger const kSecondsInHour = 3600;
NSString* const kDefaultCurrencyCode = @"USD";
NSString* const kPhoneTitle = @"Phone";
NSString* const kEmailTitle = @"Email";
NSString* const kAccountTitle = @"Account";
NSString *const kContactTitle = @"Contact";
NSString* const kMobileTitle = @"Mobile";
NSString* const kFaxTitle = @"Fax";

NSString* const kTypeTitle = @"Type";
NSString* const kTeamTitle = @"Team";
NSString* const kDescriptionTitle = @"Description";
NSString* const kOpportunityTitle = @"Opportunity";
NSString *const kPendingOpportunityStatus = @"Pending";
NSString *const kRejectedOpportunityStatus = @"Rejected";
NSString *const kAcceptedOpportunityStatus = @"Accepted";

NSUInteger const kMaxContactFirstNameTextSize = 30;
NSUInteger const kMaxContactLastNameTextSize = 30;
NSUInteger const kMaxOpportunityNameTextSize = 100;
NSUInteger const kMaxOpportunityDescriptionTextSize = 255;
NSUInteger const kMaxOpportunityNextStepTextSize = 60;
NSUInteger const kMaxQuoteNameTextSize = 30;
NSUInteger const kMaxNoteTextSize = 16350;
NSUInteger const kMaxAssetNoteTextSize = 860; // FIXME: should be clarified!
NSUInteger const kMaxActivityDescriptionTextSize = 100;
NSUInteger const kMaxActivityCommentTextSize = 860;

NSString *const kLastAccessedFileName = @"lastaccessed.plist";

NSString *const kContactStatusKey = @"CONTACT_STATUS";
NSString *const kContactDiscipline = @"LT_DISCIPLINE";
NSString *const kPhoneMasksKey = @"PHONE_FORMAT";

NSString *const kOpportunitySalesStageKey = @"SALES_STAGE";
NSString *const kOpportunityStatusKey = @"OPTY_STATUS";
NSString *const kOpportunityReasonWonLostKey = @"REASON_WON_LOST";
NSString *const kOpportunityInstrOrConsumKey = @"LT_INSTRMNT_CONSUMBLE";
NSString *const kOpportunityConsumTypeKey =@"LT_CONSUMBLE_TYPE";
NSString *const kOpportunityTypeKey = @"REVENUE_TYPE";
NSString *const kOpportunityProbabilityKey = @"PROB";
NSString *const kLeadRejectReasonKeyType = @"LT_OPTY_REASON_REJ";

NSString *const kSampleStatusKey = @"LT_SALES_SAMPLE_STATUS";
NSString *const kSamplePriorityKey = @"SAMPLE_ORDER_PRIORITY";
NSString *const kSampleBusinessAreaKey = @"LT_E1_REASON_TYPE_CD";

NSString *const kQuoteReportTypeKey = @"LT_TX_IOS_REPORT";
NSString *const kQuoteReportLocaleKey = @"LT_SQUOTE_REPORT_LOCALE";
NSString *const kQuoteReportLanguageKey = @"LT_SQUOTE_REPORT_LANG";
NSString *const kQuoteTypeKey = @"LT_IVGN_QUOTE_TYPE";
NSString *const kQuoteSubTypeKey = @"LT_IVGN_QUOTE_TYPE";

NSString *const kActivityTypeKey = @"TODO_TYPE";
NSString *const kActivityStatusKey = @"EVENT_STATUS";
NSString *const kActivityPriorityKey = @"ACTIVITY_PRIORITY";
NSString *const kAddressStateKey = @"STATE_ABBREV";
NSString *const kAddressCountryKey = @"COUNTRY";

NSString* const kDeleteButtonTitle = @"Delete";
NSString* const kUnsubscribeButtonTitle = @"Unsubscribe";
NSString* const kAccountProspect = @"Prospect";
NSString* const kGMTTimeZoneName = @"GMT";

NSString *const TXAppLogInfoNotification = @"AppLogInfo";
NSString *const TXWillShowViewControllerNotification = @"WillShowVCNotification";
NSString *const TXDidShowViewControllerNotification = @"DidShowVCNotification";

NSString* const kAllFilterItem = @"All";
NSString* const kAccountFilterItem = @"Account";
NSString* const kContactFilterItem = @"Contact";

NSString* const kButtonEdit = @"Edit";
NSString* const kButtonSave = @"Save";
NSString* const kButtonOk = @"OK";
NSString* const kButtonCancel = @"Cancel";
NSString* const kButtonSubmit = @"Submit";
NSString* const kButtonAddItem = @"Add Item";
NSString* const kButtonSubmitToSiebel = @"Submitted to Siebel";

inline NSString *GetUUID()
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfStringUUID = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    NSString *stringUUID = [NSString stringWithString:(__bridge NSString *) cfStringUUID];
    CFRelease((CFTypeRef) uuid);
    CFRelease((CFTypeRef) cfStringUUID);
    return stringUUID;
}
