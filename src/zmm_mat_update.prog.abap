*&---------------------------------------------------------------------*
*& Report ZMM_MAT_UPDATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_MAT_UPDATE.


INCLUDE zmm_mat_update_top.


CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    filename = p_file
  TABLES
    data_tab = lt_file.


LOOP AT lt_file INTO ls_file.
  ls_mat = ls_file.
  APPEND ls_mat TO lt_mat.
ENDLOOP.


SELECT * FROM mara
  INTO TABLE lt_mara
  FOR ALL ENTRIES IN lt_mat
  WHERE matnr = lt_mat-matnr.


DELETE ADJACENT DUPLICATES FROM lt_mara COMPARING matnr.


LOOP AT lt_mara INTO ls_mara.

  AT NEW matnr.
    WRITE: / 'Processing Material:', ls_mara-matnr.
  ENDAT.

  READ TABLE lt_mara WITH KEY matnr = ls_mara-matnr
       BINARY SEARCH INTO ls_mara.

  "---------------------------------------------------------
  " 7. Call BAPI to update material master
  "---------------------------------------------------------
  PERFORM update_material USING ls_mara-matnr.

ENDLOOP.

INCLUDE zmm_mat_update_sub.
