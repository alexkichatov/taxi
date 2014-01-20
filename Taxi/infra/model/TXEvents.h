//
//  TXEvents.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const struct TXEvents {
    
    __unsafe_unretained NSString* EVENT_FIRE_CRASHED;
    
/***************************************DAO events *****************************************************/
// Db Event names
    __unsafe_unretained NSString* CREATE;                       // for create  event
    __unsafe_unretained NSString* QUERY;                        // for query  event
    __unsafe_unretained NSString* LOAD;                         // for load-query  event
    __unsafe_unretained NSString* REQUERY ;                      // for requery  event
    __unsafe_unretained NSString* LISTQUERY ;                    // for listquery  event
    __unsafe_unretained NSString* LISTREQUERY ;                  // for listrequery  event
    __unsafe_unretained NSString* CUSTOMQUERYEXECUTED ;          // for customQueryExecuted  event
    __unsafe_unretained NSString* INSERT ;                       // for insert  event
    __unsafe_unretained NSString* UPDATE ;                       // for update  event
    __unsafe_unretained NSString* UPDATEWILLBEGIN ;
    __unsafe_unretained NSString* DELETE ;                       // for delete  event
    __unsafe_unretained NSString* DELETEWILLBEGIN ;
    __unsafe_unretained NSString* VALUECHANGED ;                 // for valueChanged  event
    __unsafe_unretained NSString* SETMULTIPLEVALUES ;            // for setMultipleValues  event
    __unsafe_unretained NSString* SETSEARCHFIELD  ;              // for setSearchField  event
    __unsafe_unretained NSString* SETSORTSPEC;                   // for setSortSpec event
    __unsafe_unretained NSString* SETSEARCHSPEC;                 // for setSearchSpec event
    __unsafe_unretained NSString* NAVIGATION ;                   // for navigation  event
    __unsafe_unretained NSString* ATTACHMENT_WARNING_PERCENTAGE; // when downloaded attachment size + full attachments size > 80 % of max allowed attachments
    __unsafe_unretained NSString* ATTACHMENT_SAVE_FAILED;   // for attachment save failed event
    __unsafe_unretained NSString* ATTACHMENT_SIZE_EXCEEDED;      // for attachment max size limit exceed
    __unsafe_unretained NSString* ATTACHMENT_SAVE_SUCCESS;   // for attachment save failed event

    /***************************************Dao operation fails*************************************************/
    
    __unsafe_unretained NSString* QUERY_FAILED;                       // for insert failed event
    __unsafe_unretained NSString* INSERT_FAILED;                       // for insert failed event
    __unsafe_unretained NSString* UPDATE_FAILED;                       // for update failed event
    __unsafe_unretained NSString* DELETE_FAILED;                       // for delete failed event
    __unsafe_unretained NSString* CHANGELOG_LOGGING_FAILED;                       // changelog logging failed
    
    /***************************************Settings Events*****************************************************/

    __unsafe_unretained NSString* SETTINGSLOADED;           //fired when settings are loaded and ready
    __unsafe_unretained NSString* SETTINGSSAVED;            //fired after setings are saved to local storage
    __unsafe_unretained NSString* SETTINGCHANGED;           //fired after seting is changed
    __unsafe_unretained NSString* BACKENDCREDSVALIDATED;    //Fired after server returns backendcreds success validaiton.
    __unsafe_unretained NSString* BACKENDCREDSNOTVALIDATED;    //Fired after server returns backendcreds unsuccessfull validation.
    __unsafe_unretained NSString* BACKENDCREDSVALIDATIONFAILED;    //Fired if server response fails when validating backend credentials.
    
    /***************************************Task Scheduler events *****************************************************/
    __unsafe_unretained NSString* TASKWILLBEGIN;
    __unsafe_unretained NSString* TASKCOMPLETED;
    __unsafe_unretained NSString* TASKCANCELLED;
    __unsafe_unretained NSString* TASKFAILED;
    __unsafe_unretained NSString* TASKSCHEDULERINIT;
    __unsafe_unretained NSString* CONNECTIVITYCHANGED;           //fired when connectivity changes, wireless, cell, none


    /***************************************AMDCom Events*****************************************************/

    __unsafe_unretained NSString* AMDCONINITSTARTED;
    __unsafe_unretained NSString* AMDCONINITDONE;
    __unsafe_unretained NSString* AMDCONINITFAILED;
    __unsafe_unretained NSString* REGISTERDEVICEOK;
    __unsafe_unretained NSString* REGISTERDEVICEFAILED;


    /*************************************** CDM events *****************************************************/
    
    __unsafe_unretained NSString* CDMSAVESUCCEED;
    __unsafe_unretained NSString* CDMSAVEFAILED;
    __unsafe_unretained NSString* CDMDOWNLOADFAILED;
    __unsafe_unretained NSString* CDMREADFAILED;
   
    /*************************************** Subscription events *****************************************************/
    
    __unsafe_unretained NSString* SUBSCRIBEREQUESTFAILED;
    __unsafe_unretained NSString* SUBSCRIBEREQUESTSUCCEED;
    
    /*************************************** FILE MANAGER EVENTS *******************************************/
    
    __unsafe_unretained NSString* FILESAVEFAILED;
    __unsafe_unretained NSString* GETFILESIZEFAILED;
    __unsafe_unretained NSString* FILEREADFAILED;
    __unsafe_unretained NSString* FILEREMOVEFAILED;
    __unsafe_unretained NSString* DIR_CREATE_FAILED;
    __unsafe_unretained NSString* COPY_ITEM_FAILED;
    __unsafe_unretained NSString* FILE_NOT_FOUND;
    __unsafe_unretained NSString* DIR_DOES_NOT_EXIST;
    __unsafe_unretained NSString* NO_FREE_SPACE;
    __unsafe_unretained NSString* DIR_CONTENT_READ_FAILED;
    __unsafe_unretained NSString* PACKAGE_INSTALLED_SUCCESSFULLY;
    
    /*************************************** DB HELPER EVENTS **********************************************/
    
    __unsafe_unretained NSString* NULLDATABASE;
    __unsafe_unretained NSString* DATABASE_INIT_FAILED;
    __unsafe_unretained NSString* CONNECTION_OPEN_FAILED;
    __unsafe_unretained NSString* CONNECTION_CLOSE_FAILED;
    __unsafe_unretained NSString* TRANSACTION_CREATE_FAILED;
    __unsafe_unretained NSString* TRANSACTION_COMMIT_FAILED;
    __unsafe_unretained NSString* TRANSACTION_ROLLBACK_FAILED;
    
    /*************************************** HTTP EVENTS ****************************************************/
    
    __unsafe_unretained NSString* HTTPREQUESTFAILED;
    __unsafe_unretained NSString* HTTPREQUESTSUCCEED;
    __unsafe_unretained NSString* HTTPCONNOPENFAILED;
    
    /*************************************** Event param keys *****************************************************/

    /*************************************** Sync events **********************************************************/
    
    __unsafe_unretained NSString* SYNC_ABORTED;
    __unsafe_unretained NSString* SYNC_COMPLETEDPARTFILE;
    __unsafe_unretained NSString* SYNC_BEGIN;                    // for synchronization start event
    __unsafe_unretained NSString* SYNC_DONE;                     // for synchronization done event
    __unsafe_unretained NSString* SYNC_FAILED;                   // for synchronization failed event
    __unsafe_unretained NSString* SYNC_REQUEST_COMPLETED;
    __unsafe_unretained NSString* PARTCOUNT_REQUEST_COMPLETED;
    __unsafe_unretained NSString* MULTIPART_REQUEST_COMPLETED;
    
    /***************************************************************************************************************/
    
    struct {
        __unsafe_unretained NSString* ERROR;
        __unsafe_unretained NSString* SETTINGNAME;
        __unsafe_unretained NSString* SETTINGOLDVAL;
        __unsafe_unretained NSString* SETTINGNEWVAL;
        __unsafe_unretained NSString* CONNECTIONTYPE;
        __unsafe_unretained NSString* VALIDATIONRESULT;
        __unsafe_unretained NSString* LAST_SYNC_DATE;
        __unsafe_unretained NSString* MULTIPART;
        __unsafe_unretained NSString* PARTCOUNT;
        __unsafe_unretained NSString* PARTNUMBER;
    } Params;

} TXEvents;

