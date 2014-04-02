
#import <Foundation/Foundation.h>

#define kTopBlueGradientColor [UIColor colorWithRed:243.0f/255 green:243.0f/255 blue:243.0f/255 alpha:1.0f].CGColor
#define kBottomBlueGradientColor [UIColor colorWithRed:240.0f/255 green:240.0f/255 blue:240.0f/255 alpha:1.0f].CGColor
#define kLabelTextColor [UIColor colorWithRed:0.0f/255 green:107.0f/255 blue:172.0f/255 alpha:1.0f]

#pragma mark - Modules 

//#define DEBUG_LOG_FLUSH

typedef enum {
    TXModuleUnknown=0,
    TXModuleHome = 1,
    TXModuleAccount,
    TXModuleContact,
    TXModuleOpportunity,
    TXModuleLead,
    TXModuleSample,
    TXModuleQuote,
    TXModuleAssets,
    TXModuleActivity,
    TXModuleErrorLog,
    TXModuleSettings,
} TXModuleType;

#pragma mark - Type definitions

typedef void (^SimpleBlock)();

#pragma mark - General constants

extern NSString* const kDefaultServerURL;
extern NSString* const kDefaultServerPort;

extern NSString *const kErrorDomain;
extern NSInteger const kHoursInDay;
extern NSInteger const kSecondsInHour;
extern NSString* const kDefaultCurrencyCode;
extern NSString* const kPhoneTitle;
extern NSString* const kEmailTitle;
extern NSString* const kAccountTitle;
extern NSString *const kContactTitle;
extern NSString* const kMobileTitle;
extern NSString* const kFaxTitle;
extern NSString* const kTypeTitle;
extern NSString* const kTeamTitle;
extern NSString* const kDescriptionTitle;
extern NSString* const kOpportunityTitle;
extern NSString *const kPendingOpportunityStatus;
extern NSString *const kRejectedOpportunityStatus;
extern NSString *const kAcceptedOpportunityStatus;
extern NSUInteger const kMaxContactFirstNameTextSize;
extern NSUInteger const kMaxContactLastNameTextSize;
extern NSUInteger const kMaxOpportunityNameTextSize;
extern NSUInteger const kMaxOpportunityDescriptionTextSize;
extern NSUInteger const kMaxOpportunityNextStepTextSize;
extern NSUInteger const kMaxQuoteNameTextSize;
extern NSUInteger const kMaxNoteTextSize;
extern NSUInteger const kMaxAssetNoteTextSize;
extern NSUInteger const kMaxActivityDescriptionTextSize;
extern NSUInteger const kMaxActivityCommentTextSize;
extern NSString* const kDeleteButtonTitle;
extern NSString* const kUnsubscribeButtonTitle;
extern NSString* const kAccountProspect;
extern NSString* const kGMTTimeZoneName;

#pragma mark - Filesystem constants

extern NSString *const kLastAccessedFileName;

#pragma mark - LOV Constants

extern NSString *const kPhoneMasksKey;
extern NSString *const kContactStatusKey;
extern NSString *const kContactDiscipline;

extern NSString *const kOpportunitySalesStageKey;
extern NSString *const kOpportunityStatusKey;
extern NSString *const kOpportunityReasonWonLostKey;

extern NSString *const kSampleStatusKey;
extern NSString *const kSamplePriorityKey;
extern NSString *const kSampleBusinessAreaKey;

extern NSString *const kOpportunityInstrOrConsumKey;
extern NSString *const kOpportunityConsumTypeKey;
extern NSString *const kOpportunityTypeKey;
extern NSString *const kOpportunityProbabilityKey;
extern NSString *const kLeadRejectReasonKeyType;

extern NSString *const kQuoteTypeKey;
extern NSString *const kQuoteSubTypeKey;
extern NSString *const kQuoteReportTypeKey;
extern NSString *const kQuoteReportLocaleKey;
extern NSString *const kQuoteReportLanguageKey;

extern NSString *const kActivityTypeKey;
extern NSString *const kActivityStatusKey;
extern NSString *const kActivityPriorityKey;
extern NSString *const kAddressStateKey;
extern NSString *const kAddressCountryKey;

#pragma mark - Notifications Names

extern NSString *const TXAppLogInfoNotification;
extern NSString *const TXWillShowViewControllerNotification;
extern NSString *const TXDidShowViewControllerNotification;

#pragma mark - Filter constants
extern NSString* const kAllFilterItem;
extern NSString* const kAccountFilterItem;
extern NSString* const kContactFilterItem;

#pragma mark - Button names
extern NSString* const kButtonEdit;
extern NSString* const kButtonSave;
extern NSString* const kButtonOk;
extern NSString* const kButtonCancel;
extern NSString* const kButtonSubmit;
extern NSString* const kButtonAddItem;
extern NSString* const kButtonSubmitToSiebel;

#pragma mark - Common functions

extern NSString *GetUUID();

typedef enum
{
    TXItemStatusSynced,
    TXItemStatusError,
    TXItemStatusUniqueConflicted,
    TXItemStatusEdited,
    TXItemStatusNew
} TXItemStatus;

typedef enum
{
    TXOpportunityMode,
    TXLeadMode
} TXOpportunityControllerMode;

typedef enum {
    TXRequiredType,
    TXContentExceededType,
    TXContentInvalid,
    TXBusinessRuleFailure
} TXValidationType;

typedef enum
{
    TXWideProductList,
    TXNarrowAddProductList,
    TXInstrumentProductAddList,
    TXInstrumentProductChangeList
} TXProductListMode;

typedef enum {
    TXCommonListMode,
    TXPickListMode
} TXListControllerMode;

typedef enum {
    TXAddressAlertSelection,
    TXAddressAlertAddition
} TXAdressAlertMode;

typedef enum {
    TXAlertCloseEditForm = 100,
    TXAlertPromoteProspect,
    TXAlertContactProfilingRedirect,
    TXAlertQuoteBusinessRule

} TXAlertViewTags;
