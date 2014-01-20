//
//  TXErrorCodes.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

extern int const TX_ERR_FATAL;

extern int const TX_ERR_FILE_NOT_FOUND;
extern int const TX_ERR_FILE_COPY_FAILED;
extern int const TX_ERR_DIR_NOT_FOUND;
extern int const TX_ERR_DIR_CREATE_FAILED;
extern int const TX_ERR_FILE_ATTR_READ_FAILED;
extern int const TX_ERR_FILE_DELETE_FAILED;
extern int const TX_ERR_FILE_WRITE_FAILED;
extern int const TX_ERR_FILE_READ_FAILED;
extern int const TX_ERR_NO_FREE_SPACE;

extern int const TX_ERR_DB_INIT_FAILED;
extern int const TX_ERR_DB_CONN_OPEN_FAILED;
extern int const TX_ERR_DB_CONN_CLOSE_FAILED;
extern int const TX_ERR_DB_TRANS_CREATE_FAILED;
extern int const TX_ERR_DB_TRANS_COMMIT_FAILED;
extern int const TX_ERR_DB_TRANS_ROLLBACK_FAILED;

extern int const TX_ERR_HTTP_REQUEST_FAILED;
extern int const TX_ERR_NULL_HTTP_REQUEST;

extern int const TX_ERR_ATTCHM_DNLD_FAILED;
extern int const TX_ERR_ATTCHM_SIZE_LIMIT_EXCEED;

/*
 * Synchronization error codes
 */
extern int const TX_ERR_SYNC_OBJ_NOT_FOUND_FATAL;
extern int const TX_ERR_SYNC_OBJ_NOT_FOUND_PENDING_DELETED;
extern int const TX_ERR_SYNC_INSERT_FAILED;
extern int const TX_ERR_SYNC_UNKNOWN_RESP_OBJ_ON_PART_DNLD;
extern int const TX_ERR_SYNC_UNEXPECTED_RESP_CODE_ON_PART_DNLD;

/*
 * Device register, backend validation etc...
 */
extern int const TX_ERR_BACKEND_VALIDATION_FAILED;

/*
 * Subscriptions
 */
extern int const TX_ERR_SUBSC_REQ_FAILED;

/*
 * Event Target
 */
extern int const TX_ERR_EVENT_FIRE_FAILED;