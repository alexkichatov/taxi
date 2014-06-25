//
//  StrConsts__unsafe_unretained NSString* h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14__unsafe_unretained NSString*
//  Copyright (c) 2014 99S__unsafe_unretained NSString*  All rights reserved__unsafe_unretained NSString* 
//

extern const struct SettingsConst {
    
    __unsafe_unretained NSString* TXCRYPTOGROUP;
    __unsafe_unretained NSString* TXCRYPTOSVC_BAKCENDS;
    __unsafe_unretained NSString* TXCRYPTOSVC_GENERIC;
    
    struct {
        __unsafe_unretained NSString* USERNAME;
        __unsafe_unretained NSString* PASSWORD;
        __unsafe_unretained NSString* NOTIFICATIONS_TOKEN;
        __unsafe_unretained NSString* USERTOKEN;
    } CryptoKeys;
    
    
    struct {
        __unsafe_unretained NSString* BASEURL;
        __unsafe_unretained NSString* PORT;
        __unsafe_unretained NSString* MAXHTTPCONNECTIONS;
        __unsafe_unretained NSString* MAXHTTPATTEMPTS;
        __unsafe_unretained NSString* MAXATTACHMENTSIZE;
        __unsafe_unretained NSString* MAX_ALLOWED_ATTACHEMENT_SPACE;
        __unsafe_unretained NSString* APPID;
        __unsafe_unretained NSString* HTTP_API;
    } Property;
    
    struct {
        
        struct {
            
            __unsafe_unretained NSString* USERID;
            
        } Google;
        
        struct {
            
            __unsafe_unretained NSString* USERID;
            
        } Facebook;
        
    } SignInProviders;
    
} SettingsConst;

extern const struct Files {
    
    __unsafe_unretained NSString* SETTINGSFILE;
    __unsafe_unretained NSString* BUNDLE_PATH;
    __unsafe_unretained NSString* CDM_SERVER_FILE_NAME;
    __unsafe_unretained NSString* CDM_LOCAL_FILE_NAME;
    __unsafe_unretained NSString* METADATA_DIR_PATH;

    __unsafe_unretained NSString* PATH_ATTACHMENTDIR;
    __unsafe_unretained NSString* PATH_AMDCTEMPDIR;

    struct {
        __unsafe_unretained NSString* KEY_DOWNLOAD_ATTACHMENT_ID;
        __unsafe_unretained NSString* KEY_UPLOAD_ATTACHMENT_ID;
        __unsafe_unretained NSString* KEY_ATTACHMENTTYPE;
        __unsafe_unretained NSString* KEY_FILENAME;
        __unsafe_unretained NSString* KEY_REQUESTPARAMS;
    } Keys;
    
} Files;

extern const struct FormatterStr {

    __unsafe_unretained NSString* DEFINSTALLDATAFORMAT;
    
} FormatterStr;

/*
 * Synchronization constants
 */
extern const struct SyncConsts {
    
    struct {
        __unsafe_unretained NSString* CODE;
        __unsafe_unretained NSString* BACKENDCRED;
        __unsafe_unretained NSString* BACKENDSRC;
        __unsafe_unretained NSString* CLIENT_ID;
        __unsafe_unretained NSString* SERVER_ID;
        __unsafe_unretained NSString* TYPE;
        __unsafe_unretained NSString* ACTION;
        __unsafe_unretained NSString* ACTION_TIMESTAMP;
        __unsafe_unretained NSString* LAST_SYNC;
        __unsafe_unretained NSString* ATTRIBUTES;
        __unsafe_unretained NSString* PAYLOADS;
        __unsafe_unretained NSString* ERROR;
        __unsafe_unretained NSString* ERRORCODE;
        __unsafe_unretained NSString* ERRORMESSAGE;
        __unsafe_unretained NSString* RESPONSECODE;
        __unsafe_unretained NSString* INFOPART;
        __unsafe_unretained NSString* MULTIPART;
//        __unsafe_unretained NSString* PARTS;
        __unsafe_unretained NSString* MESSAGE;
        __unsafe_unretained NSString* PARTNUMBER;
        __unsafe_unretained NSString* COUNT;

    } Keys;
    
    struct {
        __unsafe_unretained NSString* CODE;
        __unsafe_unretained NSString* VNULL;
        __unsafe_unretained NSString* BACKENDSRC;
    } Value;
    
    __unsafe_unretained NSString* SYNC_TXAPPUID;
    __unsafe_unretained NSString* DEVICENAME;
    __unsafe_unretained NSString* NOTIFICATIONSTOKEN;
    __unsafe_unretained NSString* DEVICEOS;
    __unsafe_unretained NSString* DEVICEOSNAME;
    __unsafe_unretained NSString* GENERIC;
    
} SyncConsts;

