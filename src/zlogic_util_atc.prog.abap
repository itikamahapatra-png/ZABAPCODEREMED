*&---------------------------------------------------------------------*
*& Report ZLOGIC_UTIL_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlogic_util_atc.

PARAMETERS: rb1 RADIOBUTTON GROUP r1,
            rb2 RADIOBUTTON GROUP r1.

IF rb1 = 'X'.

  SELECT employee_band,
  employee_type,
  utilization
  FROM zutilization
  INTO TABLE @DATA(lt_data) WHERE employee_type = 'Contractor - FT'.

  LOOP AT lt_data INTO DATA(wa_data).
    WRITE: wa_data-employee_band, wa_data-employee_type, wa_data-utilization.
  ENDLOOP.

  ELSEif rb2 = 'X'.

    SELECT employee_band,
  employee_type,
  utilization
  FROM zutilization
  INTO TABLE @DATA(lt_data1) WHERE employee_type <> 'Contractor - FT'.

  LOOP AT lt_data1 INTO DATA(wa_data1).
    WRITE: wa_data1-employee_band, wa_data1-employee_type, wa_data1-utilization.
  ENDLOOP.


ENDIF.