// Db Event Codes
typedef enum {
    EVENT_CODE_CREATE ,               // for create  event
    EVENT_CODE_QUERY ,                // for query  event
    EVENT_CODE_LOAD ,                 // for load-query  event
    EVENT_CODE_REQUERY ,              // for requery  event
    EVENT_CODE_LISTQUERY ,            // for listquery  event
    EVENT_CODE_LISTREQUERY ,          // for listrequery  event
    EVENT_CODE_CUSTOMQUERYEXECUTED ,  // for customQueryExecuted  event
    EVENT_CODE_INSERT ,               // for insert  event
    EVENT_CODE_UPDATE ,               // for update  event
    EVENT_CODE_DELETE ,               // for delete  event
    EVENT_CODE_VALUECHANGED ,         // for valueChanged  event
    EVENT_CODE_SETMULTIPLEVALUES ,    // for setMultipleValues  event
    EVENT_CODE_SETSEARCHFIELD ,       // for setSearchField  event
    EVENT_CODE_SETSEARCHSPEC ,        // for setSearchSpec  event
    EVENT_CODE_NAVIGATION ,           // for navigation  event
    EVENT_CODE_NAVIGATION_FIRST ,     // for navigation  event
    EVENT_CODE_NAVIGATION_NEXT ,      // for navigation  event
    EVENT_CODE_NAVIGATION_PREV ,      // for navigation  event
    EVENT_CODE_NAVIGATION_LAST ,      // for navigation  event
    
    // setJoin/Sort/Groupby Event Codes
    EVENT_CODE_SETSORTDEFS ,          // for setSortDefs  event
    EVENT_CODE_SETGROUPBYDEFS ,       // for setGroupByDefs  event
    EVENT_CODE_SETJOINDEFS ,          // for setJoinDefs  event
    
    EVENT_CODE_SYNC_BEGIN,            // for synchronization begin
    EVENT_CODE_SYNC_DONE,            // for synchronization done
    EVENT_CODE_SYNC_FAILED,            // for synchronization failed
    
    EVENT_CODE_CONNECTIVITYCHANGED
    
} DbEventCodes;
// Db Navigation Event Codes
typedef enum {
    EVENTCODE_FIRST ,
    EVENTCODE_NEXT ,
    EVENTCODE_PREV ,
    EVENTCODE_LAST
} DbNavigationEventCodes;

