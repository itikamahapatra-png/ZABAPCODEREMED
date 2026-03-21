*&---------------------------------------------------------------------*
*& Include          ZSECURITY_BACKUP_PROG_TOP
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*  Tables
*----------------------------------------------------------------------*
TABLES: agr_define,
        agr_agrs,
        agr_1251,
        agr_tcodes,
        agr_1250,
        agr_users,
        usobt,
        usobx,
        usobx_c,
        usobt_c,
        zworkload, v_usr_name, tstcp, trdirt, tstct,
        tadir, tdevc, df14l, tstc, trdir, tdevct,
        sscrfields.
TYPE-POOLS: ICON.
*----------------------------------------------------------------------*
*  Structures
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_agr_1251,
         mandt    TYPE  symandt,
         agr_name TYPE  agr_name,
         counter  TYPE  menu_num_6,
         object   TYPE  agobject,
         auth     TYPE  agauth,
         variant  TYPE  tpr_vari,
         field    TYPE  agrfield,
         low      TYPE  agval,
         high     TYPE  agval,
         modified TYPE  tpr_st_mod,
         deleted  TYPE  tpr_st_del,
         copied   TYPE  tpr_st_cop,
         neu      TYPE  tpr_st_new,
         node     TYPE  seu_id,
       END OF  ty_agr_1251.

TYPES: BEGIN OF ty_agr_agrs,
         mandt      TYPE  symandt,
         agr_name   TYPE  agr_name_c,
         child_agr  TYPE  child_agr,
         attributes TYPE  active_flg,
       END OF  ty_agr_agrs.

TYPES: BEGIN OF ty_agr_define,
         mandt      TYPE  symandt,
         agr_name   TYPE  agr_name,
         parent_agr TYPE  par_agr,
         create_usr TYPE  syuname,
         create_dat TYPE  menu_date,
         create_tim TYPE  menu_time,
         create_tmp TYPE  rstimestmp,
         change_usr TYPE  syuname,
         change_dat TYPE  menu_date,
         change_tim TYPE  menu_time,
         change_tmp TYPE  rstimestmp,
         attributes TYPE  menu_attr,
       END OF  ty_agr_define.

TYPES: BEGIN OF ty_agr_tcodes,
         mandt     TYPE	 symandt,
         agr_name  TYPE  agr_name,
         type      TYPE  reporttype,
         tcode     TYPE	 agxreport,
         exclude   TYPE	 agr_excl,
         direct    TYPE  agr_dire,
         inherited TYPE	 agr_inhe,
         folder    TYPE  menu_num_5,
       END OF  ty_agr_tcodes.

TYPES: BEGIN OF ty_agr_1250,
         mandt    TYPE  symandt,
         agr_name TYPE  agr_name,
         counter  TYPE  menu_num_6,
         object   TYPE  xuobject,
         auth     TYPE  xuauth,
         variant  TYPE  tpr_vari,
         modified TYPE  tpr_st_mod,
         deleted  TYPE  tpr_st_del,
         copied   TYPE  tpr_st_cop,
         neu      TYPE  tpr_st_new,
         node     TYPE  seu_id,
         atext    TYPE 	xutext,
       END OF  ty_agr_1250.

TYPES: BEGIN OF ty_agr_users,
         mandt      TYPE  symandt,
         agr_name   TYPE  agr_name,
         uname      TYPE  xubname,
         from_dat   TYPE  agr_fdate,
         to_dat	    TYPE  agr_tdate,
         exclude    TYPE  agr_excl,
         change_dat TYPE  menu_date,
         change_tim TYPE  menu_time,
         change_tst TYPE  rstimestmp,
         org_flag   TYPE  agr_org,
         col_flag   TYPE  agr_col,
       END OF  ty_agr_users.

