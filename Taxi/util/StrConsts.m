//
//  StrConsts.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 Taxi.All rights reserved.
//
#import "StrConsts.h"

/********************* SETTINGS ***************************/
const struct SettingsConst  SettingsConst = {
    .TXCRYPTOGROUP          = @"AMDCryptoGroup",//this should have appid and company in there for implementation
    .TXCRYPTOSVC_BAKCENDS   = @"AMDCCrypto_Backends",
    .TXCRYPTOSVC_GENERIC    = @"AMDCCrypto_Generic",

    .CryptoKeys = {
        .USERNAME      = @"txUserName",
        .PASSWORD       = @"txUserPwd",
        .NOTIFICATIONS_TOKEN    = @"notificationsToken",
        .USERTOKEN  = @"userToken"
    },

    .Property = {
        .BASEURL                        = @"baseUrl",
        .PORT                           = @"urlPort",
        .MAXHTTPCONNECTIONS             = @"maxHTTPConnections",
        .MAXHTTPATTEMPTS                = @"maxHTTPAttempts",
        .MAXATTACHMENTSIZE              = @"maxAttachmentSize", //in Mbs
        .MAX_ALLOWED_ATTACHEMENT_SPACE  = @"maxallowedattachmentspace",
        .APPID                          = @"applicationID",
        .HTTP_API                       = @"httpAPI"
        
    },
    
    .SignInProviders = {
     
        .Google = {
            .USERID = @"googleUserID"
        },
        
        .Facebook = {
            .USERID = @"facebookUserID"
        }
        
    }
    
};

const struct Files Files = {
    
    .SETTINGSFILE           = @"amdcstgs.plist",
    .BUNDLE_PATH            = @"taxi.bundle",
    .CDM_SERVER_FILE_NAME   = @"server.cdm",
    .CDM_LOCAL_FILE_NAME    = @"local.cdm",
    .METADATA_DIR_PATH      = @"metadata",
    .PATH_ATTACHMENTDIR     = @"attachments",
    .PATH_AMDCTEMPDIR       = @"temp",
    
    .Keys = {
        .KEY_UPLOAD_ATTACHMENT_ID       = @"clientId",
        .KEY_DOWNLOAD_ATTACHMENT_ID     = @"parentId",
        .KEY_ATTACHMENTTYPE             = @"type",
        .KEY_FILENAME                   = @"fileName",
        .KEY_REQUESTPARAMS              = @"requestParams"
    }
};

const struct FormatterStr FormatterStr = {
    
    .DEFINSTALLDATAFORMAT   = @"yyyy-MM-dd HH:mm:ss"
    
};



/*
 * Synchronization constants
 */
const struct SyncConsts SyncConsts = {

    .Keys = {

        .CODE               = @"code",
        .BACKENDCRED        = @"backendCredentials",
        .BACKENDSRC         = @"backendSource",
        .CLIENT_ID          = @"clientId",
        .SERVER_ID          = @"serverId",
        .TYPE               = @"type",
        .ACTION             = @"action",
        .ACTION_TIMESTAMP   = @"actionTimestamp",
        .LAST_SYNC          = @"lastSync",
        .ATTRIBUTES         = @"attributes",
        .PAYLOADS           = @"payloads",
        .ERROR              = @"error",
        .ERRORCODE          = @"errorCode",
        .ERRORMESSAGE       = @"errorMessage",
        .RESPONSECODE       = @"responseCode",
        .INFOPART           = @"info",
        .MULTIPART          = @"multipart",
//        .PARTS              = @"parts",
        .MESSAGE            = @"message",
        .PARTNUMBER         = @"partNumber",
        .COUNT              = @"count"
        
    },
    
    .Value = {
        .VNULL              = @"null"
    },
    
    .SYNC_TXAPPUID         = @"TXAppUID",
    .DEVICENAME             = @"deviceName",
    .NOTIFICATIONSTOKEN     = @"notificationsToken",
    .DEVICEOS               = @"deviceOS",
    .DEVICEOSNAME           = @"iOS",
    .GENERIC                = @"Generic"
};