extern const struct  OperationType {
    __unsafe_unretained NSString* INSERT;
    __unsafe_unretained NSString* UPDATE;
    __unsafe_unretained NSString* DELETE;
    __unsafe_unretained NSString* SUBSCRIBE;
    __unsafe_unretained NSString* UNSUBSCRIBE;
} OperationType;

/****************** CDM MANAGER ***************************/
extern const struct  CDMConsts {
    
    __unsafe_unretained NSString* USER_TYPES;
    __unsafe_unretained NSString* SERVER_TYPES;
    __unsafe_unretained NSString* LOCAL_TYPES;
    __unsafe_unretained NSString* CDM_REQUEST_CONFIG;
    __unsafe_unretained NSString* CDM_ITEM_TYPE_KEY;
    __unsafe_unretained NSString* CDM_PARENT_FIELDS;
    __unsafe_unretained NSString* CDM_PARENT_TYPE;
    __unsafe_unretained NSString* CDM_FIELD_NAME;
    
} CDMConsts;

/****************** FILE UPLOAD REQUEST ********************/
extern const struct FileUploadRequestConsts {
    
    __unsafe_unretained NSString* MIMETYPE_OCTETSTREAM;
    __unsafe_unretained NSString* MIMETYPE_JSON;
    __unsafe_unretained NSString* CNTENCODING_BINARY;
    __unsafe_unretained NSString* CNTENCODING_8BIT;
    __unsafe_unretained NSString* MULTIPART_DATA_STRINGFMT;
    __unsafe_unretained NSString* MULTIPART_FNAME_STRINGFMT;
    
} FileUploadRequestConsts;

/************ SUBSCRIPTIONS MANAGER *************************/

extern const struct SubscMgrConsts {
    
    __unsafe_unretained NSString* METADATA_PATH;
    __unsafe_unretained NSString* FILE_PATH;
    __unsafe_unretained NSString* KEY_SUBSCRIPTIONS;
    __unsafe_unretained NSString* KEY_SEARCHEXPRESSION;
    __unsafe_unretained NSString* KEY_STARTRECORDNUMBER;
    __unsafe_unretained NSString* KEY_PAGESIZE;
    __unsafe_unretained NSString* KEY_SORTSTRING;
    __unsafe_unretained NSString* KEY_CDMOBJECTTYPE;
    __unsafe_unretained NSString* KEY_NULL;
    __unsafe_unretained NSString* KEY_CDMOBJECTS;
    
} SubscMgrConsts;

/************ LOGGING ***************************************/

extern const struct LoggerConsts {
    
    __unsafe_unretained NSString* C_SYSLOG;
    __unsafe_unretained NSString* C_USAGELOG;
    __unsafe_unretained NSString* C_CHANGELOG;
    __unsafe_unretained NSString* C_SYNCLOG;
    __unsafe_unretained NSString* C_CONFLICTLOG;

} LoggerConsts;

