class ZCL_CUSTOMER definition
  public
  create public .

public section.

  data:
    lt_customers TYPE TABLE OF kna1 .
  data LS_CUSTOMER type KNA1 .
  data LV_LEVEL type I .
  data LV_DUMMY type STRING .           "ATC ERROR: unused variable

  methods CONSTRUCTOR .
  methods GET_DATA
    importing
      !IV_KUNNR type KUNNR
    exporting
      !EV_VALID type CHAR01
      !EV_MESSAGE type CHAR255 .
  methods CHECK_CUSTOMER_SALES_DATA
    importing
      !IV_KUNNR type KUNNR
    exporting
      !EV_VALID type CHAR01
      !EV_MESSAGE type CHAR255 .
  methods GET_CUSTOMER_HIERARCHY
    importing
      !IV_KUNNR type KUNNR
    exporting
      !EV_VALID type CHAR01
      !EV_MESSAGE type CHAR255
      !ET_HIERARCHY type ZKNVH_TT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CUSTOMER IMPLEMENTATION.


  method CONSTRUCTOR.
  endmethod.


METHOD get_customer_hierarchy.

  CLEAR: ev_valid, ev_message, et_hierarchy.

  "---------------------------------------------------------
  " 1. ATC ERROR: SELECT * (instead of field list)
  "---------------------------------------------------------
  SELECT * FROM kna1 INTO TABLE @DATA(lt_kna1)
    WHERE kunnr = @iv_kunnr.

  " ATC ERROR: Hard-coded MESSAGE + EXIT
  IF lt_kna1 IS INITIAL.
    MESSAGE 'Customer not found in KNA1' TYPE 'I'.
    EXIT.
  ENDIF.

  "---------------------------------------------------------
  " 2. ATC ERROR: FOR ALL ENTRIES without initial check
  "---------------------------------------------------------
  SELECT * FROM knvh INTO TABLE @et_hierarchy
    FOR ALL ENTRIES IN @lt_kna1
    WHERE kunnr = @lt_kna1-kunnr.

  " ATC ERROR: DELETE ADJACENT DUPLICATES without SORT
  DELETE ADJACENT DUPLICATES FROM et_hierarchy COMPARING HITYP KUNNR VKORG VTWEG SPART .

  " ATC ERROR: READ TABLE without BINARY SEARCH
  READ TABLE et_hierarchy INTO DATA(ls_hier) WITH KEY kunnr = iv_kunnr.

  IF sy-subrc <> 0.
    ev_valid   = abap_false.
    ev_message = |No hierarchy found for customer { iv_kunnr }|.
    RETURN.
  ENDIF.

  "---------------------------------------------------------
  " 3. Success
  "---------------------------------------------------------
  ev_valid   = abap_true.
  ev_message = |Hierarchy retrieved for customer { iv_kunnr }|.

ENDMETHOD.


  method GET_DATA.

  CLEAR: ev_valid, ev_message.

  "---------------------------------------------------------
  " 1. Validate input
  "---------------------------------------------------------
  IF iv_kunnr IS INITIAL.
    ev_valid   = abap_false.
    ev_message = 'Customer number is empty'.
    RETURN.
  ENDIF.

  "---------------------------------------------------------
  " 2. Read general customer data (KNA1)
  "---------------------------------------------------------
  SELECT SINGLE *
    FROM kna1
    WHERE kunnr = @iv_kunnr
    INTO @DATA(ls_kna1).

  IF sy-subrc <> 0.
    ev_valid   = abap_false.
    ev_message = |Customer { iv_kunnr } not found in KNA1|.
    RETURN.
  ENDIF.

  "---------------------------------------------------------
  " 3. Read sales area data (KNVV)
  "---------------------------------------------------------
  SELECT SINGLE *
    FROM knvv
    WHERE kunnr = @iv_kunnr
    INTO @DATA(ls_knvv).

  IF sy-subrc <> 0.
    ev_valid   = abap_false.
    ev_message = |Customer { iv_kunnr } has no sales area data in KNVV|.
    RETURN.
  ENDIF.


  "---------------------------------------------------------
  " 5. Success
  "---------------------------------------------------------
  ev_valid   = abap_true.
  ev_message = |Customer { iv_kunnr } data retrieved successfully|.

ENDMETHOD.


  method CHECK_CUSTOMER_SALES_DATA.

  CLEAR ev_valid.
  CLEAR ev_message.

  "---------------------------------------------------------
  " 1. Validate input
  "---------------------------------------------------------
  IF iv_kunnr IS INITIAL.
    ev_valid  = abap_false.
    ev_message = 'Customer number is empty'.
    RETURN.
  ENDIF.

  "---------------------------------------------------------
  " 2. Read KNVV for this customer
  "---------------------------------------------------------
  SELECT *
    FROM knvv
    WHERE kunnr = @iv_kunnr
    INTO TABLE @DATA(lt_knvv).

  IF lt_knvv IS INITIAL.
    ev_valid  = abap_false.
    ev_message = |Customer { iv_kunnr } has no sales area data in KNVV|.
    RETURN.
  ENDIF.

  "---------------------------------------------------------
  " 3. Perform business validation
  "---------------------------------------------------------
  LOOP AT lt_knvv INTO DATA(ls_knvv).

    IF ls_knvv-vkorg IS INITIAL.
      ev_valid  = abap_false.
      ev_message = |Customer { iv_kunnr } has missing Sales Org (VKORG)|.
      RETURN.
    ENDIF.

    IF ls_knvv-vtweg IS INITIAL.
      ev_valid  = abap_false.
      ev_message = |Customer { iv_kunnr } has missing Distribution Channel (VTWEG)|.
      RETURN.
    ENDIF.

    IF ls_knvv-spart IS INITIAL.
      ev_valid  = abap_false.
      ev_message = |Customer { iv_kunnr } has missing Division (SPART)|.
      RETURN.
    ENDIF.

  ENDLOOP.

  "---------------------------------------------------------
  " 4. Everything OK
  "---------------------------------------------------------
  ev_valid  = abap_true.
  ev_message = |Customer { iv_kunnr } is valid in KNVV|.

ENDMETHOD.
ENDCLASS.
