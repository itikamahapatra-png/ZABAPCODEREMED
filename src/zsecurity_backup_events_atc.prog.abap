*** Form download
***------------------------------------------------------------------------------------------------------------------------**
***------------------------------------------------------------------------------------------------------------------------**
*  FORM download.
*    IF  p_main_r EQ 'X'.
*      IF p_roles NE 'X' AND p_roles1 NE 'X' AND p_roles2 NE 'X' AND p_t1 NE 'X' AND p_t2 NE 'X' AND p_tcodes NE 'X' .
*        PERFORM Fetch_Data_1251.
*        PERFORM Fetch_Data_Agrs.
*        PERFORM Fetch_Data_Define.
*        PERFORM z_agr_1250.
*        PERFORM z_agr_users.
*        PERFORM Fetch_Data_Tcodes.
*      ENDIF.
*      IF  p_roles EQ 'X' .
*        PERFORM Fetch_Data_1251.
*      ENDIF.
*      IF  p_roles1 EQ 'X'.
*        PERFORM Fetch_Data_Agrs.
*      ENDIF.
*      IF  p_roles2 EQ 'X'.
*        PERFORM Fetch_Data_Define.
*      ENDIF.
*      IF  p_t1 EQ 'X'.
*        PERFORM z_agr_1250.
*      ENDIF.
*      IF   p_t2 EQ 'X'.
*        PERFORM z_agr_users.
*      ENDIF.
*      IF  p_tcodes EQ 'X'.
*        PERFORM Fetch_Data_Tcodes.
*      ENDIF.
*    ENDIF.
**------------------------------------------------------------------------*
**------------------------------------------------------------------------*
*    IF p_tusage EQ 'X'.
*      PERFORM Fetch_T_Usage.
*      PERFORM excel_transaction_usage.
*    ENDIF.
*    IF p_Merge EQ 'X'.
*      PERFORM Fetch_T_Usage.
*      PERFORM Fetch_Merge.
*      PERFORM Fetch_ALV_Merge.
*    ENDIF.
***------------------------------------------------------------------------*
***------------------------------------------------------------------------*
*    IF  p_tables EQ 'X'.
*      IF p_t3 NE 'X' AND p_t4 NE 'X' AND p_t5 NE 'X' AND p_t6 NE 'X'.
*        PERFORM z_agr_usobt.
*        PERFORM z_usobx.
*        PERFORM z_usobx_c.
*        PERFORM z_usobt_c.
*      ENDIF.
*      IF p_t3 EQ 'X'.
*        PERFORM z_agr_usobt.
*      ENDIF.
*      IF p_t4 EQ 'X'.
*        PERFORM z_usobx.
*      ENDIF.
*      IF p_t5 EQ 'X'.
*        PERFORM z_usobx_c.
*      ENDIF.
*      IF p_t6 EQ 'X'.
*        PERFORM z_usobt_c.
*      ENDIF.
*    ENDIF.
*  ENDFORM.
**&---------------------------------------------------------------------*
**& Form Fetch_Data_1251
**&---------------------------------------------------------------------*
*  FORM Fetch_Data_1251 .
**&---------------------------------------------------------------------*
**& Fetching data from table
**&---------------------------------------------------------------------*
*    SELECT mandt
*           agr_name
*           counter
*           object
*           auth
*           variant
*           field
*           low
*           high
*           modified
*           deleted
*           copied
*           neu
*           node FROM agr_1251
*                INTO TABLE lt_data_1251
*                WHERE agr_name IN s_r_name.
**&------------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&------------------------------------------------------------------------*
**  lv_path = p_f_path.
**
**  lv_filename = lv_path.
**
**
**  IF lv_filename NS '(Roles_Auth-AGR_1251)'.
**
**    CONCATENATE 'C:\Users\PriyankaMangeshBhoya\Downloads\' lv_filename '(Roles_Auth-AGR_1251)' '.xls' INTO lv_filename.
**  ENDIF.
**
**  CALL METHOD cl_gui_frontend_services=>file_exist
**    EXPORTING
**      file                 = lv_filename
**    RECEIVING
**      result               = lv_result
**    EXCEPTIONS
**      cntl_error           = 1
**      error_no_gui         = 2
**      wrong_parameter      = 3
**      not_supported_by_gui = 4
**      OTHERS               = 5.
**
**
**  IF lv_result = 'X'.
**    lv_rc = '1'.
**  ELSE.
**    lv_rc = '0'.
**  ENDIF.
**
**  IF lv_rc = '1'.
**    GET TIME.
**    lv_date = sy-datum.
**    lv_time = sy-uzeit.
**    CONCATENATE lv_path '(Roles_Auth-AGR_1251)' '_' lv_date '_' lv_time '.xls' INTO lv_path.
**  ELSE.
**    IF p_f_path CS '.xls'.
**      lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
**      CONCATENATE lv_path '(Roles_Auth-AGR_1251)' '.xls' INTO lv_path.
**    ELSE.
**      CONCATENATE p_f_path '(Roles_Auth-AGR_1251)' '.xls' INTO lv_path.
**   ENDIF.
**  ENDIF.
*
**    lv_filename = p_f_path.
**    " Open file dialog to select folder path
**    CALL METHOD cl_gui_frontend_services=>directory_browse
**      EXPORTING
**        window_title    = 'Select Folder'
**      CHANGING
**        selected_folder = lv_folder.
**---------------------------------------------------------------------------------------*
*    " Check if a folder is selected
*    IF lv_folder IS NOT INITIAL. " User selected a folder
*      " Construct the full path of the file in the selected folder
*      CONCATENATE lv_folder '\'lv_filename '(Roles_Auth-AGR_1251)' '.csv' INTO lv_path.
*
*      " Check if the file exists in the selected folder
*      CALL METHOD cl_gui_frontend_services=>file_exist
*        EXPORTING
*          file                 = lv_path
*        RECEIVING
*          result               = lv_found
*        EXCEPTIONS
*          cntl_error           = 1
*          error_no_gui         = 2
*          wrong_parameter      = 3
*          not_supported_by_gui = 4
*          OTHERS               = 5.
*
*      IF lv_found = 'X'.
*        lv_rc = '1'.
*        GET TIME.
*        lv_date = sy-datum.
*        lv_time = sy-uzeit.
*        lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*        CONCATENATE lv_path  '_' lv_date '_' lv_time '.csv' INTO lv_path.
*      ENDIF.
*    ELSE.
*      IF p_f_path CS '.csv'.
*        lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*        CONCATENATE lv_path '(Roles_Auth-AGR_1251)'  '.csv' INTO lv_path.
*      ELSE.
*        CONCATENATE p_f_path '(Roles_Auth-AGR_1251)'  '.csv' INTO lv_path.
*      ENDIF.
*    ENDIF.
*
*    IF lv_found IS INITIAL.
*      " File not found in the selected folder, handle as needed
*      lv_rc = '0'.
*    ENDIF.
**&---------------------------------------------------------------------*
**& Heading for excel
**&---------------------------------------------------------------------*
*    it_heading_1251-text = 'Client Id'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'Role'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'ID'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'Object'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'User Master Maint.: Authorization Name'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'Variant'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'Field Name'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'Authorization Value'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'Authorization Value'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'Object Status'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'ID whether object is deleted'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'ID whether object is copied'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'ID whether object is new'.
*    APPEND it_heading_1251.
*    it_heading_1251-text = 'ID'.
*    APPEND it_heading_1251.
**&---------------------------------------------------------------------*
**& Downloading data to excel
**&---------------------------------------------------------------------*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_path
*        filetype                = 'ASC'
**       APPEND                  = ' '
*        write_field_separator   = 'X'
*      TABLES
*        data_tab                = lt_data_1251
*        fieldnames              = it_heading_1251
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*
*  ENDFORM.
**======================================================================*
**&---------------------------------------------------------------------*
**& Form Fetch_Data_Agrs
**&---------------------------------------------------------------------*
*  FORM Fetch_Data_Agrs .
**&---------------------------------------------------------------------*
**& Fetching data from table
**&---------------------------------------------------------------------*
*    SELECT mandt
*           agr_name
*           child_agr
*           attributes FROM agr_agrs
*                      INTO TABLE lt_data_agrs
*                      WHERE agr_name IN s_r_name.
**&------------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&------------------------------------------------------------------------*
*    " Check if a folder is selected
*    IF lv_folder IS NOT INITIAL. " User selected a folder
*      " Construct the full path of the file in the selected folder
*      CONCATENATE lv_folder '\'lv_filename '(Composite_Roles-AGR_AGRS)' '.xls' INTO lv_path.
*
*      " Check if the file exists in the selected folder
*      CALL METHOD cl_gui_frontend_services=>file_exist
*        EXPORTING
*          file                 = lv_path
*        RECEIVING
*          result               = lv_found
*        EXCEPTIONS
*          cntl_error           = 1
*          error_no_gui         = 2
*          wrong_parameter      = 3
*          not_supported_by_gui = 4
*          OTHERS               = 5.
*
*      IF lv_found = 'X'.
*        lv_rc = '1'.
*        GET TIME.
*        lv_date = sy-datum.
*        lv_time = sy-uzeit.
*        lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*        CONCATENATE lv_path  '_' lv_date '_' lv_time '.xls' INTO lv_path.
*      ENDIF.
*    ELSE.
*      IF p_f_path CS '.xls'.
*        lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*        CONCATENATE lv_path '(Composite_Roles-AGR_AGRS)'  '.xls' INTO lv_path.
*      ELSE.
*        CONCATENATE p_f_path '(Composite_Roles-AGR_AGRS)'  '.xls' INTO lv_path.
*      ENDIF.
*    ENDIF.
*
*    IF lv_found IS INITIAL.
*      " File not found in the selected folder, handle as needed
*      lv_rc = '0'.
*    ENDIF.
**&---------------------------------------------------------------------*
**& Heading for excel
**&---------------------------------------------------------------------*
*    it_heading_agrs-text = 'Client Id'.
*    APPEND it_heading_agrs.
*    it_heading_agrs-text = 'Composite Role'.
*    APPEND it_heading_agrs.
*    it_heading_agrs-text = 'Role'.
*    APPEND it_heading_agrs.
*    it_heading_agrs-text = 'Active'.
*    APPEND it_heading_agrs.
**&---------------------------------------------------------------------*
**& Downloading data to excel
**&---------------------------------------------------------------------*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_path
*        filetype                = 'ASC'
**       APPEND                  = ' '
*        write_field_separator   = 'X'
*      TABLES
*        data_tab                = lt_data_agrs
*        fieldnames              = it_heading_agrs
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*
*  ENDFORM.
**======================================================================*
**&---------------------------------------------------------------------*
**& Form Fetch_Data_Define
**&---------------------------------------------------------------------*
*  FORM Fetch_Data_Define .
**&---------------------------------------------------------------------*
**& Fetching data from table
**&---------------------------------------------------------------------*
*    SELECT mandt
*           agr_name
*           parent_agr
*           create_usr
*           create_dat
*           create_tim
*           create_tmp
*           change_usr
*           change_dat
*           change_tim
*           change_tmp
*           attributes FROM agr_define
*                      INTO TABLE lt_data_define
*                      WHERE agr_name IN s_r_name.
**&------------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&------------------------------------------------------------------------*
*    " Check if a folder is selected
*    IF lv_folder IS NOT INITIAL. " User selected a folder
*      " Construct the full path of the file in the selected folder
*      CONCATENATE lv_folder '\'lv_filename '(Master_Derived-AGR_DEFINE)' '.xls' INTO lv_path.
*
*      " Check if the file exists in the selected folder
*      CALL METHOD cl_gui_frontend_services=>file_exist
*        EXPORTING
*          file                 = lv_path
*        RECEIVING
*          result               = lv_found
*        EXCEPTIONS
*          cntl_error           = 1
*          error_no_gui         = 2
*          wrong_parameter      = 3
*          not_supported_by_gui = 4
*          OTHERS               = 5.
*
*      IF lv_found = 'X'.
*        lv_rc = '1'.
*        GET TIME.
*        lv_date = sy-datum.
*        lv_time = sy-uzeit.
*        lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*        CONCATENATE lv_path  '_' lv_date '_' lv_time '.xls' INTO lv_path.
*      ENDIF.
*    ELSE.
*      IF p_f_path CS '.xls'.
*        lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*        CONCATENATE lv_path '(Master_Derived-AGR_DEFINE)'  '.xls' INTO lv_path.
*      ELSE.
*        CONCATENATE p_f_path '(Master_Derived-AGR_DEFINE)'  '.xls' INTO lv_path.
*      ENDIF.
*    ENDIF.
*
*    IF lv_found IS INITIAL.
*      " File not found in the selected folder, handle as needed
*      lv_rc = '0'.
*    ENDIF.
**&---------------------------------------------------------------------*
**& Heading for excel
**&---------------------------------------------------------------------*
*    it_heading_define-text = 'Client Id'.
*    APPEND it_heading_define.
*    it_heading_define-text = 'Role'.
*    APPEND it_heading_define.
*    it_heading_define-text = 'Parent Role'.
*    APPEND it_heading_define.
*    it_heading_define-text = 'User'.
*    APPEND it_heading_define.
*    it_heading_define-text = 'Date'.
*    APPEND it_heading_define.
*    it_heading_define-text = 'Time'.
*    APPEND it_heading_define.
*    it_heading_define-text = 'UTC Time Stamp in Short Form (YYYYMMDDhh)'.
*    APPEND it_heading_define.
*    it_heading_define-text = 'User'.
*    APPEND it_heading_define.
*    it_heading_define-text = 'Date'.
*    APPEND it_heading_define.
*    it_heading_define-text = 'Time'.
*    APPEND it_heading_define.
*    it_heading_define-text = 'UTC Time Stamp in Short Form (YYYYMMDDhh)'.
*    APPEND it_heading_define.
*    it_heading_define-text = 'Attributes'.
*    APPEND it_heading_define.
**&---------------------------------------------------------------------*
**& Downloading data to excel
**&---------------------------------------------------------------------*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_path
*        filetype                = 'ASC'
**       APPEND                  = ' '
*        write_field_separator   = 'X'
*      TABLES
*        data_tab                = lt_data_define
*        fieldnames              = it_heading_define
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*
*  ENDFORM.
**======================================================================*
**&---------------------------------------------------------------------*
**& Form Fetch_Data_Tcodes
**&---------------------------------------------------------------------*
*  FORM Fetch_Data_Tcodes .
*
**&---------------------------------------------------------------------*
**& Fetching data from table
**&---------------------------------------------------------------------*
*    SELECT * FROM agr_tcodes INTO TABLE lt_data_tcodes WHERE agr_name IN s_r_name.
*
**&---------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&---------------------------------------------------------------------*
*    " Check if a folder is selected
*    IF lv_folder IS NOT INITIAL. " User selected a folder
*      " Construct the full path of the file in the selected folder
*      CONCATENATE lv_folder '\'lv_filename '(Roles_Tcodes-AGR_TCODES)' '.xls' INTO lv_path.
*
*      " Check if the file exists in the selected folder
*      CALL METHOD cl_gui_frontend_services=>file_exist
*        EXPORTING
*          file                 = lv_path
*        RECEIVING
*          result               = lv_found
*        EXCEPTIONS
*          cntl_error           = 1
*          error_no_gui         = 2
*          wrong_parameter      = 3
*          not_supported_by_gui = 4
*          OTHERS               = 5.
*
*      IF lv_found = 'X'.
*        lv_rc = '1'.
*        GET TIME.
*        lv_date = sy-datum.
*        lv_time = sy-uzeit.
*        lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*        CONCATENATE lv_path  '_' lv_date '_' lv_time '.xls' INTO lv_path.
*      ENDIF.
*    ELSE.
*      IF p_f_path CS '.xls'.
*        lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*        CONCATENATE lv_path '(Roles_Tcodes-AGR_TCODES)'  '.xls' INTO lv_path.
*      ELSE.
*        CONCATENATE p_f_path '(Roles_Tcodes-AGR_TCODES)'  '.xls' INTO lv_path.
*      ENDIF.
*    ENDIF.
*
*    IF lv_found IS INITIAL.
*      " File not found in the selected folder, handle as needed
*      lv_rc = '0'.
*    ENDIF.
*
*
**&---------------------------------------------------------------------*
**& Heading for excel
**&---------------------------------------------------------------------*
*    it_heading_tcodes-text = 'Client Id'.
*    APPEND it_heading_tcodes.
*    it_heading_tcodes-text = 'Role'.
*    APPEND it_heading_tcodes.
*    it_heading_tcodes-text = 'Report Type'.
*    APPEND it_heading_tcodes.
*    it_heading_tcodes-text = 'Tcodes'.
*    APPEND it_heading_tcodes.
*    it_heading_tcodes-text = 'Exclusive'.
*    APPEND it_heading_tcodes.
*    it_heading_tcodes-text = 'Transaction input Directly'.
*    APPEND it_heading_tcodes.
*    it_heading_tcodes-text = 'Transaction inherited from previous role'.
*    APPEND it_heading_tcodes.
*    it_heading_tcodes-text = 'ID'.
*    APPEND it_heading_tcodes.
**&---------------------------------------------------------------------*
**& Downloading data to excel
**&---------------------------------------------------------------------*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_path
*        filetype                = 'ASC'
**       APPEND                  = ' '
*        write_field_separator   = 'X'
*      TABLES
*        data_tab                = lt_data_tcodes
*        fieldnames              = it_heading_tcodes
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
**ENDIF.
*
*  ENDFORM.
**=====================================================================*
**&---------------------------------------------------------------------*
**& Form z_agr_1250
**&---------------------------------------------------------------------*
*  FORM z_agr_1250 .
**&---------------------------------------------------------------------*
**& Fetching data from table
**&---------------------------------------------------------------------*
*    SELECT * FROM agr_1250
*                INTO TABLE lt_data_1250
*                WHERE agr_name IN s_r_name.
**&------------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&------------------------------------------------------------------------*
*
*    " Check if a folder is selected
*    IF lv_folder IS NOT INITIAL. " User selected a folder
*      " Construct the full path of the file in the selected folder
*      CONCATENATE lv_folder '\'lv_filename '(Auth_Actv_grp-AGR_1250)' '.xls' INTO lv_path.
*
*      " Check if the file exists in the selected folder
*      CALL METHOD cl_gui_frontend_services=>file_exist
*        EXPORTING
*          file                 = lv_path
*        RECEIVING
*          result               = lv_found
*        EXCEPTIONS
*          cntl_error           = 1
*          error_no_gui         = 2
*          wrong_parameter      = 3
*          not_supported_by_gui = 4
*          OTHERS               = 5.
*
*      IF lv_found = 'X'.
*        lv_rc = '1'.
*        GET TIME.
*        lv_date = sy-datum.
*        lv_time = sy-uzeit.
*        lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*        CONCATENATE lv_path  '_' lv_date '_' lv_time '.xls' INTO lv_path.
*      ENDIF.
*    ELSE.
*      IF p_f_path CS '.xls'.
*        lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*        CONCATENATE lv_path '(Auth_Actv_grp-AGR_1250)'  '.xls' INTO lv_path.
*      ELSE.
*        CONCATENATE p_f_path '(Auth_Actv_grp-AGR_1250)'  '.xls' INTO lv_path.
*      ENDIF.
*    ENDIF.
*
*    IF lv_found IS INITIAL.
*      " File not found in the selected folder, handle as needed
*      lv_rc = '0'.
*    ENDIF.
**&---------------------------------------------------------------------*
**& Heading for excel
**&---------------------------------------------------------------------*
*    it_heading_1250-text = 'Client Id'.
*    APPEND it_heading_1250.
*    it_heading_1250-text = 'Role'.
*    APPEND it_heading_1250.
*    it_heading_1250-text = 'ID'.
*    APPEND it_heading_1250.
*    it_heading_1250-text = 'Authorization Object'.
*    APPEND it_heading_1250.
*    it_heading_1250-text = 'User Master Maint.: Authorization Name'.
*    APPEND it_heading_1250.
*    it_heading_1250-text = 'Variant'.
*    APPEND it_heading_1250.
*    it_heading_1250-text = 'Object Status'.
*    APPEND it_heading_1250.
*    it_heading_1250-text = 'ID whether object is deleted'.
*    APPEND it_heading_1250.
*    it_heading_1250-text = 'ID whether object is copied'.
*    APPEND it_heading_1250.
*    it_heading_1250-text = 'ID whether object is new'.
*    APPEND it_heading_1250.
*    it_heading_1250-text = 'ID'.
*    APPEND it_heading_1250.
**&---------------------------------------------------------------------*
**& Downloading data to excel
**&---------------------------------------------------------------------*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_path
*        filetype                = 'ASC'
**       APPEND                  = ' '
*        write_field_separator   = 'X'
*      TABLES
*        data_tab                = lt_data_1250
*        fieldnames              = it_heading_1250
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*  ENDFORM.
**======================================================================*
**&---------------------------------------------------------------------*
**& Form z_agr_users
**--------------------------------------------------------*
*  FORM z_agr_users .
**&---------------------------------------------------------------------*
**& Fetching data from table
**&---------------------------------------------------------------------*
*    SELECT * FROM agr_users
*                INTO TABLE lt_data_users
*                WHERE agr_name IN s_r_name.
*
**&------------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&------------------------------------------------------------------------*
*    " Check if a folder is selected
*    IF lv_folder IS NOT INITIAL. " User selected a folder
*      " Construct the full path of the file in the selected folder
*      CONCATENATE lv_folder '\'lv_filename '(Roles_Users-Agr_Users)' '.xls' INTO lv_path.
*
*      " Check if the file exists in the selected folder
*      CALL METHOD cl_gui_frontend_services=>file_exist
*        EXPORTING
*          file                 = lv_path
*        RECEIVING
*          result               = lv_found
*        EXCEPTIONS
*          cntl_error           = 1
*          error_no_gui         = 2
*          wrong_parameter      = 3
*          not_supported_by_gui = 4
*          OTHERS               = 5.
*
*      IF lv_found = 'X'.
*        lv_rc = '1'.
*        GET TIME.
*        lv_date = sy-datum.
*        lv_time = sy-uzeit.
*        lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*        CONCATENATE lv_path  '_' lv_date '_' lv_time '.xls' INTO lv_path.
*      ENDIF.
*    ELSE.
*      IF p_f_path CS '.xls'.
*        lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*        CONCATENATE lv_path '(Roles_Users-Agr_Users)'  '.xls' INTO lv_path.
*      ELSE.
*        CONCATENATE p_f_path '(Roles_Users-Agr_Users)'  '.xls' INTO lv_path.
*      ENDIF.
*    ENDIF.
*
*    IF lv_found IS INITIAL.
*      " File not found in the selected folder, handle as needed
*      lv_rc = '0'.
*    ENDIF.
**&---------------------------------------------------------------------*
**& Heading for excel
**&---------------------------------------------------------------------*
*    it_heading_users-text = 'Client'.
*    APPEND it_heading_users.
*    it_heading_users = 'Role'.
*    APPEND it_heading_users.
*    it_heading_users-text = 'User Name'.
*    APPEND it_heading_users.
*    it_heading_users-text = 'Start date'.
*    APPEND it_heading_users.
*    it_heading_users-text = 'End date'.
*    APPEND it_heading_users.
*    it_heading_users-text = 'Exclusive'.
*    APPEND it_heading_users.
*    it_heading_users-text = 'Date'.
*    APPEND it_heading_users.
*    it_heading_users-text = 'Time'.
*    APPEND it_heading_users.
*    it_heading_users-text = 'UTC Time Stamp in Short Form (YYYYMMDDhh)'.
*    APPEND it_heading_users.
*    it_heading_users-text = 'Assignment comes from HR Organization Management'.
*    APPEND it_heading_users.
*    it_heading_users-text = 'Assignment Comes From Composite Role'.
*    APPEND it_heading_users.
**&---------------------------------------------------------------------*
**& Downloading data to excel
**&---------------------------------------------------------------------*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_path
*        filetype                = 'ASC'
**       APPEND                  = ' '
*        write_field_separator   = 'X'
*      TABLES
*        data_tab                = lt_data_users
*        fieldnames              = it_heading_users
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*  ENDFORM.
**=======================================================================*
**&---------------------------------------------------------------------*
**& Form z_agr_usobt
**&---------------------------------------------------------------------*
*  FORM z_agr_usobt .
**&---------------------------------------------------------------------*
**& Fetching data from table
**&---------------------------------------------------------------------*
*    SELECT * FROM usobt
*                INTO TABLE lt_data_usobt
*                WHERE name IN s_u_name.
**&------------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&------------------------------------------------------------------------*
*    " Check if a folder is selected
*    IF lv_folder IS NOT INITIAL. " User selected a folder
*      " Construct the full path of the file in the selected folder
*      CONCATENATE lv_folder '\'lv_filename '(USOBT)' '.xls' INTO lv_path.
*
*      " Check if the file exists in the selected folder
*      CALL METHOD cl_gui_frontend_services=>file_exist
*        EXPORTING
*          file                 = lv_path
*        RECEIVING
*          result               = lv_found
*        EXCEPTIONS
*          cntl_error           = 1
*          error_no_gui         = 2
*          wrong_parameter      = 3
*          not_supported_by_gui = 4
*          OTHERS               = 5.
*
*      IF lv_found = 'X'.
*        lv_rc = '1'.
*        GET TIME.
*        lv_date = sy-datum.
*        lv_time = sy-uzeit.
*        lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*        CONCATENATE lv_path  '_' lv_date '_' lv_time '.xls' INTO lv_path.
*      ENDIF.
*    ELSE.
*      IF p_f_path CS '.xls'.
*        lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*        CONCATENATE lv_path '(USOBT)'  '.xls' INTO lv_path.
*      ELSE.
*        CONCATENATE p_f_path '(USOBT)'  '.xls' INTO lv_path.
*      ENDIF.
*    ENDIF.
*
*    IF lv_found IS INITIAL.
*      " File not found in the selected folder, handle as needed
*      lv_rc = '0'.
*    ENDIF.
**&---------------------------------------------------------------------*
**& Heading for excel
**&---------------------------------------------------------------------*
*    it_heading_usobt-text = 'Name'.
*    APPEND it_heading_usobt.
*    it_heading_usobt-text = 'Test status type and Proposed Values for'.
*    APPEND it_heading_usobt.
*    it_heading_usobt-text = 'Authorization Object'.
*    APPEND it_heading_usobt.
*    it_heading_usobt-text = 'Authorization Fld'.
*    APPEND it_heading_usobt.
*    it_heading_usobt-text = 'Authorization Value'.
*    APPEND it_heading_usobt.
*    it_heading_usobt-text = 'Authorization Value'.
*    APPEND it_heading_usobt.
*    it_heading_usobt-text = 'Changed By'.
*    APPEND it_heading_usobt.
*    it_heading_usobt-text = 'Modification date'.
*    APPEND it_heading_usobt.
*    it_heading_usobt-text = 'Modification time'.
*    APPEND it_heading_usobt.
**&---------------------------------------------------------------------*
**& Downloading data to excel
**&---------------------------------------------------------------------*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_path
*        filetype                = 'ASC'
**       APPEND                  = ' '
*        write_field_separator   = 'X'
*      TABLES
*        data_tab                = lt_data_usobt
*        fieldnames              = it_heading_usobt
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*  ENDFORM.
**======================================================================*
**&---------------------------------------------------------------------*
**& Form z_usobx
**&---------------------------------------------------------------------*
*  FORM z_usobx .
**&---------------------------------------------------------------------*
**& Fetching data from table
**&---------------------------------------------------------------------*
*    SELECT * FROM usobx
*                INTO TABLE lt_data_usobx
*                WHERE name IN s_u_name.
**&------------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&------------------------------------------------------------------------*
*    " Check if a folder is selected
*    IF lv_folder IS NOT INITIAL. " User selected a folder
*      " Construct the full path of the file in the selected folder
*      CONCATENATE lv_folder '\'lv_filename '(USOBX)' '.xls' INTO lv_path.
*
*      " Check if the file exists in the selected folder
*      CALL METHOD cl_gui_frontend_services=>file_exist
*        EXPORTING
*          file                 = lv_path
*        RECEIVING
*          result               = lv_found
*        EXCEPTIONS
*          cntl_error           = 1
*          error_no_gui         = 2
*          wrong_parameter      = 3
*          not_supported_by_gui = 4
*          OTHERS               = 5.
*
*      IF lv_found = 'X'.
*        lv_rc = '1'.
*        GET TIME.
*        lv_date = sy-datum.
*        lv_time = sy-uzeit.
*        lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*        CONCATENATE lv_path  '_' lv_date '_' lv_time '.xls' INTO lv_path.
*      ENDIF.
*    ELSE.
*      IF p_f_path CS '.xls'.
*        lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*        CONCATENATE lv_path '(USOBX)'  '.xls' INTO lv_path.
*      ELSE.
*        CONCATENATE p_f_path '(USOBX)'  '.xls' INTO lv_path.
*      ENDIF.
*    ENDIF.
*
*    IF lv_found IS INITIAL.
*      " File not found in the selected folder, handle as needed
*      lv_rc = '0'.
*    ENDIF.
*
**&---------------------------------------------------------------------*
**& Heading for excel
**&---------------------------------------------------------------------*
*    it_heading_usobx-text = 'Name'.
*    APPEND it_heading_usobx.
*    it_heading_usobx-text = 'Test status type and Proposed Values for'.
*    APPEND it_heading_usobx.
*    it_heading_usobx-text = 'Authorization Object'.
*    APPEND it_heading_usobx.
*    it_heading_usobx-text = 'Changed By'.
*    APPEND it_heading_usobx.
*    it_heading_usobx-text = 'Modification date'.
*    APPEND it_heading_usobx.
*    it_heading_usobx-text = 'Modification time'.
*    APPEND it_heading_usobx.
*    it_heading_usobx-text = 'Check field'.
*    APPEND it_heading_usobx.
**&---------------------------------------------------------------------*
**& Downloading data to excel
**&---------------------------------------------------------------------*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_path
*        filetype                = 'ASC'
**       APPEND                  = ' '
*        write_field_separator   = 'X'
*      TABLES
*        data_tab                = lt_data_usobx
*        fieldnames              = it_heading_usobx
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*  ENDFORM.
**========================================================================*
**&---------------------------------------------------------------------*
**& Form z_usobx_c
**&---------------------------------------------------------------------*
*  FORM z_usobx_c .
**&---------------------------------------------------------------------*
**& Fetching data from table
**&---------------------------------------------------------------------*
*    SELECT * FROM usobx_c
*                INTO TABLE lt_data_usobx_c
*                WHERE name IN s_u_name.
**&------------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&------------------------------------------------------------------------*
*    " Check if a folder is selected
*    IF lv_folder IS NOT INITIAL. " User selected a folder
*      " Construct the full path of the file in the selected folder
*      CONCATENATE lv_folder '\'lv_filename '(USOBX_C)' '.xls' INTO lv_path.
*
*      " Check if the file exists in the selected folder
*      CALL METHOD cl_gui_frontend_services=>file_exist
*        EXPORTING
*          file                 = lv_path
*        RECEIVING
*          result               = lv_found
*        EXCEPTIONS
*          cntl_error           = 1
*          error_no_gui         = 2
*          wrong_parameter      = 3
*          not_supported_by_gui = 4
*          OTHERS               = 5.
*
*      IF lv_found = 'X'.
*        lv_rc = '1'.
*        GET TIME.
*        lv_date = sy-datum.
*        lv_time = sy-uzeit.
*        lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*        CONCATENATE lv_path  '_' lv_date '_' lv_time '.xls' INTO lv_path.
*      ENDIF.
*    ELSE.
*      IF p_f_path CS '.xls'.
*        lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*        CONCATENATE lv_path '(USOBX_C)'  '.xls' INTO lv_path.
*      ELSE.
*        CONCATENATE p_f_path '(USOBX_C)'  '.xls' INTO lv_path.
*      ENDIF.
*    ENDIF.
*
*    IF lv_found IS INITIAL.
*      " File not found in the selected folder, handle as needed
*      lv_rc = '0'.
*    ENDIF.
**&---------------------------------------------------------------------*
**& Heading for excel
**&---------------------------------------------------------------------*
*    it_heading_usobx_c-text = 'Name'.
*    APPEND it_heading_usobx_c.
*    it_heading_usobx_c-text = 'Test status type and Proposed Values for'.
*    APPEND it_heading_usobx_c.
*    it_heading_usobx_c-text = 'Authorization Object'.
*    APPEND it_heading_usobx_c.
*    it_heading_usobx_c-text = 'Changed By'.
*    APPEND it_heading_usobx_c.
*    it_heading_usobx_c-text = 'Modification date'.
*    APPEND it_heading_usobx_c.
*    it_heading_usobx_c-text = 'Modification time'.
*    APPEND it_heading_usobx_c.
*    it_heading_usobx_c-text = 'Check field'.
*    APPEND it_heading_usobx_c.
*    it_heading_usobx_c-text = 'Modification ID'.
*    APPEND it_heading_usobx_c.
*    it_heading_usobx_c-text = 'Name'.
*    APPEND it_heading_usobx_c.
**&---------------------------------------------------------------------*
**& Downloading data to excel
**&---------------------------------------------------------------------*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_path
*        filetype                = 'ASC'
**       APPEND                  = ' '
*        write_field_separator   = 'X'
*      TABLES
*        data_tab                = lt_data_usobx_c
*        fieldnames              = it_heading_usobx_c
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*  ENDFORM.
**========================================================================*
**&---------------------------------------------------------------------*
**& Form z_usobt_c
**&---------------------------------------------------------------------*
*  FORM z_usobt_c .
**&---------------------------------------------------------------------*
**& Fetching data from table
**&---------------------------------------------------------------------*
*    SELECT * FROM usobt_c
*                INTO TABLE lt_data_usobt_c
*                WHERE name IN s_u_name.
**&------------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&------------------------------------------------------------------------*
*    " Check if a folder is selected
*    IF lv_folder IS NOT INITIAL. " User selected a folder
*      " Construct the full path of the file in the selected folder
*      CONCATENATE lv_folder '\'lv_filename '(USOBT_C)' '.xls' INTO lv_path.
*
*      " Check if the file exists in the selected folder
*      CALL METHOD cl_gui_frontend_services=>file_exist
*        EXPORTING
*          file                 = lv_path
*        RECEIVING
*          result               = lv_found
*        EXCEPTIONS
*          cntl_error           = 1
*          error_no_gui         = 2
*          wrong_parameter      = 3
*          not_supported_by_gui = 4
*          OTHERS               = 5.
*
*      IF lv_found = 'X'.
*        lv_rc = '1'.
*        GET TIME.
*        lv_date = sy-datum.
*        lv_time = sy-uzeit.
*        lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*        CONCATENATE lv_path  '_' lv_date '_' lv_time '.xls' INTO lv_path.
*      ENDIF.
*    ELSE.
*      IF p_f_path CS '.xls'.
*        lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*        CONCATENATE lv_path '(USOBT_C)'  '.xls' INTO lv_path.
*      ELSE.
*        CONCATENATE p_f_path '(USOBT_C)'  '.xls' INTO lv_path.
*      ENDIF.
*    ENDIF.
*
*    IF lv_found IS INITIAL.
*      " File not found in the selected folder, handle as needed
*      lv_rc = '0'.
*    ENDIF.
*
**&---------------------------------------------------------------------*
**& Heading for excel
**&---------------------------------------------------------------------*
*    it_heading_usobt_c-text = 'Name'.
*    APPEND it_heading_usobt_c.
*    it_heading_usobt_c-text = 'Test status type and Proposed Values for'.
*    APPEND it_heading_usobt_c.
*    it_heading_usobt_c-text = 'Authorization Object'.
*    APPEND it_heading_usobt_c.
*    it_heading_usobt_c-text = 'Authorization Field'.
*    APPEND it_heading_usobt_c.
*    it_heading_usobt_c-text = 'Authorization Value'.
*    APPEND it_heading_usobt_c.
*    it_heading_usobt_c-text = 'Authorization Value'.
*    APPEND it_heading_usobt_c.
*    it_heading_usobt_c-text = 'Changed By'.
*    APPEND it_heading_usobt_c.
*    it_heading_usobt_c-text = 'Modification date'.
*    APPEND it_heading_usobt_c.
*    it_heading_usobt_c-text = 'Modification time'.
*    APPEND it_heading_usobt_c.
*    it_heading_usobt_c-text = 'Modification ID'.
*    APPEND it_heading_usobt_c.
**&---------------------------------------------------------------------*
**& Downloading data to excel
**&---------------------------------------------------------------------*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_path
*        filetype                = 'ASC'
**       APPEND                  = ' '
*        write_field_separator   = 'X'
*      TABLES
*        data_tab                = lt_data_usobt_c
*        fieldnames              = it_heading_usobt_c
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*  ENDFORM.
**======================================================================*
**&---------------------------------------------------------------------*
**& Form Fetch_T_Usage
**&---------------------------------------------------------------------*
*  FORM Fetch_T_Usage .
*    PERFORM get_data_workload.
*  ENDFORM.
**&---------------------------------------------------------------------*
**& Form get_data_workload
**&---------------------------------------------------------------------*
*  FORM get_data_workload .
*    DATA: i_valido TYPE c.
*    DATA: i_entry(40),
*    i_account TYPE zworkload-account.
*    TYPES: BEGIN OF t_steps,
*             period       TYPE zworkload-period,
*             account      TYPE zworkload-account,
*             entry_id(40),
*             count        TYPE zworkload-zsteps,
*           END OF t_steps.
*    DATA: it_steps TYPE HASHED TABLE OF t_steps WITH UNIQUE KEY period account entry_id.
*    DATA: h_steps TYPE t_steps.
*    REFRESH: t_dirmoni, t_output, it_steps, it_tstcp, t_elcod.
*
*    CALL FUNCTION 'SWNC_COLLECTOR_GET_DIRECTORY'
*      EXPORTING
*        get_dir_from_cluster = ' '
*        exclude_summary      = ' '
*      TABLES
*        directory_keys       = t_dirmoni
*      EXCEPTIONS
*        no_data_found        = 1
*        OTHERS               = 2.
*    IF sy-subrc <> 0.
*    ENDIF.
*    " Application servers WORKLOAD
** with month registration period
*    LOOP AT t_dirmoni INTO DATA(ts_dirmoni)  WHERE component NE 'TOTAL' OR
*                            periodtype NE 'M'.
*      DELETE t_dirmoni.
*
*    ENDLOOP.
*    LOOP AT t_dirmoni INTO ts_dirmoni .
*      REFRESH t_work.
*      " Read aggregated activity
*      CHECK ts_dirmoni-periodstrt(6) IN s_period.
*      CALL FUNCTION 'SWNC_COLLECTOR_GET_AGGREGATES'
*        EXPORTING
*          component     = ts_dirmoni-component
*          periodtype    = ts_dirmoni-periodtype
*          periodstrt    = ts_dirmoni-periodstrt
*        TABLES
*          usertcode     = t_work
**         HITLIST_DATABASE = t_work
*        EXCEPTIONS
*          no_data_found = 1
*          OTHERS        = 2.
*      SORT t_work BY account entry_id.
*      CLEAR: i_entry, i_account.
*      LOOP AT t_work INTO DATA(ws_work).
** Step Counter for each report/transaction
*        CLEAR h_steps.
**      MOVE t_work-account TO h_steps-account.
*        MOVE ws_work-account TO h_steps-account.
**      MOVE t_work-entry_id(40) TO h_steps-entry_id.
*        MOVE ws_work-entry_id(40) TO h_steps-entry_id.
**      MOVE t_dirmoni-periodstrt(6) TO h_steps-period.
*        MOVE ts_dirmoni-periodstrt(6) TO h_steps-period.
**      MOVE t_work-count TO h_steps-count. "numero di steps
*        MOVE ws_work-count TO h_steps-count. "numero di steps
*        READ TABLE it_steps WITH KEY account  = h_steps-account
*                                    entry_id = h_steps-entry_id
*                                    period  = h_steps-period
*                                  TRANSPORTING NO FIELDS.
*        IF sy-subrc EQ 0. "If already exists
*          " Collect data steps
*          COLLECT h_steps INTO it_steps.
**          DELETE t_work.
*          DELETE t_work.
*          CONTINUE.
*        ELSE.
*          " Collectdata steps
*          COLLECT h_steps INTO it_steps.
*        ENDIF.
*        "Filter to verify selection conditions
*        CLEAR t_output.
**      MOVE t_work-account TO t_output-account.
*        MOVE ws_work-account TO t_output-account.
**      MOVE t_work-entry_id+72(1) TO t_output-typelem.
*        MOVE ws_work-entry_id+72(1) TO t_output-typelem.
*        IF t_output-typelem = 'T'.
**        MOVE t_work-entry_id(40) TO t_output-ztcode. "Save transaction code or report
*          MOVE ws_work-entry_id(40) TO t_output-ztcode. "Save transaction code or report
*        ENDIF.
*        CONDENSE t_output-ztcode NO-GAPS.
**      CONDENSE ts_output-ztcode NO-GAPS.
**      IF NOT t_work-entry_id+40(32) IS INITIAL. "If name defined = JOB
*        IF NOT ws_work-entry_id+40(32) IS INITIAL. "If name defined = JOB
**        MOVE 'B' TO t_output-zlncht.
*          MOVE 'B' TO t_output-zlncht.
*        ENDIF.
*        MOVE ts_dirmoni-periodstrt(6) TO t_output-period.
**      MOVE t_dirmoni-periodstrt(6) TO t_output-period.
**      MOVE t_work-tasktype TO t_output-destasktype. "To convert
*        MOVE ws_work-tasktype TO t_output-destasktype. "To convert
*        PERFORM verifica_selezioni USING t_output
*                                    CHANGING i_valido.
*        IF i_valido EQ 'X'.
*          PERFORM add_info CHANGING t_output.
*          APPEND   t_output.
*        ENDIF.
*      ENDLOOP.
*    ENDLOOP.
*    IF t_output[] IS INITIAL.
*      MESSAGE i000(fb) WITH TEXT-e01.
*    ENDIF.
*    SORT t_output BY period account ztcode zrepnm.
*    DELETE ADJACENT DUPLICATES FROM t_output COMPARING period account ztcode zrepnm.
**  LOOP AT t_output.
*    LOOP AT t_output .
*      CLEAR: h_steps.
*      READ TABLE it_steps INTO h_steps WITH KEY entry_id = t_output-ztcode
*                                                  period = t_output-period
*                                                  account = t_output-account.
**        READ TABLE it_steps INTO h_steps WITH KEY entry_id = ts_output-ztcode
**                                                period = ts_output-period
**                                                account = ts_output-account.
*      IF sy-subrc EQ 0.
*        "Assign step value calculated
*        t_output-zsteps = h_steps-count.
**      ts_output-zsteps = h_steps-count.
*      ENDIF.
*      IF sy-subrc EQ 0.
*        MODIFY t_output .
**      MODIFY t_output FROM ts_output.
*      ENDIF.
*    ENDLOOP.
*
*    DELETE t_output[] WHERE ztcode = ' '.
*
*    it_heading_st03n-text = 'Transaction'.
*    APPEND it_heading_st03n.
**-----------------------------------------------------------------------*
**    LOOP AT t_output.
***  LOOP AT t_output INTO ts_output.
**      MOVE t_output-ztcode TO fs_output-ztcode.
**      APPEND fs_output TO f_output.
**    ENDLOOP.
**    SORT f_output BY ztcode ASCENDING.
**-----------------------------------------------------------------------*
*    LOOP AT t_output INTO DATA(ts_output).
*      fs_output-ztcode = ts_output-ztcode.
*      APPEND fs_output TO f_output.
**      DELETE ADJACENT DUPLICATES FROM f_output COMPARING ztcode.
*    ENDLOOP.
*    SORT f_output BY ztcode ASCENDING.
*
*  ENDFORM.                    "get_data_workload
**&---------------------------------------------------------------------*
**& Form verifica_selezioni
**&---------------------------------------------------------------------*
*  FORM verifica_selezioni  USING   f_line TYPE zworkload
*                           CHANGING f_valido.
*    CLEAR f_valido.
** Report or Transaction?
**  CHECK f_line-typelem IN s_reptr.
** Check report and transaction Filter Selection
**  CHECK NOT f_line-ztcode IS INITIAL AND f_line-ztcode IN s_tcode.
** Check Username Filter Selection
*    CHECK NOT f_line-account IS INITIAL AND f_line-account IN s_user.
*    f_valido = 'X'.
*
*  ENDFORM.
**&---------------------------------------------------------------------*
**& Form add_info
**&---------------------------------------------------------------------*
*  FORM add_info  CHANGING p_t_output.
*    DATA: ipgmna   TYPE tstc-pgmna,
*          ifctr_id TYPE tdevc-component.
*    DATA: iconta TYPE i.
*    DATA: search_trsn TYPE string.
*    " Conversion task type description
*    CLEAR itsktp.
*    MOVE t_output-destasktype TO itsktp.
**  MOVE ts_output-destasktype TO itsktp.
*    CLEAR t_output-destasktype.
**  CLEAR ts_output-destasktype.
*    CALL METHOD cl_swnc_collector_info=>translate_tasktype
*      EXPORTING
*        tasktyperaw = itsktp
*      RECEIVING
*        tasktype    = t_output-destasktype.
*    " Set extend name account
*    CLEAR t_output-nmaccount.
**  CLEAR ts_output-nmaccount.
*    SELECT SINGLE name_text FROM v_usr_name INTO t_output-nmaccount
*    WHERE bname EQ t_output-account.
*
**      SELECT name_text FROM v_user_name UP TO 1 ROWS
**         INTO t_output-nmaccount
**        WHERE bname EQ t_output-account
**        ORDER BY PRIMARY KEY.
**      ENDSELECT.
*
**    SELECT SINGLE name_text FROM v_usr_name INTO ts_output-nmaccount
**  WHERE bname EQ ts_output-account.
*      IF t_output-typelem EQ 'T'.
**  IF ts_output-typelem EQ 'T'.
******************* DATA on transaction*****************************
*        CLEAR t_output-ddtext.
**    CLEAR ts_output-ddtext.
*        SELECT SINGLE ttext FROM tstct INTO t_output-ddtext
*        WHERE tcode EQ t_output-ztcode AND
*        sprsl EQ sy-langu.
**        SELECT SINGLE ttext FROM tstct INTO ts_output-ddtext
**    WHERE tcode EQ ts_output-ztcode AND
**    sprsl EQ sy-langu.
** Development class
**  Component
** Creator
** Creation Data
** Modification author
** Modification date
*          CLEAR: t_output-devclass.
**    CLEAR: ts_output-devclass.
*          SELECT SINGLE devclass
*              FROM tadir INTO t_output-devclass
*            WHERE obj_name EQ t_output-ztcode AND
*          object EQ 'TRAN' AND
*          pgmid EQ 'R3TR'.
**        SELECT SINGLE devclass
**        FROM tadir INTO ts_output-devclass
**      WHERE obj_name EQ ts_output-ztcode AND
**    object EQ 'TRAN' AND
**    pgmid EQ 'R3TR'.
*            " Search application component
*            CLEAR: t_output-compid, ifctr_id.
**    CLEAR: ts_output-compid, ifctr_id.
*            IF NOT t_output-devclass IS INITIAL.
**    IF NOT ts_output-devclass IS INITIAL.
*              SELECT SINGLE component FROM tdevc INTO ifctr_id
*              WHERE devclass EQ t_output-devclass.
**            SELECT SINGLE component FROM tdevc INTO ifctr_id
**      WHERE devclass EQ ts_output-devclass.
*                IF sy-subrc EQ 0.
*                  SELECT SINGLE ps_posid FROM df14l INTO t_output-compid
*                  WHERE fctr_id EQ ifctr_id.
**                SELECT SINGLE ps_posid FROM df14l INTO ts_output-compid
**        WHERE fctr_id EQ ifctr_id.
*                  ENDIF.
*                ENDIF.
*                CLEAR: ipgmna.
*                SELECT SINGLE pgmna FROM tstc INTO ipgmna
*                WHERE tcode EQ t_output-ztcode.
**        SELECT SINGLE pgmna FROM tstc INTO ipgmna
**    WHERE tcode EQ ts_output-ztcode.
*                  CLEAR: t_output-cnam, t_output-cdat, t_output-cnamod, t_output-cdatmod.
**    CLEAR: ts_output-cnam, ts_output-cdat, ts_output-cnamod, ts_output-cdatmod.
*                  SELECT SINGLE cnam cdat unam udat
*                  FROM trdir INTO (t_output-cnam,t_output-cdat,t_output-cnamod,t_output-cdatmod)
*                  WHERE name EQ ipgmna.
**        SELECT SINGLE cnam cdat unam udat
**    FROM trdir INTO (ts_output-cnam,ts_output-cdat,ts_output-cnamod,ts_output-cdatmod)
**    WHERE name EQ ipgmna.
** Development class description
*                    CLEAR t_output-desclass.
**    CLEAR ts_output-desclass.
*                    SELECT SINGLE ctext FROM tdevct INTO t_output-desclass
*                    WHERE devclass EQ t_output-devclass AND
*                    spras EQ sy-langu.
**        SELECT SINGLE ctext FROM tdevct INTO ts_output-desclass
**    WHERE devclass EQ ts_output-devclass AND
**    spras EQ sy-langu.
*                    ELSEIF t_output-typelem EQ 'R'.
**  ELSEIF ts_output-typelem EQ 'R'.
******************* DATA on REPORT *****************************
** Object description
*                      CLEAR t_output-ddtext.
**    CLEAR ts_output-ddtext.
*                      SELECT SINGLE text FROM trdirt INTO t_output-ddtext
*                      WHERE name EQ t_output-ztcode AND
*                      sprsl EQ sy-langu.
**        SELECT SINGLE text FROM trdirt INTO ts_output-ddtext
**    WHERE name EQ ts_output-ztcode AND
**    sprsl EQ sy-langu.
** Development Class
** Component
** Creator
** Creation data
** Modification author
** Modification date
*                        CLEAR: t_output-devclass.
**    CLEAR: ts_output-devclass.
*                        SELECT SINGLE devclass
*                          FROM tadir INTO t_output-devclass
*                          WHERE obj_name EQ t_output-ztcode AND
*                        object EQ 'PROG' AND
*                        pgmid EQ 'R3TR'.
**        SELECT SINGLE devclass
**      FROM tadir INTO ts_output-devclass
**      WHERE obj_name EQ ts_output-ztcode AND
**    object EQ 'PROG' AND
**    pgmid EQ 'R3TR'.
*                          " Search application component
*                          CLEAR: t_output-compid, ifctr_id.
**    CLEAR: ts_output-compid, ifctr_id.
*                          IF NOT t_output-devclass IS INITIAL.
**    IF NOT ts_output-devclass IS INITIAL.
*                            SELECT SINGLE component FROM tdevc INTO ifctr_id
*                            WHERE devclass EQ t_output-devclass.
**            SELECT SINGLE component FROM tdevc INTO ifctr_id
**      WHERE devclass EQ ts_output-devclass.
*                              IF sy-subrc EQ 0.
*                                SELECT SINGLE ps_posid FROM df14l INTO t_output-compid
*                                WHERE fctr_id EQ ifctr_id.
**                SELECT SINGLE ps_posid FROM df14l INTO ts_output-compid
**        WHERE fctr_id EQ ifctr_id.
*                                ENDIF.
*                              ENDIF.
*                              CLEAR: t_output-cnam, t_output-cdat, t_output-cnamod, t_output-cdatmod.
**    CLEAR: ts_output-cnam, ts_output-cdat, ts_output-cnamod, ts_output-cdatmod.
*                              SELECT SINGLE cnam cdat unam udat
*                              FROM trdir INTO (t_output-cnam,t_output-cdat,t_output-cnamod,t_output-cdatmod)
*                              WHERE name EQ t_output-ztcode.
**        SELECT SINGLE cnam cdat unam udat
**    FROM trdir INTO (ts_output-cnam,ts_output-cdat,ts_output-cnamod,ts_output-cdatmod)
**    WHERE name EQ ts_output-ztcode.
** Development class description
*                                CLEAR t_output-desclass.
**    CLEAR ts_output-desclass.
*                                SELECT SINGLE ctext FROM tdevct INTO t_output-desclass
*                                WHERE devclass EQ t_output-devclass AND
*                                spras EQ sy-langu.
**        SELECT SINGLE ctext FROM tdevct INTO ts_output-desclass
**    WHERE devclass EQ ts_output-devclass AND
**    spras EQ sy-langu.
** For report search transactions code related
*                                  CLEAR: iconta, search_trsn. ", it_tstcp,.
*                                  CONCATENATE '%D_SREPOVARI-REPORT=' t_output-ztcode '%' INTO search_trsn.
**    CONCATENATE '%D_SREPOVARI-REPORT=' ts_output-ztcode '%' INTO search_trsn.
*                                  CONDENSE search_trsn NO-GAPS.
*                                  CLEAR: tstcp, t_output-zrepnm, t_output-zdesrepnm, it_tstcp.
**    CLEAR: tstcp, ts_output-zrepnm, ts_output-zdesrepnm, it_tstcp.
*                                  READ TABLE t_elcod WITH KEY ztcode = t_output-ztcode.
***    CHECK sy-subrc NE 0. ""If object code founded, it's a report with no association
**        READ TABLE t_elcod WITH KEY ztcode = ts_output-ztcode.
*                                  CHECK sy-subrc NE 0. ""If object code founded, it's a report with no association
*                                  READ TABLE it_tstcp WITH KEY tcode = t_output-ztcode.
**    READ TABLE it_tstcp WITH KEY tcode = ts_output-ztcode.
*                                  IF sy-subrc EQ 0.
*                                    t_output-zrepnm = it_tstcp-zrepnm.
*                                    t_output-zdesrepnm = it_tstcp-zdesrepnm.
**        ts_output-zrepnm = it_tstcp-zrepnm.
**      ts_output-zdesrepnm = it_tstcp-zdesrepnm.
*                                  ELSE.
*                                    SELECT SINGLE * FROM tstcp WHERE param LIKE search_trsn.
*                                      IF sy-subrc EQ 0.
*                                        t_output-zrepnm = tstcp-tcode.
**        ts_output-zrepnm = tstcp-tcode.
*                                        CLEAR t_output-zdesrepnm.
**        CLEAR ts_output-zdesrepnm.
*                                        SELECT SINGLE ttext FROM tstct INTO t_output-zdesrepnm
*                                        WHERE tcode EQ t_output-zrepnm AND
*                                        sprsl EQ sy-langu.
**                SELECT SINGLE ttext FROM tstct INTO ts_output-zdesrepnm
**        WHERE tcode EQ ts_output-zrepnm AND
**        sprsl EQ sy-langu.
*                                          SELECT SINGLE * FROM tstcp WHERE param LIKE search_trsn AND
*                                          tcode NE tstcp-tcode.
*                                            IF sy-subrc EQ 0.
*                                              t_output-zrepnm = TEXT-i01.
**          ts_output-zrepnm = TEXT-i01.
*                                              t_output-zdesrepnm = TEXT-i02.
**          ts_output-zdesrepnm = TEXT-i02.
*                                              it_tstcp-tcode = t_output-ztcode.
**          it_tstcp-tcode = ts_output-ztcode.
*                                            ELSE.
*                                              it_tstcp-tcode = tstcp-tcode.
*                                            ENDIF.
*                                            it_tstcp-zrepnm = t_output-zrepnm.
**        it_tstcp-zrepnm = ts_output-zrepnm.
*                                            it_tstcp-zdesrepnm = t_output-zdesrepnm.
**        it_tstcp-zdesrepnm = ts_output-zdesrepnm.
*                                            APPEND it_tstcp.
*                                          ELSE.
*                                            t_elcod-ztcode = t_output-ztcode.
**        t_elcod-ztcode = ts_output-ztcode.
*                                            APPEND t_elcod.
*                                          ENDIF.
*                                        ENDIF.
*                                      ENDIF.
*  ENDFORM.
**&---------------------------------------------------------------------*
**&---------------------------------------------------------------------*
**& Form excel_transaction_usage
**&---------------------------------------------------------------------*
*  FORM excel_transaction_usage .
**&------------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&------------------------------------------------------------------------*
*    " Check if a folder is selected
*    IF lv_folder IS NOT INITIAL. " User selected a folder
*      " Construct the full path of the file in the selected folder
*      CONCATENATE lv_folder '\'lv_filename '(Transaction_Usage)' '.xls' INTO lv_path.
*
*      " Check if the file exists in the selected folder
*      CALL METHOD cl_gui_frontend_services=>file_exist
*        EXPORTING
*          file                 = lv_path
*        RECEIVING
*          result               = lv_found
*        EXCEPTIONS
*          cntl_error           = 1
*          error_no_gui         = 2
*          wrong_parameter      = 3
*          not_supported_by_gui = 4
*          OTHERS               = 5.
*
*      IF lv_found = 'X'.
*        lv_rc = '1'.
*        GET TIME.
*        lv_date = sy-datum.
*        lv_time = sy-uzeit.
*        lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*        CONCATENATE lv_path  '_' lv_date '_' lv_time '.xls' INTO lv_path.
*      ENDIF.
*    ELSE.
*      IF p_f_path CS '.xls'.
*        lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*        CONCATENATE lv_path '(Transaction_Usage)'  '.xls' INTO lv_path.
*      ELSE.
*        CONCATENATE p_f_path '(Transaction_Usage)'  '.xls' INTO lv_path.
*      ENDIF.
*    ENDIF.
*
*    IF lv_found IS INITIAL.
*      " File not found in the selected folder, handle as needed
*      lv_rc = '0'.
*    ENDIF.
*
**&---------------------------------------------------------------------*
**& Downloading data to excel
**&----------------------------------------------------------------------*
*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_path
*        filetype                = 'ASC'
**       APPEND                  = ' '
*        write_field_separator   = 'X'
*      TABLES
*        data_tab                = f_output
*        fieldnames              = it_heading_st03n
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*
*  ENDFORM.
**&---------------------------------------------------------------------*
**& Form Fetch_Merge
**&---------------------------------------------------------------------*
*  FORM Fetch_Merge .
*
*    SELECT * FROM agr_tcodes INTO TABLE lt_data_tcodes WHERE agr_name IN s_r_name.
*
**    LOOP AT lt_data_tcodes INTO DATA(ls_data).
**      ls_data-tcode = ls_data-tcode.
**      APPEND ls_data TO lt_agr_tcodes.
**    ENDLOOP.
*
*      LOOP AT lt_data_tcodes INTO ls_data_tcodes .
**  LOOP AT t_output INTO ts_output.
*        ls_agr_tcodes-tcode = ls_data_tcodes-tcode.
*        APPEND ls_agr_tcodes TO lt_agr_tcodes.
**      DELETE ADJACENT DUPLICATES FROM lt_agr_tcodes COMPARING tcode.
*      ENDLOOP.
*
*
*
*      APPEND LINES OF lt_agr_tcodes TO f_output.
*
*
**&------------------------------------------------------------------------*
**& Checking File name exists or not, if exists same filename concatinating
**with number
**&------------------------------------------------------------------------*
*      " Check if a folder is selected
*      IF lv_folder IS NOT INITIAL. " User selected a folder
*        " Construct the full path of the file in the selected folder
*        CONCATENATE lv_folder '\'lv_filename '(Transaction_Merge)' '.csv' INTO lv_path.
*
*        " Check if the file exists in the selected folder
*        CALL METHOD cl_gui_frontend_services=>file_exist
*          EXPORTING
*            file                 = lv_path
*          RECEIVING
*            result               = lv_found
*          EXCEPTIONS
*            cntl_error           = 1
*            error_no_gui         = 2
*            wrong_parameter      = 3
*            not_supported_by_gui = 4
*            OTHERS               = 5.
*
*        IF lv_found = 'X'.
*          lv_rc = '1'.
*          GET TIME.
*          lv_date = sy-datum.
*          lv_time = sy-uzeit.
*          lv_path = substring( val = lv_path  len = strlen( lv_path ) - 4  ).
*          CONCATENATE lv_path  '_' lv_date '_' lv_time '.csv' INTO lv_path.
*        ENDIF.
*      ELSE.
*        IF p_f_path CS '.csv'.
*          lv_path = substring( val = p_f_path  len = strlen( p_f_path ) - 4  ).
*          CONCATENATE lv_path '(Transaction_Merge)'  '.csv' INTO lv_path.
*        ELSE.
*          CONCATENATE p_f_path '(Transaction_Merge)'  '.csv' INTO lv_path.
*        ENDIF.
*      ENDIF.
*
*      IF lv_found IS INITIAL.
*        " File not found in the selected folder, handle as needed
*        lv_rc = '0'.
*      ENDIF.
**&---------------------------------------------------------------------*
**& Downloading data
**&---------------------------------------------------------------------*
*
*      CALL FUNCTION 'GUI_DOWNLOAD'
*        EXPORTING
**         BIN_FILESIZE            =
*          filename                = lv_path
*          filetype                = 'ASC'
**         APPEND                  = ' '
*          write_field_separator   = 'X'
*        TABLES
*          data_tab                = f_output
**         fieldnames              = it_heading_st03n
*        EXCEPTIONS
*          file_write_error        = 1
*          no_batch                = 2
*          gui_refuse_filetransfer = 3
*          invalid_type            = 4
*          no_authority            = 5
*          unknown_error           = 6
*          header_not_allowed      = 7
*          separator_not_allowed   = 8
*          filesize_not_allowed    = 9
*          header_too_long         = 10
*          dp_error_create         = 11
*          dp_error_send           = 12
*          dp_error_write          = 13
*          unknown_dp_error        = 14
*          access_denied           = 15
*          dp_out_of_memory        = 16
*          disk_full               = 17
*          dp_timeout              = 18
*          file_not_found          = 19
*          dataprovider_exception  = 20
*          control_flush_error     = 21
*          OTHERS                  = 22.
*
*  ENDFORM.
**&---------------------------------------------------------------------*
**& Form Fetch_ALV_Merge
**&---------------------------------------------------------------------*
*  FORM Fetch_ALV_Merge .
*
*    DATA: o_splitter_main TYPE REF TO cl_gui_splitter_container.
*    DATA: o_container_top TYPE REF TO cl_gui_container.
*    DATA: o_container_bottom TYPE REF TO cl_gui_container.
*
*
**set new splitter container
*
*    o_splitter_main = NEW #( parent    = cl_gui_container=>default_screen
*                                        no_autodef_progid_dynnr = abap_true
*                                        rows = 2
*                                        columns = 1 ).
*    o_container_top  = o_splitter_main->get_container( row = 1 column = 1 ).
*    o_container_bottom = o_splitter_main->get_container( row = 2 column = 1 ).
*
*    DATA: o_salv_top TYPE REF TO cl_salv_table.
*    cl_salv_table=>factory( EXPORTING
*                                   r_container = o_container_top
*                            IMPORTING
*                                   r_salv_table = o_salv_top
*                            CHANGING
*                                   t_table = t_output[] ).
*
*    o_salv_top->get_functions( )->set_all( abap_true ).
*    o_salv_top->get_columns( )->set_optimize( abap_true ).
*    o_salv_top->get_display_settings( )->set_list_header( 'List of T-Codes in ST03N' ).
*    o_salv_top->get_display_settings( )->set_striped_pattern( abap_true ).
*    o_salv_top->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
*
*    DATA: lr_columns1 TYPE REF TO cl_salv_columns_table,
*          lr_column1  TYPE REF TO cl_salv_column_table.
*    lr_columns1 = o_salv_TOP->get_columns( ).
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'MANDT' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'NMACCOUNT' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'DDTEXT' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'TYPELEM' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'ZLNCHT' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'ZREPNM' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'ZDESREPNM' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'DEVCLASS' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'DESCLASS' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'COMPID' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'CNAM' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'CDAT' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'CNAMOD' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*
*    TRY.
*        lr_column1 ?= lr_columns1->get_column( 'CDATMOD' ).
*        lr_column1->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*    o_salv_top->display( ).
**
*
*
*************************************************************************
*
*    DATA: o_salv_bottom TYPE REF TO cl_salv_table.
*    cl_salv_table=>factory( EXPORTING
*                                   r_container = o_container_bottom
*                            IMPORTING
*                                   r_salv_table = o_salv_bottom
*                            CHANGING
*                                   t_table = lt_data_tcodes[] ).
*
*    o_salv_bottom->get_functions( )->set_all( abap_true ).
*    o_salv_bottom->get_columns( )->set_optimize( abap_true ).
*    o_salv_bottom->get_display_settings( )->set_list_header( 'List of T-Codes and Security Roles' ).
*    o_salv_bottom->get_display_settings( )->set_striped_pattern( abap_true ).
*    o_salv_bottom->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
*
*
*
*    DATA: lr_columns TYPE REF TO cl_salv_columns_table,
*          lr_column  TYPE REF TO cl_salv_column_table.
*    lr_columns = o_salv_bottom->get_columns( ).
*
*    TRY.
*        lr_column ?= lr_columns->get_column( 'MANDT' ).
*        lr_column->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*
*    TRY.
*        lr_column ?= lr_columns->get_column( 'EXCLUDE' ).
*        lr_column->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*    TRY.
*        lr_column ?= lr_columns->get_column( 'DIRECT' ).
*        lr_column->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*    TRY.
*        lr_column ?= lr_columns->get_column( 'INHERITED' ).
*        lr_column->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*    TRY.
*        lr_column ?= lr_columns->get_column( 'FOLDER' ).
*        lr_column->set_visible(
*            value = if_salv_c_bool_sap=>false
*        ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*
*    o_salv_bottom->display( ).
*
*    WRITE: space.
*
*  ENDFORM.
**&---------------------------------------------------------------------*
**& Form redirect_to_external_link
**&---------------------------------------------------------------------*
*  FORM redirect_to_external_link .
*
*    DATA: lv_url TYPE c LENGTH 100.
*
*
**    Assign your external link to the lv_url variable
*    lv_url = 'https://fioriappslibrary.hana.ondemand.com/sap/fix/externalViewer/#wizard'.
*
*
*    CALL FUNCTION 'CALL_BROWSER'
*      EXPORTING
*        url                    = lv_url
*        new_window             = 'X'
*      EXCEPTIONS
*        frontend_not_supported = 1
*        frontend_error         = 2
*        access_denied          = 3
*        OTHERS                 = 4.
*
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.
*  ENDFORM.
**&---------------------------------------------------------------------*
**& Form Upload_Tcodes
**&---------------------------------------------------------------------*
**& text
**&---------------------------------------------------------------------*
**& -->  p1        text
**& <--  p2        text
**&---------------------------------------------------------------------*
*  FORM Upload_Tcodes .
*
*    DATA:  lv1_file TYPE string.
*    lv1_file = P1_file.
*
*    CALL FUNCTION 'GUI_UPLOAD'
*      EXPORTING
*        filename                = lv1_file
*        filetype                = 'ASC'
*        has_field_separator     = 'X'
*      TABLES
*        data_tab                = lt_tcode
*      EXCEPTIONS
*        file_open_error         = 1
*        file_read_error         = 2
*        no_batch                = 3
*        gui_refuse_filetransfer = 4
*        invalid_type            = 5
*        no_authority            = 6
*        unknown_error           = 7
*        bad_data_format         = 8
*        header_not_allowed      = 9
*        separator_not_allowed   = 10
*        header_too_long         = 11
*        unknown_dp_error        = 12
*        access_denied           = 13
*        dp_out_of_memory        = 14
*        disk_full               = 15
*        dp_timeout              = 16
*        OTHERS                  = 17.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.
**&---------------------------------------------------------------------*
**select statement
**&---------------------------------------------------------------------*
*
*    SELECT  tcode agr_name
*       FROM agr_tcodes
*       INTO TABLE lt_roles
*    FOR ALL ENTRIES IN lt_tcode
*    WHERE tcode = lt_tcode-tcode
*      AND agr_name LIKE 'Z%' OR agr_name LIKE 'Y%'.
*
*      LOOP AT lt_tcode INTO DATA(lw_tcode).
*        w1_outtab-tcode =  lw_tcode-tcode.
*        LOOP AT lt_roles INTO DATA(lw_roles) WHERE tcode = lw_tcode-tcode.
*          w1_outtab-agr_name =  lw_roles-agr_name.
*          APPEND w1_outtab TO f1_outtab.
*        ENDLOOP.
*      ENDLOOP.
*
**&---------------------------------------------------------------------*
**Build field catalog
**&---------------------------------------------------------------------*
*
*      wa1_fieldcat-fieldname  = 'tcode'.    " Fieldname in the data table
*      wa1_fieldcat-seltext_m  = 'Transaction Code'.    " Column description in the output
*      APPEND wa1_fieldcat TO it1_fieldcat.
*
*      wa1_fieldcat-fieldname  = 'Agr_name'.    " Fieldname in the data table
*      wa1_fieldcat-seltext_m  = 'Security Roles'.    " Column description in the output
*      APPEND wa1_fieldcat TO it1_fieldcat.
*
**&---------------------------------------------------------------------*
**ALV Display
**&---------------------------------------------------------------------*
*
**Pass data and field catalog to ALV function module to display ALV list
*      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*        EXPORTING
*          it_fieldcat   = it1_fieldcat
*        TABLES
*          t_outtab      = f1_outtab
*        EXCEPTIONS
*          program_error = 1
*          OTHERS        = 2.
*  ENDFORM.
**&---------------------------------------------------------------------*
**&---------------------------------------------------------------------*
