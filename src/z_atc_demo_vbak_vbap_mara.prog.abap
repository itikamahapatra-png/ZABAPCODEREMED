REPORT z_atc_demo_vbak_vbap_mara.

TABLES: vbak, vbap, mara, mbew, mvke, makt,mseg.

TYPES: BEGIN OF ty_sales,
         vbeln  TYPE vbak-vbeln,
         erdat  TYPE vbak-erdat,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         maktx  TYPE makt-maktx,
         mtart  TYPE mara-mtart,
         meins  TYPE mara-meins,
         mbrsh  TYPE mara-mbrsh,
         bwkey  TYPE mbew-bwkey,
         stprs  TYPE mbew-stprs,
         vkorg  TYPE mvke-vkorg,
         vtweg  TYPE mvke-vtweg,
         kwmeng TYPE vbap-kwmeng,
       END OF ty_sales.

DATA: lt_sales   TYPE STANDARD TABLE OF ty_sales WITH NON-UNIQUE KEY vbeln,
      ls_sales   TYPE ty_sales,
      lt_display TYPE STANDARD TABLE OF ty_sales.

"-------------------------------------------------------------
" SELECTION SCREEN
"-------------------------------------------------------------
SELECT-OPTIONS: so_vbeln FOR vbak-vbeln.

"-------------------------------------------------------------
" Additional MARA, MBEW, MVKE tables
"-------------------------------------------------------------
DATA: lt_mara TYPE TABLE OF mara,
      ls_mara TYPE mara,
      lt_mbew TYPE TABLE OF mbew,
      ls_mbew TYPE mbew,
      lt_mvke TYPE TABLE OF mvke,
      ls_mvke TYPE mvke.

"-------------------------------------------------------------
" SELECT FROM VBAK + VBAP + MAKT
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
  INTO CORRESPONDING FIELDS OF TABLE lt_sales
  WHERE a~vbeln IN so_vbeln.

IF sy-subrc <> 0.
  MESSAGE 'No sales orders found' TYPE 'I'.
  EXIT.
ENDIF.


SELECT * FROM mara INTO TABLE lt_mara
         FOR ALL ENTRIES IN lt_sales
         WHERE matnr = lt_sales-matnr.


SELECT * FROM mbew INTO TABLE lt_mbew
         FOR ALL ENTRIES IN lt_sales
         WHERE matnr = lt_sales-matnr.


SELECT * FROM mvke INTO TABLE lt_mvke
         FOR ALL ENTRIES IN lt_sales
         WHERE matnr = lt_sales-matnr.

DELETE ADJACENT DUPLICATES FROM lt_sales COMPARING vbeln.

LOOP AT lt_sales INTO ls_sales.


  READ TABLE lt_mara INTO ls_mara WITH KEY matnr = ls_sales-matnr.
   " Move additional fields
  IF sy-subrc = 0.
    ls_sales-mtart = ls_mara-mtart.
    ls_sales-meins = ls_mara-meins.
    ls_sales-mbrsh = ls_mara-mbrsh.
  ENDIF.

  READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = ls_sales-matnr .
    IF sy-subrc = 0.
    ls_sales-bwkey = ls_mbew-bwkey.
    ls_sales-stprs = ls_mbew-stprs.
  ENDIF.

  READ TABLE lt_mvke INTO ls_mvke WITH KEY matnr = ls_sales-matnr .

  IF sy-subrc = 0.
    ls_sales-vkorg = ls_mvke-vkorg.
    ls_sales-vtweg = ls_mvke-vtweg.
  ENDIF.

  MODIFY lt_sales FROM ls_sales.

ENDLOOP.

"-------------------------------------------------------------
" PREPARE DATA FOR ALV
"-------------------------------------------------------------
lt_display = lt_sales.

"-------------------------------------------------------------
" DISPLAY USING ALV
"-------------------------------------------------------------
DATA: lo_alv TYPE REF TO cl_salv_table.

cl_salv_table=>factory(
  IMPORTING
    r_salv_table = lo_alv
  CHANGING
    t_table      = lt_display
).

lo_alv->display( ).
