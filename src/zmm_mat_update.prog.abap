*-----------------------------*
*  Report ZMM_MAT_UPDATE       *
*-----------------------------*

REPORT ZMM_MAT_UPDATE.
TABLES: mara.

DATA gv_dummy TYPE char10.

TYPES : BEGIN OF ty_matnr ,
         matnr type matnr ,
        END OF ty_matnr .

DATA: lt_file TYPE TABLE OF string,
      ls_file TYPE string,
      lt_mat  TYPE TABLE OF ty_matnr,
      ls_mat  TYPE ty_matnr,
      lt_mara TYPE TABLE OF mara,
      ls_mara TYPE mara.

PARAMETERS: p_file TYPE rlgrap-filename.

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

SORT lt_mara BY matnr.

DELETE ADJACENT DUPLICATES FROM lt_mara COMPARING matnr.

LOOP AT lt_mara INTO ls_mara.
  AT NEW matnr.
    WRITE: / 'Processing Material:', ls_mara-matnr.
  ENDAT.

  READ TABLE lt_mara WITH KEY matnr = ls_mara-matnr
    BINARY SEARCH INTO ls_mara.

  "------------------------------
  " 7. Call BAPI to update material master
  "------------------------------
  PERFORM update_material USING ls_mara-matnr.
ENDLOOP.

FORM update_material USING pv_matnr TYPE matnr.

  DATA: ls_head   TYPE BAPIMATHEAD,
        ls_client TYPE bapi_marc,
        lt_return TYPE TABLE OF bapiret2,
        ls_return TYPE bapiret2.

  ls_head-matl_type  = 'FERT'.
  ls_head-ind_sector = 'M'.

  CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
    EXPORTING
      headdata       = ls_head
    TABLES
      returnmessages = lt_return.

  LOOP AT lt_return INTO ls_return.
    WRITE: / ls_return-message. "#EC CI_FLDEXT_OK[2610650]
  ENDLOOP.


ENDFORM.