extern const struct FieldsConsts {
    
    __unsafe_unretained NSString* CLIENTID;
    __unsafe_unretained NSString* ID;
    __unsafe_unretained NSString* NAME;
    __unsafe_unretained NSString* SERVERID;
    __unsafe_unretained NSString* OBJID;
    __unsafe_unretained NSString* TYPE;
    __unsafe_unretained NSString* DATA;
    __unsafe_unretained NSString* TIMESTAMP;
    __unsafe_unretained NSString* MESSAGE;
    __unsafe_unretained NSString* LOGTYPE;
    __unsafe_unretained NSString* CODE;
    __unsafe_unretained NSString* MERTIC;
    
} FieldsConsts;

extern const struct GoogleAPIRequestConsts {
    
    __unsafe_unretained NSString* PLACES_NEARBYSEARCH;
    __unsafe_unretained NSString* PLACES_TEXTSEARCH;
    __unsafe_unretained NSString* PLACES_RADARSEARCH;
    __unsafe_unretained NSString* PLACES_AUTOCOMPLETE;
    
    __unsafe_unretained NSString* DIRECTIONS_BYCOORDINATES;
    
    
} GoogleAPIRequestConsts;

extern const struct ChangeLogConsts {
    __unsafe_unretained NSString* OPERATIONTYPE;
    __unsafe_unretained NSString* STATUS;
} ChangeLogConsts;

/************* DAO CONSTANTS ****************/

extern const struct DaoConsts {
    __unsafe_unretained NSString* LAST_ERROR_CODE;
    __unsafe_unretained NSString* LAST_ERROR_MESSAGE;
    __unsafe_unretained NSString* LOGGING_INTO_CHANGELOG_FAILED;
    // id field name
    __unsafe_unretained NSString* NAME_FIELDMAP ;
    __unsafe_unretained NSString* IDENTIFIER;
    __unsafe_unretained NSString* ROWID;
    
    // consts for CRUDs log strings
    __unsafe_unretained NSString* LOG_SELECT ;
    __unsafe_unretained NSString* LOG_INSERT ;
    __unsafe_unretained NSString* LOG_UPDATE ;
    __unsafe_unretained NSString* LOG_DELETE ;
    
    
    // consts for event DataObject's property names
    __unsafe_unretained NSString* PRK_FIELD_NAME ;
    __unsafe_unretained NSString* PRK_OLD_VALUE ;
    __unsafe_unretained NSString* PRK_NEW_VALUE ;
    __unsafe_unretained NSString* PRK_VALUE_OLDMAP ;
    __unsafe_unretained NSString* PRK_VALUE_NEWMAP ;
    __unsafe_unretained NSString* PRK_QUERY_ST ;
    __unsafe_unretained NSString* PRK_REQUERY_ST ;
    __unsafe_unretained NSString* PRK_SEARCHSPEC_ST ;
    __unsafe_unretained NSString* PRK_REQUERYSEARCHSPEC_ST ;
    __unsafe_unretained NSString* PRK_CUSTOMQUERYEXECUTED_ST ;
    __unsafe_unretained NSString* PRK_INSERT_ST ;
    __unsafe_unretained NSString* PRK_UPDATE_ST ;
    __unsafe_unretained NSString* PRK_DELETE_ST ;
    __unsafe_unretained NSString* PRK_LOG_ST ;
    __unsafe_unretained NSString* LAST_INSERTED_ROWID_QUERY;
    __unsafe_unretained NSString* PRK_RESULT_COUNT_QUERY_FMT;
    __unsafe_unretained NSString* PRK_FROM;
    __unsafe_unretained NSString* PRK_RESULT_COUNT_ALIAS;
    __unsafe_unretained NSString* PRK_DELETESEARCHFIELDVALUES;
    __unsafe_unretained NSString* PRK_UPDATESEARCHFIELDVALUES;
    __unsafe_unretained NSString* PRK_UPDATEFIELDVALUES;
    
    // consts for event ListObject's property names
    __unsafe_unretained NSString* PRK_LISTQUERY_ST ;
    __unsafe_unretained NSString* PRK_LISTSEARCHSPEC_ST ;
    __unsafe_unretained NSString* PRK_LISTREQUERY_ST ;
    __unsafe_unretained NSString* PRK_LISTREQUERYSEARCHSPEC_ST ;
    
    // consts for db types, fields
    
    __unsafe_unretained NSString* K_NULLABLE;
    __unsafe_unretained NSString* K_READONLY;
    __unsafe_unretained NSString* K_LENGTH;
    __unsafe_unretained NSString* V_TRUE;
    __unsafe_unretained NSString* V_FALSE;
    __unsafe_unretained NSString* F_ERRORMESSAGE;
    
} DaoConsts;

