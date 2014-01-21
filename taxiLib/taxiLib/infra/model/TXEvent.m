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
    .CHANGELOG_LOGGING_FAILED = @"changelogLoggingFailed",
    
    /*************************************** Attachments ************************************************/
    .ATTACHMENT_WARNING_PERCENTAGE = @"attachmentWarningPercentage",
    .ATTACHMENT_SAVE_FAILED        = @"attachmentFileSaveFailed",
    .ATTACHMENT_SIZE_EXCEEDED      = @"attachmentSizeLimitExceed",
    .ATTACHMENT_SAVE_SUCCESS       = @"attachmentFileSaveSucceded",
    
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
    .BACKENDCREDSVALIDATED  = @"backendCredentialsValidated",
    .BACKENDCREDSNOTVALIDATED = @"backendCredentialsNotValidated",
    .BACKENDCREDSVALIDATIONFAILED = @"backendCredentialsValidationFailed",

    /***************************************AMDCom Events*************************************************/
    .AMDCONINITSTARTED     = @"initializationStarted",
    .AMDCONINITDONE        = @"initializationDone",
    .AMDCONINITFAILED      = @"initializationFailed",
    .REGISTERDEVICEOK      = @"registerDeviceOk",
    .REGISTERDEVICEFAILED  = @"registerDeviceFailed",

    /*************************************** Subscription events *****************************************************/
    
    .SUBSCRIBEREQUESTFAILED  = @"subsciptionRequestFailed",
    .SUBSCRIBEREQUESTSUCCEED = @"subscriptionRequestSucceed",
    
    /*************************************** CDM events ***************************************************/
    
    .CDMSAVESUCCEED        = @"cdmSaveSucceed",
    .CDMSAVEFAILED         = @"cdmSaveFailed",
    .CDMDOWNLOADFAILED     = @"cdmDownloadFailed",
    .CDMREADFAILED          = @"cdmReadFailed",
    
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
    
    .HTTPREQUESTFAILED      = @"httpRequestFailed",
    .HTTPREQUESTSUCCEED     = @"httpRequestSucceed",
    .HTTPCONNOPENFAILED     = @"httpConnectionOpenFailed",
    
    /*************************************** Sync events **********************************************************/
    
    .SYNC_BEGIN             = @"synchronizationBegin", // for synchronization start event
    .SYNC_DONE              = @"synchronizationDone", // for synchronization done event
    .SYNC_FAILED            = @"synchronizationFailed", // for synchronization failed event
    .SYNC_ABORTED           = @"syncAborted",
    .SYNC_COMPLETEDPARTFILE = @"syncCompletedPartFile",
    .SYNC_REQUEST_COMPLETED = @"syncRequestCompleted",
    .PARTCOUNT_REQUEST_COMPLETED = @"partCountRequestCompleted",
    .MULTIPART_REQUEST_COMPLETED = @"multipartRequestCompleted",

    /***************************************Event parameter names *****************************************/

    .Params = {
        .ERROR              = @"ERROR",
        .SETTINGNAME        = @"settingName",
        .SETTINGOLDVAL      = @"oldVal",
        .SETTINGNEWVAL      = @"newVal",
        .CONNECTIONTYPE     = @"connectionType",
        .VALIDATIONRESULT   = @"validationResult",
        .LAST_SYNC_DATE     = @"lastSyncDate",
        .MULTIPART          = @"multipart",
        .PARTCOUNT          = @"partCount",
        .PARTNUMBER         = @"partNumber"
    }
};