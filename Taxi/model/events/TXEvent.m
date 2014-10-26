//
//  TXEvents.m
//  AMDCom
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXEvents.h"

const struct TXEvents TXEvents = {
    
    .EVENT_FIRE_CRASHED   = @"fireEventFailed",
    
    .CREATE              = @"create",         // for create  event
    .QUERY               = @"query",         // for query  event
    .LOAD                = @"load",         // for load-query  event
    .REQUERY             = @"requery",         // for requery  event
    .LISTQUERY           = @"listquery",    // for listquery  event
    .LISTREQUERY         = @"listrequery", // for listrequery  event
    .CUSTOMQUERYEXECUTED = @"customQueryExecuted", // for customQueryExecuted  event
    .INSERT              = @"insert",         // for insert  event
    .UPDATE              = @"update",         // for update  event
    .UPDATEWILLBEGIN     = @"updateWillBegin",
    .DELETE              = @"delete",         // for delete  event
    .DELETEWILLBEGIN     = @"deleteWillBegin",
    .VALUECHANGED        = @"valueChanged", // for valueChanged  event
    .SETMULTIPLEVALUES   = @"setMultipleValues", // for setMultipleValues  event
    .SETSEARCHFIELD      = @"setSearchField", // for setSearchField  event
    .SETSORTSPEC         = @"setSortSpec",    // for setSortSpec event
    .SETSEARCHSPEC       = @"setSearchSpec",  // for setSearchSpec event
    .NAVIGATION          = @"navigation",           // for navigation  event
    
    /***************************************Dao operation fails*************************************************/
    
    .QUERY_FAILED       = @"queryFailed",                       // for insert failed event
    .INSERT_FAILED       = @"insertFailed",                       // for insert failed event
    .UPDATE_FAILED       = @"updateFailed",                // for update failed event
    .DELETE_FAILED       = @"deleteFailed",                       // for delete failed event
    
    /***************************************Task Scheduler events ***************************************/
    .TASKWILLBEGIN        = @"taskWillBegin",
    .TASKCOMPLETED        = @"taskCompleted",
    .TASKCANCELLED        = @"taskCancelled",
    .TASKFAILED           = @"taskFailed",
    .TASKSCHEDULERINIT    = @"schedulerInit",
    .CONNECTIVITYCHANGED  = @"connectivityShanged",

    /***************************************Settings events **********************************************/
    .SETTINGSLOADED         = @"SettingsReady",
    .SETTINGSSAVED          = @"SettingsSaved",
    .SETTINGCHANGED         = @"SettingChanged",
    
    /*************************************** FILE MANAGER EVENTS *******************************************/
    
    .FILESAVEFAILED        = @"fileSaveFailed",
    .GETFILESIZEFAILED     = @"getFileSizeFailed",
    .FILEREADFAILED        = @"faileReadFailed",
    .FILEREMOVEFAILED      = @"fileRemoveFailed",
    .DIR_CREATE_FAILED     = @"directoryCreateFailed",
    .COPY_ITEM_FAILED      = @"copyItemFailed",
    .FILE_NOT_FOUND        = @"fileNotFound",
    .DIR_DOES_NOT_EXIST    = @"dirDoesNotExist",
    .NO_FREE_SPACE         = @"noFreeSpace",
    .DIR_CONTENT_READ_FAILED = @"dirContentReadFailed",
    .PACKAGE_INSTALLED_SUCCESSFULLY = @"packageInstalledSuccessfully",
    
    /*************************************** DB HELPER EVENTS **********************************************/
    
    .NULLDATABASE = @"dbInitializationFailed",
    .DATABASE_INIT_FAILED = @"databaseInitFailed",
    .CONNECTION_OPEN_FAILED = @"connectionOpenFailed",
    .CONNECTION_CLOSE_FAILED = @"connectionCloseFailed",
    .TRANSACTION_CREATE_FAILED = @"transactionCreateFailed",
    .TRANSACTION_COMMIT_FAILED = @"transactionCommitFailed",
    .TRANSACTION_ROLLBACK_FAILED = @"transactionRollbackFailed",
    
    /*************************************** HTTP EVENTS ****************************************************/
    
    .NULLHTTPREQUEST        = @"nullHttpRequest",
    .NULLHTTPRESPONSE       = @"nullHttpResponse",
    .HTTPREQUESTFAILED      = @"httpRequestFailed",
    .HTTPREQUESTCOMPLETED     = @"httpRequestCompleted",
    .HTTPCONNOPENFAILED     = @"httpConnectionOpenFailed",
  
    /*************************************** HTTP EVENTS ****************************************************/
    
    .GOOGLE_PLACES_AUTOCOMP_REQ_COMPLETED = @"onGooglePlacesAutocompleteRequestCompleted",
    .GOOGLE_DIRECTIONS_REQ_COMPLETED      = @"onGoogleDirectionsRequestCompleted",
    
    .Params = {
        .ERROR              = @"ERROR",
        .CONNECTIONTYPE     = @"connectionType",
        .GOOGLEOBJECT       = @"googleObject",
        .DESCRIPTOR         = @"descriptor",
        .REQUEST            = @"request"
    },
    
    .REGISTER_USER_COMPLETED = @"registerUserCompleted",
    .REGISTER_USER_FAILED = @"registerUserFailed",
    .CHECK_USER_COMPLETED = @"checkUserCompleted",
    .CHECK_PROVIDER_USER_COMPLETED = @"checkUserWithProviderCompleted",
    .CHECK_USER_FAILED    = @"checkUserFailed",
    .CALL_CHARGE_REQUEST_COMPLETED = @"callChargeRequestCompleted",
    .CALL_CHARGE_REQUEST_FAILED = @"callChargeRequestFailed",
    
    .LOGIN = @"login",
    .AUTHWITHTOKEN = @"authWithToken",
    .CHECKUSEREXISTS = @"checkUserExists",
    .CHECKVERIFICATIONCODE = @"checkVerificationCode",
    .CONFIRM = @"confirm",
    .CREATEUSER = @"createUser",
    .CHECKMOBILEPHONEBLOCKED = @"checkMobilePhoneBlocked",
    .GETUSER = @"getUser",
    .UPDATEUSER = @"updateUser",
    .UPDATEUSERMOBILE = @"updateUserMobile",
    .UPDATEUSERVERIFICATION = @"updateUserVerification",
    .UPDATEUSERVERIFICATIONCODE = @"updateUserVerificationCode"
    
};