//
//  TXErrorCodes.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXErrorCodes.h"

int const TX_ERR_FATAL = 9000;

int const TX_ERR_FILE_NOT_FOUND = 9001;
int const TX_ERR_FILE_COPY_FAILED = 9002;
int const TX_ERR_DIR_NOT_FOUND = 9002;
int const TX_ERR_DIR_CREATE_FAILED = 9003;
int const TX_ERR_FILE_ATTR_READ_FAILED = 9004;
int const TX_ERR_FILE_DELETE_FAILED = 9005;
int const TX_ERR_FILE_WRITE_FAILED = 9006;
int const TX_ERR_FILE_READ_FAILED = 9007;

int const TX_ERR_DB_INIT_FAILED = 9101;
int const TX_ERR_DB_CONN_OPEN_FAILED = 9102;
int const TX_ERR_DB_CONN_CLOSE_FAILED = 9103;
int const TX_ERR_DB_TRANS_CREATE_FAILED = 9104;
int const TX_ERR_DB_TRANS_COMMIT_FAILED = 9105;
int const TX_ERR_DB_TRANS_ROLLBACK_FAILED = 9106;

int const TX_ERR_HTTP_REQUEST_FAILED = 9201;
int const TX_ERR_NULL_HTTP_REQUEST = 9202;

int const TX_ERR_NO_FREE_SPACE = 9301;
int const TX_ERR_ATTCHM_DNLD_FAILED = 9302;
int const TX_ERR_ATTCHM_SIZE_LIMIT_EXCEED = 9303;

/*
 * Synchronization logging error codes
 */
int const TX_ERR_SYNC_OBJ_NOT_FOUND_FATAL = 9401;
int const TX_ERR_SYNC_OBJ_NOT_FOUND_PENDING_DELETED = 9402;
int const TX_ERR_SYNC_INSERT_FAILED = 9403;
int const TX_ERR_SYNC_UNKNOWN_RESP_OBJ_ON_PART_DNLD = 9404;
int const TX_ERR_SYNC_UNEXPECTED_RESP_CODE_ON_PART_DNLD = 9405;

/*
 * Device register, backend validation etc...
 */
int const TX_ERR_BACKEND_VALIDATION_FAILED = 9501;

/*
 * Subscriptions
 */
int const TX_ERR_SUBSC_REQ_FAILED = 9601;

/*
 * Event Target
 */
int const TX_ERR_EVENT_FIRE_FAILED = 9701;