/************* SAVEPOINT ERR MESSAGE FORMATS ****************/

extern const struct LocalStates {
    
    __unsafe_unretained NSString* T_NAME;
    __unsafe_unretained NSString* LOCALID;
    __unsafe_unretained NSString* FLAG;
    __unsafe_unretained NSString* LOCALSTATE;
    __unsafe_unretained NSString* EXTDATA;
    __unsafe_unretained NSString* TYPE;
    __unsafe_unretained NSString* UPDATED;
    
} LocalStates;

/************* SAVEPOINT ERR MESSAGE FORMATS ****************/

extern const struct SavePointConsts {
    
    __unsafe_unretained NSString* SAVEPOINT_ERR_FMT;
    __unsafe_unretained NSString* DAO_OPERATION_ERR_FMT;
} SavePointConsts;


/********************Metadata related*************************************/
extern const struct DbTypeNames {
    
    __unsafe_unretained NSString* DECIMAL;
    __unsafe_unretained NSString* VARCHAR;
    __unsafe_unretained NSString* DATETIME;
    __unsafe_unretained NSString* TEXT;
    __unsafe_unretained NSString* INTEGER;
    __unsafe_unretained NSString* DATA;
    
} DbTypeNames;

extern const struct CDMFieldDefs {
    
    __unsafe_unretained NSString* NAME;
    __unsafe_unretained NSString* PRECISION;
    __unsafe_unretained NSString* LENGTH;
    __unsafe_unretained NSString* TYPE;
    __unsafe_unretained NSString* NULLABLE;
    __unsafe_unretained NSString* READONLY;
    __unsafe_unretained NSString* STATEMODEL;
    __unsafe_unretained NSString* IDENTIFIER;
    __unsafe_unretained NSString* PARENTTYPE;
    __unsafe_unretained NSString* PARENTFIELDNAME;
    __unsafe_unretained NSString* CONTENTTYPE;
    __unsafe_unretained NSString* PARENT;
} CDMFieldDefs;

/**
 Supported SQLite aggregate function names.
 NOTE - callers must use the constants below, passing strings with equivalent values will not work!
 */
extern const struct SqlAggKeyWords {
    
    __unsafe_unretained NSString* AGG_COUNT;
    __unsafe_unretained NSString* AGG_SUM;
    __unsafe_unretained NSString* AGG_AVG;
    __unsafe_unretained NSString* AGG_MIN;
    __unsafe_unretained NSString* AGG_MAX;
    
} SqlAggKeyWords;

extern const struct SqlGenConsts {
    
    __unsafe_unretained NSString* CL_SELECT;
    __unsafe_unretained NSString* CL_INSERT;
    __unsafe_unretained NSString* CL_UPDATE;
    __unsafe_unretained NSString* CL_DELETE;
    
    __unsafe_unretained NSString* CL_VALUES;
    __unsafe_unretained NSString* CL_SET;
    __unsafe_unretained NSString* CL_OPENPRN;
    __unsafe_unretained NSString* CL_CLOSEPRN;
    
    __unsafe_unretained NSString* CL_FROM;
    __unsafe_unretained NSString* CL_JOIN;
    __unsafe_unretained NSString* CL_ON;
    __unsafe_unretained NSString* CL_WHERE;
    __unsafe_unretained NSString* CL_GROUPBY;
    __unsafe_unretained NSString* CL_ORDERBY;
    __unsafe_unretained NSString* CL_LIMIT;
    __unsafe_unretained NSString* CL_OFFSET;
    
    __unsafe_unretained NSString* OP_EQ;
    __unsafe_unretained NSString* OP_LIKE;
    __unsafe_unretained NSString* OP_OR;
    __unsafe_unretained NSString* OP_AND;
    __unsafe_unretained NSString* SQL_APOSTR;
    __unsafe_unretained NSString* SQL_STAR;
    __unsafe_unretained NSString* SQL_PCT;
    __unsafe_unretained NSString* SQL_QMARK;
    __unsafe_unretained NSString* SQL_UNDER;
    __unsafe_unretained NSString* SQL_DOT;
    __unsafe_unretained NSString* SQL_COMA;
    __unsafe_unretained NSString* SQL_FWDSLASH;
    
} SqlGenConsts;

