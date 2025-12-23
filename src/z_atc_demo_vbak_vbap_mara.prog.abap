REPORT z_atc_demo_vbak_vbap_mara.

TABLES: vbak, vbap, mara.

TYPES: BEGIN OF ty_sales,
         vbeln TYPE vbak-vbeln,
         erdat TYPE vbak-erdat,
         posnr TYPE vbap-posnr,
         matnr TYPE vbap-matnr,
         maktx TYPE makt-maktx,
         kwmeng TYPE vbap-kwmeng,
       END OF ty_sales.

DATA: lt_sales   TYPE STANDARD TABLE OF ty_sales WITH NON-UNIQUE KEY vbeln,
      ls_sales   TYPE ty_sales,
      lt_display TYPE STANDARD TABLE OF ty_sales.

"-------------------------------------------------------------
" SELECTION SCREEN
"-------------------------------------------------------------
SELECT-OPTIONS: so_vbeln FOR vbak-vbeln.


DATA: lt_mara TYPE TABLE OF mara,
      ls_mara type mara.


"-------------------------------------------------------------
" SELECT FROM VBAK + VBAP + MARA
"-------------------------------------------------------------
SELECT a~vbeln
       a~erdat
       b~posnr
       b~matnr
       c~maktx
       b~kwmeng
  FROM vbak AS a
  INNER JOIN vbap AS b ON a~vbeln = b~vbeln
  LEFT JOIN makt AS c ON b~matnr = c~matnr
  INTO TABLE lt_sales
  WHERE a~vbeln IN so_vbeln.

IF sy-subrc <> 0.
  MESSAGE 'No sales orders found' TYPE 'I'.
  EXIT.
ENDIF.

SELECT * FROM mara INTO TABLE lt_mara
         FOR ALL ENTRIES IN lt_sales
         where matnr = lt_sales-matnr .



"-------------------------------------------------------------
" 2. DELETE ADJACENT DUPLICATES (ATC issue: table not sorted)
"-------------------------------------------------------------
DELETE ADJACENT DUPLICATES FROM lt_sales COMPARING vbeln.

"-------------------------------------------------------------
" 3. LOOP AT ... AT ... ENDAT (ATC issue: old grouping)
"-------------------------------------------------------------
LOOP AT lt_sales INTO ls_sales.
  READ TABLE lt_mara WITH KEY matnr = ls_sales-matnr BINARY SEARCH INTO ls_mara.

ENDLOOP.

"-------------------------------------------------------------
" PREPARE DATA FOR ALV
"-------------------------------------------------------------
lt_display = lt_sales.

"-------------------------------------------------------------
" DISPLAY USING ALV (CL_SALV_TABLE)
"-------------------------------------------------------------
DATA: lo_alv TYPE REF TO cl_salv_table.

cl_salv_table=>factory(
  IMPORTING
    r_salv_table = lo_alv
  CHANGING
    t_table      = lt_display
).

lo_alv->display( ).
