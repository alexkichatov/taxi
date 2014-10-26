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
  
    /***************************************Dao operation fails*************************************************/
    
    __unsafe_unretained NSString* QUERY_FAILED;                       // for insert failed event
    __unsafe_unretained NSString* INSERT_FAILED;                       // for insert failed event
    __unsafe_unretained NSString* UPDATE_FAILED;                       // for update failed event
    __unsafe_unretained NSString* DELETE_FAILED;                       // for delete failed event
    
    /***************************************Settings Events*****************************************************/

    __unsafe_unretained NSString* SETTINGSLOADED;           //fired when settings are loaded and ready
    __unsafe_unretained NSString* SETTINGSSAVED;            //fired after setings are saved to local storage
    __unsafe_unretained NSString* SETTINGCHANGED;           //fired after seting is changed
    
    /***************************************Task Scheduler events *****************************************************/
    __unsafe_unretained NSString* TASKWILLBEGIN;
    __unsafe_unretained NSString* TASKCOMPLETED;
    __unsafe_unretained NSString* TASKCANCELLED;
    __unsafe_unretained NSString* TASKFAILED;
    __unsafe_unretained NSString* TASKSCHEDULERINIT;
    __unsafe_unretained NSString* CONNECTIVITYCHANGED;           //fired when connectivity changes, wireless, cell, none
    
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
    
    __unsafe_unretained NSString* NULLHTTPREQUEST;
    __unsafe_unretained NSString* NULLHTTPRESPONSE;
    __unsafe_unretained NSString* HTTPREQUESTFAILED;
    __unsafe_unretained NSString* HTTPREQUESTCOMPLETED;
    __unsafe_unretained NSString* HTTPCONNOPENFAILED;
    
    /*************************************** GOOGLE EVENTS ****************************************************/
    
    __unsafe_unretained NSString* GOOGLE_PLACES_AUTOCOMP_REQ_COMPLETED;
    __unsafe_unretained NSString* GOOGLE_DIRECTIONS_REQ_COMPLETED;
    
    /*************************************** Event param keys *****************************************************/

    
    struct {
        __unsafe_unretained NSString* ERROR;
        __unsafe_unretained NSString* CONNECTIONTYPE;
        __unsafe_unretained NSString* GOOGLEOBJECT;
        __unsafe_unretained NSString* DESCRIPTOR;
        __unsafe_unretained NSString* REQUEST;
        
    } Params;
    
    __unsafe_unretained NSString* REGISTER_USER_COMPLETED;
    __unsafe_unretained NSString* REGISTER_USER_FAILED;
    __unsafe_unretained NSString* CHECK_USER_COMPLETED;
    __unsafe_unretained NSString* CHECK_PROVIDER_USER_COMPLETED;
    __unsafe_unretained NSString* CHECK_USER_FAILED;
    
    __unsafe_unretained NSString* CALL_CHARGE_REQUEST_COMPLETED;
    __unsafe_unretained NSString* CALL_CHARGE_REQUEST_FAILED;
    
    __unsafe_unretained NSString* LOGIN;
    __unsafe_unretained NSString* AUTHWITHTOKEN;
    __unsafe_unretained NSString* CHECKUSEREXISTS;
    __unsafe_unretained NSString* CHECKVERIFICATIONCODE;
    __unsafe_unretained NSString* CONFIRM;
    __unsafe_unretained NSString* CREATEUSER;
    __unsafe_unretained NSString* CHECKMOBILEPHONEBLOCKED;
    __unsafe_unretained NSString* GETUSER;
    __unsafe_unretained NSString* UPDATEUSER;
    __unsafe_unretained NSString* UPDATEUSERMOBILE;
    __unsafe_unretained NSString* UPDATEUSERVERIFICATION;
    __unsafe_unretained NSString* UPDATEUSERVERIFICATIONCODE;

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

