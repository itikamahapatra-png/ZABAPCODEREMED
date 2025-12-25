*&-----------------------------------------------------------------------*
*& Report ZSECURITY_BACKUP_PROG
*&-----------------------------------------------------------------------*
*&
*&-----------------------------------------------------------------------*
REPORT zsecurity_backup_prog_atc.


INCLUDE ZSECURITY_BACKUP_PROG_TOP_ATC.
*INCLUDE zsecurity_backup_prog_top.
INCLUDE ZSECURITY_BACKUP_PROG_SS_ATC.
*INCLUDE zsecurity_backup_prog_ss.
INCLUDE ZSECURITY_BACKUP_EVENTS_ATC.
*INCLUDE zsecurity_backup_prog_events.

*------------------------------------------------------------------------*
*------------------------------------------------------------------------*
AT SELECTION-SCREEN.

  CASE sscrfields-ucomm.
    WHEN 'P_BUTTON'.
      PERFORM redirect_to_external_link.
  ENDCASE.

*------------------------------------------------------------------------*
*------------------------------------------------------------------------*
INITIALIZATION.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      NAME   = ICON_EXECUTE_OBJECT
      TEXT   = 'execute'
*      INFO   = 'execute Report'
    IMPORTING
      RESULT = PB01
    EXCEPTIONS
      OTHERS = 0.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      NAME   = ICON_EXECUTE_OBJECT
      TEXT   = 'execute'
*      INFO   = 'execute Report'
    IMPORTING
      RESULT = PB02
    EXCEPTIONS
      OTHERS = 0.

 CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      NAME   = ICON_EXECUTE_OBJECT
      TEXT   = 'execute'
*      INFO   = 'execute Report'
    IMPORTING
      RESULT = PB03
    EXCEPTIONS
      OTHERS = 0.

 CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      NAME   = ICON_EXECUTE_OBJECT
      TEXT   = 'execute'
*      INFO   = 'execute Report'
    IMPORTING
      RESULT = PB04
    EXCEPTIONS
      OTHERS = 0.
*------------------------------------------------------------------------*
*------------------------------------------------------------------------*
START-OF-SELECTION.

  IF p1_file IS NOT INITIAL.
    PERFORM upload_tcodes.
  ELSEIF p_f_path IS NOT INITIAL.

    lv_filename = p_f_path.
    " Open file dialog to select folder path
    CALL METHOD cl_gui_frontend_services=>directory_browse
      EXPORTING
        window_title    = 'Select Folder'
      CHANGING
        selected_folder = lv_folder.

    PERFORM download.
  ELSE.
    MESSAGE 'Please Enter File path' TYPE 'I'.
  ENDIF.