const struct OperationType OperationType = {
    .INSERT         = @"insert",
    .UPDATE         = @"update",
    .DELETE         = @"delete",
    .SUBSCRIBE      = @"subscribe",
    .UNSUBSCRIBE    = @"unsubscribe",
};

/****************** CDM MANAGER ***************************/

const struct CDMConsts CDMConsts = {

    .USER_TYPES           = @"userTypes",
    .SERVER_TYPES         = @"serverTypes",
    .LOCAL_TYPES          = @"localTypes",
    .CDM_REQUEST_CONFIG   = @"cdmdownload",
    .CDM_ITEM_TYPE_KEY    = @"type",
    .CDM_PARENT_FIELDS    = @"parentFields",
    .CDM_PARENT_TYPE      = @"parentType",
    .CDM_FIELD_NAME       = @"name"
};

/****************** FILE UPLOAD REQUEST ********************/

const struct FileUploadRequestConsts FileUploadRequestConsts  = {

    .MIMETYPE_OCTETSTREAM = @"application/octet-stream",
    .MIMETYPE_JSON        = @"application/json; charset=UTF-8",
    .CNTENCODING_BINARY  = @"binary",
    .CNTENCODING_8BIT     = @"8bit",
    .MULTIPART_DATA_STRINGFMT = @"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"; \r\nContent-Type: %@\r\nContent-Transfer-Encoding: %@\r\n\r\n",
    .MULTIPART_FNAME_STRINGFMT =
@"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: %@\r\n\r\n"

};

/************ SUBSCRIPTIONS MANAGER *************************/

const struct SubscMgrConsts SubscMgrConsts  = {
  
    .METADATA_PATH    = @"metadata",
    .FILE_PATH    = @"metadata/subscriptions.plist",
    .KEY_SUBSCRIPTIONS = @"subscriptions",
    .KEY_SEARCHEXPRESSION    = @"searchExpression",
    .KEY_STARTRECORDNUMBER    = @"startRecordNumber",
    .KEY_PAGESIZE    = @"pageSize",
    .KEY_SORTSTRING    = @"sortString",
    .KEY_CDMOBJECTTYPE    = @"cdmObjectType",
    .KEY_NULL    = @"null",
    .KEY_CDMOBJECTS = @"cdmObjects"
    
};

/************ LOGGING ***************************************/

const struct LoggerConsts LoggerConsts = {
    
    .C_SYSLOG = @"systemlog",
    .C_USAGELOG = @"usagelog",
    .C_CHANGELOG = @"changelog",
    .C_SYNCLOG = @"synclog",
    .C_CONFLICTLOG = @"conflictlog"

};

const struct GoogleAPIRequestConsts GoogleAPIRequestConsts = {
    
    .PLACES_NEARBYSEARCH = @"PlacesNearbySearch",
    .PLACES_TEXTSEARCH = @"PlacesTextSearch",
    .PLACES_RADARSEARCH = @"PlacesRadarSearch",
    .PLACES_AUTOCOMPLETE = @"PlacesAutocomplete",
    .DIRECTIONS_BYCOORDINATES = @"DirectionsByCoordinates"
    
};

const struct ChangeLogConsts ChangeLogConsts = {

    .OPERATIONTYPE = @"operationType",
    .STATUS = @"status"
    
};

/************* DAO CONSTANTS ****************/