extern const struct ULLogTypes {
    
    __unsafe_unretained NSString* CLASS_REGISTRATION;
    
} ULLogTypes;

extern const struct Events {
    
    __unsafe_unretained NSString* NAME;
    __unsafe_unretained NSString* LISTENER_CLASS_NAME;
    
} Events;

extern const struct HTTP_API {
    __unsafe_unretained NSString* USER;
    __unsafe_unretained NSString* CALL;
} HTTP_API;

extern const struct KEYS {
    
    struct {
        __unsafe_unretained NSString* CLIENTID;
        
    } Google;
    
} KEYS;


extern const struct API_JSON {
    
    __unsafe_unretained NSString* ID;
    __unsafe_unretained NSString* ERROR;
    __unsafe_unretained NSString* OBJID;
    __unsafe_unretained NSString* VERIFICATIONCODE;
    
    struct {
        __unsafe_unretained NSString* OPER;
        __unsafe_unretained NSString* ATTR;
        __unsafe_unretained NSString* DATA;
        __unsafe_unretained NSString* SOURCE;
        __unsafe_unretained NSString* SUCCESS;
        __unsafe_unretained NSString* MESSAGE;
        __unsafe_unretained NSString* CODE;
        
    } Keys;
    
    struct {
        __unsafe_unretained NSString* USERNAME;
        __unsafe_unretained NSString* PASSWORD;
        __unsafe_unretained NSString* PROVIDERUSERID;
        __unsafe_unretained NSString* PROVIDERID;
        __unsafe_unretained NSString* LOGINWITHPROVIDER;
        __unsafe_unretained NSString* USEREXISTS;
        
    } Authenticate;
    
    struct {
        
        __unsafe_unretained NSString* PHONENUMBER;
        __unsafe_unretained NSString* EMAIL;
        
    } SignUp;
   
    struct {
        
        __unsafe_unretained NSString* DISTANCE;
        __unsafe_unretained NSString* COUNTRY;
        
    } Call;
    
    struct {
        
        __unsafe_unretained NSString* CODE;
        __unsafe_unretained NSString* MESSAGE;
        __unsafe_unretained NSString* SOURCE;
        __unsafe_unretained NSString* SUCCESS;
        
    } ResponseDescriptor;
    
} API_JSON;

extern const struct LEFT_MENU {
    
    struct {
        
        __unsafe_unretained NSString* HOME;
        __unsafe_unretained NSString* PROFILE;
        __unsafe_unretained NSString* SETTINGS;
        __unsafe_unretained NSString* SIGNOUT;
        
    } Names;
    
    struct {
        
        __unsafe_unretained NSString* HOME;
        __unsafe_unretained NSString* PROFILE;
        __unsafe_unretained NSString* SETTINGS;
        __unsafe_unretained NSString* SIGNOUT;
        
        
    } Images;
    
    struct {
        
        __unsafe_unretained NSString* HOME;
        __unsafe_unretained NSString* PROFILE;
        __unsafe_unretained NSString* SETTINGS;
        __unsafe_unretained NSString* SIGNOUT;
        
    } Controllers;
    
} LEFT_MENU;

extern const struct PROVIDERS {
    
    __unsafe_unretained NSString* FACEBOOK;
    __unsafe_unretained NSString* GOOGLE;
    
} PROVIDERS;
