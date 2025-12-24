FUNCTION zfm_mm_update_po_analysis.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_EBELN) TYPE  EBELN
*"  EXPORTING
*"     REFERENCE(EV_STATUS) TYPE  CHAR20
*"  EXCEPTIONS
*"      NOT_FOUND
*"      UPDATE_FAILED
*"----------------------------------------------------------------------

  DATA: lt_ekpo TYPE TABLE OF ekpo,
        ls_ekpo TYPE ekpo,
        ls_ekko TYPE ekko,
        lt_mara TYPE TABLE OF mara,
        ls_mara TYPE mara,
        lt_mbew TYPE TABLE OF mbew,
        ls_mbew TYPE mbew,
        lt_marc TYPE TABLE OF marc,
        ls_marc TYPE marc,
        lt_t023 TYPE TABLE OF t023,
        ls_t023 TYPE t023,
        lt_t001w TYPE TABLE OF t001w,
        ls_t001w TYPE t001w,
        ls_po    TYPE zmm_po_analysis .

  "---------------------------------------------------------------
  " 1. Read PO Header (EKKO)
  "---------------------------------------------------------------
  SELECT SINGLE * FROM ekko INTO ls_ekko
    WHERE ebeln = iv_ebeln.

  IF sy-subrc <> 0.
    RAISE not_found.
  ENDIF.

  "---------------------------------------------------------------
  " 2. Read PO Items (EKPO)
  "---------------------------------------------------------------
  SELECT * FROM ekpo
    INTO TABLE lt_ekpo
    WHERE ebeln = iv_ebeln.

  IF lt_ekpo IS INITIAL.
    RAISE not_found.
  ENDIF.

  "---------------------------------------------------------------
  " 3. Read MARA, MBEW, MARC, T023, T001W
  "---------------------------------------------------------------
  SELECT * FROM mara INTO TABLE lt_mara
    FOR ALL ENTRIES IN lt_ekpo
    WHERE matnr = lt_ekpo-matnr.

  SELECT * FROM mbew INTO TABLE lt_mbew
    FOR ALL ENTRIES IN lt_ekpo
    WHERE matnr = lt_ekpo-matnr.

  SELECT * FROM marc INTO TABLE lt_marc
    FOR ALL ENTRIES IN lt_ekpo
    WHERE matnr = lt_ekpo-matnr.

  SELECT * FROM t023 INTO TABLE lt_t023
    FOR ALL ENTRIES IN lt_mara
    WHERE matkl = lt_mara-matkl.

  SELECT * FROM t001w INTO TABLE lt_t001w
    FOR ALL ENTRIES IN lt_ekpo
    WHERE werks = lt_ekpo-werks.

  "---------------------------------------------------------------
  " 4. Perform Calculations
  "---------------------------------------------------------------
  DATA: lv_total_qty TYPE menge_d,
        lv_total_value TYPE wrbtr,
        lv_avg_price TYPE p DECIMALS 2,
        lv_unique_mat TYPE i,
        lv_unique_plant TYPE i,
        lv_high_value_item TYPE wrbtr,
        lv_low_value_item TYPE wrbtr.

  CLEAR: lv_total_qty, lv_total_value, lv_avg_price,
         lv_unique_mat, lv_unique_plant,
         lv_high_value_item, lv_low_value_item.

  LOOP AT lt_ekpo INTO ls_ekpo.

    " Total quantity
    lv_total_qty = lv_total_qty + ls_ekpo-menge.

    " Total PO value
    lv_total_value = lv_total_value + ( ls_ekpo-menge * ls_ekpo-netpr ).

    " Track high/low value items
    DATA(lv_item_value) = ls_ekpo-menge * ls_ekpo-netpr.
    IF lv_high_value_item < lv_item_value.
      lv_high_value_item = lv_item_value.
    ENDIF.
    IF lv_low_value_item = 0 OR lv_low_value_item > lv_item_value.
      lv_low_value_item = lv_item_value.
    ENDIF.

  ENDLOOP.

  " Unique materials
  SORT lt_ekpo BY matnr.
  DELETE ADJACENT DUPLICATES FROM lt_ekpo COMPARING matnr.
  lv_unique_mat = lines( lt_ekpo ).

  " Unique plants
  SORT lt_ekpo BY werks.
  DELETE ADJACENT DUPLICATES FROM lt_ekpo COMPARING werks.
  lv_unique_plant = lines( lt_ekpo ).

  " Average price
  IF lv_total_qty > 0.
    lv_avg_price = lv_total_value / lv_total_qty.
  ENDIF.

  "---------------------------------------------------------------
  " 5. Prepare Z-table structure
  "---------------------------------------------------------------
  DATA ls_zmm TYPE zmm_po_analysis.

  ls_zmm-ebeln          = iv_ebeln.
  ls_zmm-bsart          = ls_ekko-bsart.
  ls_zmm-lifnr          = ls_ekko-lifnr.
  ls_zmm-bedat          = ls_ekko-bedat.
  ls_zmm-total_qty      = lv_total_qty.
  ls_zmm-total_value    = lv_total_value.
  ls_zmm-avg_price      = lv_avg_price.
  ls_zmm-unique_mat     = lv_unique_mat.
  ls_zmm-unique_plant   = lv_unique_plant.
  ls_zmm-high_value     = lv_high_value_item.
  ls_zmm-low_value      = lv_low_value_item.
  ls_zmm-last_update    = sy-datum.

  "---------------------------------------------------------------
  " 6. Insert or Update Z-table
  "---------------------------------------------------------------
  SELECT SINGLE * FROM zmm_po_analysis into ls_po
    WHERE ebeln = iv_ebeln.

  IF sy-subrc = 0.
    UPDATE zmm_po_analysis FROM ls_zmm.
    IF sy-subrc <> 0.
      RAISE update_failed.
    ENDIF.
    ev_status = 'UPDATED'.
  ELSE.
    INSERT zmm_po_analysis FROM ls_zmm.
    IF sy-subrc <> 0.
      RAISE update_failed.
    ENDIF.
    ev_status = 'CREATED'.
  ENDIF.

ENDFUNCTION.