const struct DaoConsts DaoConsts = {
    .LAST_ERROR_CODE = @"lastErrCode",
    .LAST_ERROR_MESSAGE = @"lastErrMessage",
    .LOGGING_INTO_CHANGELOG_FAILED = @"loggingIntoChangeLogFailed",
    // name for id
    .NAME_FIELDMAP = @"fields",
    .IDENTIFIER    = @"identifier",
    .ROWID    = @"rowId",
    
    // consts for CRUDs log strings
    .LOG_SELECT   = @"SELECT: ",
    .LOG_INSERT   = @"INSERT INTO ",
    .LOG_UPDATE   = @"UPDATE ",
    .LOG_DELETE   = @"DELETE FROM ",
    
    // consts for event object's property names
    .PRK_FIELD_NAME             = @"name", // fieldName for setFieldValue event
    .PRK_OLD_VALUE              = @"originalValue",
    .PRK_NEW_VALUE              = @"value",
    .PRK_VALUE_OLDMAP           = @"oldValueMAP",    // for setValues event
    .PRK_VALUE_NEWMAP           = @"newValueMAP",
    .PRK_QUERY_ST               = @"queryStr",         // for query  event
    .PRK_SEARCHSPEC_ST          = @"searchSpec",  // ___
    .PRK_REQUERY_ST             = @"requeryqueryStr",         // for requery  event
    .PRK_REQUERYSEARCHSPEC_ST   = @"requerysearchSpec",  // ___
    .PRK_CUSTOMQUERYEXECUTED_ST = @"customQueryExecuted", // for customQueryExecuted event
    .PRK_INSERT_ST              = @"insertStr",         // for insert  event
    .PRK_UPDATE_ST              = @"updateStr",         // for update  event
    .PRK_DELETE_ST              = @"deleteStr",         // for delete  event
    .PRK_LOG_ST                 = @"logStr",         // for logStr
    .PRK_DELETESEARCHFIELDVALUES= @"DeleteSearchFiledValues",
    .PRK_UPDATESEARCHFIELDVALUES= @"UpdateSearchFiledValues",
    .PRK_UPDATEFIELDVALUES      = @"UpdateFiledValues",
    
    .LAST_INSERTED_ROWID_QUERY = @"select last_insert_rowid() as rowid ",
    .PRK_RESULT_COUNT_QUERY_FMT = @"SELECT COUNT(1) as resultCount FROM (%@)",
    .PRK_FROM = @"FROM",
    .PRK_RESULT_COUNT_ALIAS = @"resultCount",
    // consts for event ListObject's property names
    .PRK_LISTQUERY_ST             = @"queryStr",    // for listquery  event
    .PRK_LISTSEARCHSPEC_ST        = @"searchSpec",  // ___
    .PRK_LISTREQUERY_ST           = @"requeryStr",         // for requery  event
    .PRK_LISTREQUERYSEARCHSPEC_ST = @"requerysearchSpec",  // ___
    
    .K_NULLABLE = @"nullable",
    .K_READONLY = @"readOnly",
    .K_LENGTH = @"length",
    .V_TRUE = @"true",
    .V_FALSE = @"false",
    .F_ERRORMESSAGE = @"errorMessage",
    
};

/************* SAVEPOINT ERR MESSAGE FORMATS ****************/

const struct LocalStates LocalStates = {
    
    .T_NAME  = @"localstates",
    .LOCALID = @"amdc_ls_localid",
    .FLAG    = @"amdc_ls_flag",
    .LOCALSTATE = @"amdc_ls_localstate",
    .EXTDATA = @"amdc_ls_extdata",
    .TYPE    = @"amdc_ls_type",
    .UPDATED = @"amdc_ls_updated",
    
};

/************* SAVEPOINT ERR MESSAGE FORMATS ****************/

const struct SavePointConsts SavePointConsts = {

    .SAVEPOINT_ERR_FMT = @"Failed to %@ savepoint with name: %@, error description: %@",
    .DAO_OPERATION_ERR_FMT = @"Failed to %@ object, last error code :%d, error message: %@"
};

/********************Metadata related*************************************/
const struct DbTypeNames DbTypeNames = {
    
    .DECIMAL  = @"decimal",
    .VARCHAR  = @"varchar",
    .DATETIME = @"dateTime",
    .TEXT     = @"text",
    .INTEGER  = @"integer",
    .DATA     = @"data"
};

const struct CDMFieldDefs CDMFieldDefs = {
    
    .NAME = @"name",
    .PRECISION = @"precision",
    .LENGTH = @"length",
    .TYPE = @"type",
    .NULLABLE = @"nullable",
    .READONLY = @"readOnly",
    .STATEMODEL = @"statemodel",
    .IDENTIFIER = @"identifier",
    .PARENTTYPE = @"parentType",
    .PARENTFIELDNAME = @"parentFieldName",
    .CONTENTTYPE = @"contentType",
    .PARENT = @"parent"
};

const struct SqlAggKeyWords SqlAggKeyWords = {
    
    .AGG_COUNT = @"count",
    .AGG_SUM   = @"sum",
    .AGG_AVG   = @"avg",
    .AGG_MIN   = @"min",
    .AGG_MAX   = @"max"
    
};