TYPES: BEGIN OF ty_usobt,
         name     TYPE  xupname,
         type     TYPE  usobtype,
         object   TYPE  xuobject,
         field    TYPE  xufield,
         low      TYPE  xuval,
         high	    TYPE  xuval,
         modifier TYPE  xumodifier,
         moddate  TYPE  xumoddate,
         modtime  TYPE  xumodtime,
       END OF  ty_usobt.

TYPES: BEGIN OF ty_usobx,
         name     TYPE  xupname,
         type     TYPE  usobtype,
         object   TYPE  xuobject,
         modifier TYPE  xumodifier,
         moddate  TYPE  xumoddate,
         modtime  TYPE  xumodtime,
         okflag   TYPE  xuokflag,
       END OF  ty_usobx.


TYPES: BEGIN OF ty_usobx_c,
         name     TYPE  xupname,
         type     TYPE  usobtype,
         object   TYPE  xuobject,
         modifier TYPE  xumodifier,
         moddate  TYPE  xumoddate,
         modtime  TYPE  xumodtime,
         okflag	  TYPE  xuokflag,
         modified,
         orgname  TYPE  xupname,
       END OF  ty_usobx_c.

TYPES: BEGIN OF ty_usobt_c,
         name     TYPE  xupname,
         type     TYPE  usobtype,
         object   TYPE  xuobject,
         field    TYPE  xufield,
         low      TYPE  xuval,
         high	    TYPE  xuval,
         modifier TYPE  xumodifier,
         moddate  TYPE  xumoddate,
         modtime  TYPE  xumodtime,
         modified,
       END OF  ty_usobt_c.

TYPES: BEGIN OF t_tcode,
         ztcode TYPE zworkload-ztcode,
       END OF t_tcode.

TYPES: BEGIN OF ts_agr_tcodes,
         tcode TYPE agxreport,
       END OF ts_agr_tcodes.

TYPES: BEGIN OF ty_alv_merge,
         agr_name    TYPE  agr_name,
         type	       TYPE reporttype,
         tcode       TYPE	agxreport,
         period      TYPE  spmon,
         account     TYPE  zwkaccount,
         ztcode      TYPE  zswltcode,
         destasktype TYPE  zwktsktyp,
         zsteps      TYPE  zwksteps,
       END OF ty_alv_merge.

TYPES: BEGIN OF ty_tcode,
         tcode TYPE agr_tcodes-tcode,
       END OF ty_tcode,

       BEGIN OF ty_role,
         tcode    TYPE agr_tcodes-tcode,
         agr_name TYPE agr_tcodes-agr_name,
       END OF ty_role,

       BEGIN OF f_str,
         tcode    TYPE agr_tcodes-tcode,
         agr_name TYPE agr_tcodes-agr_name,
       END OF f_str.
*----------------------------------------------------------------------*
*  Internal Tables
*----------------------------------------------------------------------*
DATA: lt_data_1251    TYPE TABLE OF ty_agr_1251,
      lt_data_define  TYPE TABLE OF ty_agr_define,
      lt_data_agrs    TYPE TABLE OF ty_agr_agrs,
      lt_data_tcodes  TYPE TABLE OF ty_agr_tcodes ,
      lt_data_1250    TYPE TABLE OF ty_agr_1250,
      lt_data_users   TYPE TABLE OF ty_agr_users,
      lt_data_usobt   TYPE TABLE OF ty_usobt,
      lt_data_usobx   TYPE TABLE OF ty_usobx,
      lt_data_usobx_c TYPE TABLE OF ty_usobx_c,
      lt_data_usobt_c TYPE TABLE OF ty_usobt_c.


data: ls_data_tcodes  TYPE ty_agr_tcodes.


*----------------------------------------------------------------------*
*  Work area for select option
*----------------------------------------------------------------------*
DATA: lv_role_name TYPE agr_name,
      lv_usob_name TYPE xupname.

