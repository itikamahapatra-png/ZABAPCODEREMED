*&---------------------------------------------------------------------*
*& Include          ZMM_MAT_UPDATE_TOP
*&---------------------------------------------------------------------*
*-------------------------------------------------------------*
* TOP Include
*-------------------------------------------------------------*

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
