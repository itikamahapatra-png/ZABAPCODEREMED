*&---------------------------------------------------------------------*
*& Report ZTEST_CN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpassword_reset MESSAGE-ID zpassword.

TABLES usr01.
DATA: lt_return TYPE TABLE OF bapiret2,
      ls_return TYPE bapiret2,
      lw_user   TYPE bapibname-bapibname.

SELECT-OPTIONS: s_bname FOR usr01-bname.
PARAMETERS: p_passw TYPE zpassword.

TYPES: BEGIN OF ty_bname,
         bname TYPE xubname,
       END OF ty_bname.

DATA: lt_usr01   TYPE STANDARD TABLE OF usr01 WITH DEFAULT KEY,
      wa_usr01   TYPE usr01,
      lt_bnames  TYPE STANDARD TABLE OF ty_bname WITH DEFAULT KEY,
      ls_bname   TYPE ty_bname.

START-OF-SELECTION.

SELECT * FROM usr01 INTO TABLE lt_usr01 WHERE bname IN s_bname.
IF sy-subrc <> 0.
  WRITE: / 'No users found'.
ENDIF.

LOOP AT lt_usr01 INTO wa_usr01.
  ls_bname-bname = wa_usr01-bname.
  APPEND ls_bname TO lt_bnames.
ENDLOOP.

DELETE ADJACENT DUPLICATES FROM lt_bnames COMPARING bname.

DATA: lt_fieldcat TYPE slis_t_fieldcat_alv,
      ls_fieldcat TYPE slis_fieldcat_alv.
ls_fieldcat-fieldname = 'BNAME'.
APPEND ls_fieldcat TO lt_fieldcat.
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    it_fieldcat = lt_fieldcat
  TABLES
    t_outtab    = lt_bnames
  EXCEPTIONS
    program_error = 1
    OTHERS         = 2.

LOOP AT s_bname ASSIGNING FIELD-SYMBOL(<s>).
  SELECT SINGLE * FROM usr01 INTO wa_usr01 WHERE bname = <s>-low.
  IF sy-subrc = 0.
    WRITE: / 'User', wa_usr01-bname, 'exists'.
  ENDIF.
ENDLOOP.


DATA: lt_usr02 TYPE TABLE OF usr02 WITH EMPTY KEY.
SELECT * FROM usr02 INTO TABLE lt_usr02
  FOR ALL ENTRIES IN lt_bnames
  WHERE bname = lt_bnames-bname.

" Business logic (kept): reset password via BAPI -----------------------------
LOOP AT lt_bnames INTO ls_bname.
  lw_user = ls_bname-bname.
  CALL FUNCTION 'BAPI_USER_CHANGE'
    EXPORTING
      username  = lw_user
      password  = p_passw
      passwordx = 'X'
    TABLES
      return    = lt_return.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
ENDLOOP.

LOOP AT lt_return INTO ls_return.
  WRITE: / ls_return-message.
ENDLOOP.
