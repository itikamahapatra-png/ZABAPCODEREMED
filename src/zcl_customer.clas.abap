class ZCL_CUSTOMER definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_DATAB type DATAB.
protected section.
private section.

  types:
    BEGIN OF ty_customer_hierarchy,
      hkunnr TYPE hkunnr_kh,
    END OF ty_customer_hierarchy .
  types:
    tt_customer_hierarchy TYPE STANDARD TABLE OF ty_customer_hierarchy .
  types:
    BEGIN OF ty_hierarchy_buffer,
      kndnr       TYPE kndnr,
      vtweg       TYPE vtweg,
      t_hierarchy TYPE STANDARD TABLE OF ty_customer_hierarchy WITH NON-UNIQUE KEY hkunnr,
    END OF ty_hierarchy_buffer .
  types:
    tt_hierarchy_buffer TYPE SORTED TABLE OF ty_hierarchy_buffer WITH UNIQUE KEY kndnr vtweg .
  types:
    BEGIN OF ty_knvh_list,
      kunnr  TYPE knvh-kunnr,
      vkorg  TYPE knvh-vkorg,
      vtweg  TYPE knvh-vtweg,
      spart  TYPE knvh-spart,
      hkunnr TYPE knvh-hkunnr,
      hvkorg TYPE knvh-hvkorg,
      hvtweg TYPE knvh-hvtweg,
      hspart TYPE knvh-hspart,
    END OF ty_knvh_list .
  types:
    tt_knvh_list TYPE STANDARD TABLE OF ty_knvh_list WITH NON-UNIQUE KEY kunnr vkorg vtweg spart .

  constants GC_KVGR1_03 type KVGR1 value '03' ##NO_TEXT.
  constants GC_KVGR1_04 type KVGR1 value '04' ##NO_TEXT.
  constants GC_KVGR1_05 type KVGR1 value '05' ##NO_TEXT.
  constants GC_MAX_LEVEL_P type I value 7 ##NO_TEXT.
  constants GC_MAX_LEVEL_C type I value 99 ##NO_TEXT.
  constants GC_VTWEG_00 type VTWEG value '00' ##NO_TEXT.
  constants GC_VTWEG_01 type VTWEG value '01' ##NO_TEXT.
  constants GC_VTWEG_02 type VTWEG value '02' ##NO_TEXT.
  constants GC_VTWEG_03 type VTWEG value '03' ##NO_TEXT.
  constants GC_VTWEG_04 type VTWEG value '04' ##NO_TEXT.
  constants GC_VTWEG_05 type VTWEG value '05' ##NO_TEXT.
  constants GC_VTWEG_06 type VTWEG value '06' ##NO_TEXT.
  constants GC_CUSTHIER_TYPE_A type HITYP_KH value 'A' ##NO_TEXT.
  data MV_MAX_LEVEL type I .
  data MV_DATAB type DATAB .
  data ST_HIERARCHY_BUFFER type TT_HIERARCHY_BUFFER .

  methods CHECK_CUSTOMER_SALES_DATA
    importing
      !IT_CUSTOMER_HIERARCHY type TT_CUSTOMER_HIERARCHY .
  methods GET_CUSTOMER_HIERARCHY
    exporting
      !ET_CUSTOMER_HIERARCHY type TT_CUSTOMER_HIERARCHY .
  methods GET_CUSTOMER_LIST
    importing
      !IV_CHILD_PARENT type ZFI0071947DE_CHILD_PARENT
      !IT_KNVH_LIST type TT_KNVH_LIST
    changing
      !CT_CUSTOMER_HIERARCHY type TT_CUSTOMER_HIERARCHY .
  methods GET_NEXT_CUSTOMER_LEVEL
    importing
      !IV_CHILD_PARENT type ZFI0071947DE_CHILD_PARENT
      !IS_KNVH type TY_KNVH_LIST
    changing
      !CV_LEVEL type I
      !CT_CUSTOMER_HIERARCHY type TT_CUSTOMER_HIERARCHY .
  methods GET_ACTUAL_LEVEL
    returning
      value(RT_KNVH_LIST) type TT_KNVH_LIST .
  methods GET_SALES_AREAS
    returning
      value(RT_RETURN) type ZFI0071947TT_SALES_AREA .
ENDCLASS.



CLASS ZCL_CUSTOMER IMPLEMENTATION.


  method CHECK_CUSTOMER_SALES_DATA.
  endmethod.


  method CONSTRUCTOR.
  endmethod.


  method GET_ACTUAL_LEVEL.
  endmethod.


  method GET_CUSTOMER_HIERARCHY.
  endmethod.


  method GET_CUSTOMER_LIST.
  endmethod.


  method GET_NEXT_CUSTOMER_LEVEL.
  endmethod.


  method GET_SALES_AREAS.
  endmethod.
ENDCLASS.