const struct SqlGenConsts SqlGenConsts = {
    
    .CL_SELECT   = @"SELECT ",
    .CL_INSERT   = @"INSERT INTO ",
    .CL_UPDATE   = @"UPDATE ",
    .CL_DELETE   = @"DELETE FROM ",
    
    .CL_VALUES   = @" VALUES (",
    .CL_SET      = @" SET ",
    
    .CL_OPENPRN = @"(",
    .CL_CLOSEPRN = @")",
    
    .CL_FROM     = @" FROM ",
    .CL_JOIN     = @" JOIN ",
    .CL_ON       = @" ON ",
    .CL_WHERE    = @" WHERE ",
    .CL_GROUPBY  = @" GROUP BY ",
    .CL_ORDERBY  = @" ORDER BY ",
    .CL_LIMIT    = @" LIMIT ",
    .CL_OFFSET   = @" OFFSET ",
    
    .OP_EQ       = @" = ",
    .OP_LIKE     = @" LIKE ",
    .OP_OR       = @" OR ",
    .OP_AND      = @" AND ",
    .SQL_APOSTR  = @"\'",
    .SQL_STAR    = @"*",
    .SQL_PCT     = @"%",
    .SQL_QMARK   = @"?",
    .SQL_UNDER   = @"_",
    .SQL_DOT    = @".",
    .SQL_COMA    = @",",
    .SQL_FWDSLASH = @"\\"
    
};

const struct ULLogTypes ULLogTypes = {
    
    .CLASS_REGISTRATION = @"Class Registration"
    
};

const struct Events Events = {
    
    .NAME = @"eventName",
    .LISTENER_CLASS_NAME = @"listenerClassName"
    
};

const struct HTTP_API HTTP_API = {
    .USER = @"user",
    .CALL = @"call"
};

const struct KEYS KEYS = {
    
    .Google = {
        
        .CLIENTID = @"177846177917-1r8cvuslmtv3lfj2k1np42k0sk402n56.apps.googleusercontent.com",
        
    }
    
};

const struct API_JSON API_JSON = {
    
    .ID = @"id",
    .ERROR = @"error",
    .OBJID = @"objID",
    .VERIFICATIONCODE = @"verificationCode",
    
    .Keys = {
        .OPER     = @"operation",
        .ATTR     = @"attr",
        .DATA     = @"data",
        .SOURCE   = @"source",
        .SUCCESS  = @"success",
        .MESSAGE  = @"message",
        .CODE     = @"code"
    },
    
    .Authenticate = {
        .USERNAME = @"username",
        .PASSWORD = @"password",
        .PROVIDERUSERID = @"providerUserID",
        .PROVIDERID = @"providerID",
        .LOGINWITHPROVIDER = @"loginWithProvider",
        .USEREXISTS = @"exists"
    },
    
    .SignUp = {
        
        .PHONENUMBER = @"mobile",
        .EMAIL = @"email"
    },
    
    .Call = {
        
        .DISTANCE = @"distance",
        .COUNTRY = @"country"
        
    },
    
    .ResponseDescriptor = {
        
        .CODE = @"code",
        .MESSAGE = @"message",
        .SOURCE = @"source",
        .SUCCESS = @"success"
        
    } 
    
};

const struct LEFT_MENU LEFT_MENU = {
    
    .Names = {
        
        .HOME = @"Home",
        .PROFILE = @"Profile",
        .SETTINGS = @"Settings",
        .SIGNOUT = @"Sign out"
    },
    
    .Images = {
        
        .HOME = @"button-home",
        .PROFILE = @"button-profile",
        .SETTINGS = @"button-settings",
        .SIGNOUT = @"button-signout"
        
    },
    
    .Controllers = {
        
        .HOME = @"TXMainVC",
        .PROFILE = @"TXMainVC",
        .SETTINGS = @"TXMainVC",
        .SIGNOUT = @"TXMainVC"
        
    }
    
};

const struct PROVIDERS PROVIDERS = {
    
    .FACEBOOK = @"http://www.facebook.com",
    .GOOGLE   = @"http://www.google.com"
    
};

