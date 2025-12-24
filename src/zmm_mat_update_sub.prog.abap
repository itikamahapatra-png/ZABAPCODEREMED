*&---------------------------------------------------------------------*
*& Include          ZMM_MAT_UPDATE_SUB
*&---------------------------------------------------------------------*
*-------------------------------------------------------------*
* SUBROUTINES Include
*-------------------------------------------------------------*

FORM update_material USING pv_matnr TYPE matnr.

  DATA: ls_head   TYPE BAPIMATHEAD,
        ls_client TYPE bapi_marc,
        lt_return TYPE TABLE OF bapiret2,
        ls_return TYPE bapiret2.

  " Hardcoded values (ATC issue)
  ls_head-matl_type  = 'FERT'.
  ls_head-ind_sector = 'M'.

  CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
    EXPORTING
      headdata       = ls_head
    TABLES
      returnmessages = lt_return.

  LOOP AT lt_return INTO ls_return.
    WRITE: / ls_return-message.
  ENDLOOP.


ENDFORM.