*----------------------------------------------------------------------*
*   Global data for Tcode usage
*----------------------------------------------------------------------*
DATA: t_work    TYPE TABLE OF swncaggusertcode, "SWNCHITLIST
      "Tabella temporanea
      t_dirmoni TYPE TABLE OF swncmonikey.
"Workload component
DATA: t_output TYPE TABLE OF zworkload
*      ts_output type zworkload.
       WITH HEADER LINE.

DATA: itsktp TYPE swnctasktyperaw.
DATA: BEGIN OF t_elcod OCCURS 0,
        ztcode TYPE zworkload-ztcode,
      END OF t_elcod.

DATA: BEGIN OF it_tstcp OCCURS 0,
        tcode     TYPE tstcp-tcode,
        zrepnm    TYPE zworkload-zrepnm,
        zdesrepnm TYPE zworkload-zdesrepnm,
      END OF it_tstcp.
CONSTANTS: znamestruc TYPE dd02l-tabname VALUE 'ZWORKLOAD'.

DATA: f_output  TYPE TABLE OF t_tcode,
      fs_output TYPE t_tcode.

DATA: lt_agr_tcodes TYPE TABLE OF ts_agr_tcodes,
      ls_agr_tcodes  TYPE ts_agr_tcodes.

DATA: lt_alv_merge TYPE TABLE OF ty_alv_merge.

DATA: ucomm LIKE sy-ucomm.

DATA: lv_url TYPE c LENGTH 100.

DATA: f1_outtab TYPE TABLE OF f_str,
      w1_outtab TYPE f_str.
DATA: t_alsmex_tabline LIKE STANDARD TABLE OF alsmex_tabline.

DATA: lt_tcode TYPE TABLE OF ty_tcode,
      lt_roles TYPE TABLE OF ty_role.

DATA:  it_raw TYPE truxs_t_text_data.

DATA: it1_fieldcat TYPE slis_t_fieldcat_alv,
      wa1_fieldcat TYPE slis_fieldcat_alv.

*----------------------------------------------------------------------*
*Data declaration for file existence
*----------------------------------------------------------------------*

DATA:ld_filename TYPE string,
     ld_path     TYPE string,
     ld_fullpath TYPE string,
     ld_result   TYPE i.

DATA: lv_filename TYPE string,
      lv_result   TYPE string,
      lv_rc       TYPE string,
      lv_out      TYPE i,
      lv_date     TYPE datum,
      lv_time     TYPE uzeit.

DATA: lv_folder TYPE string,
      lv_found  TYPE c.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
DATA : lv_path TYPE string.
*----------------------------------------------------------------------*
*   Header Line Declaration
*----------------------------------------------------------------------*
DATA : BEGIN OF it_heading_1251 OCCURS 0,
         text(40),
       END OF it_heading_1251.

DATA : BEGIN OF it_heading_agrs OCCURS 0,
         text(40),
       END OF it_heading_agrs.

DATA : BEGIN OF it_heading_define OCCURS 0,
         text(45),
       END OF it_heading_define.

DATA : BEGIN OF it_heading_tcodes OCCURS 0,
         text(40),
       END OF it_heading_tcodes.

DATA : BEGIN OF it_heading_1250 OCCURS 0,
         text(40),
       END OF it_heading_1250.

DATA : BEGIN OF it_heading_users OCCURS 0,
         text(40),
       END OF it_heading_users.

DATA : BEGIN OF it_heading_usobt OCCURS 0,
         text(40),
       END OF it_heading_usobt.

DATA : BEGIN OF it_heading_usobx OCCURS 0,
         text(40),
       END OF it_heading_usobx.

DATA : BEGIN OF it_heading_usobx_c OCCURS 0,
         text(40),
       END OF it_heading_usobx_c.

DATA : BEGIN OF it_heading_usobt_c OCCURS 0,
         text(40),
       END OF it_heading_usobt_c.

DATA : BEGIN OF it_heading_st03n OCCURS 0,
         text(40),
       END OF it_heading_st03n.

*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
