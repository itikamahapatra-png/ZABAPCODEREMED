FUNCTION z_zwf1_back_order_cancel.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     REFERENCE(DELIVERY) TYPE  LIKP-VBELN
*"  EXPORTING
*"     REFERENCE(SALESORG) TYPE  LIKP-VKORG
*"     REFERENCE(RESULT) TYPE  SY-BATCH
*"     REFERENCE(MESSAGE) TYPE  BAPIRET2-MESSAGE
*"  TABLES
*"      RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------

  TABLES : vbfa,
           likp.

  DATA : salesdocument    LIKE bapivbeln-vbeln,
         order_header_in  LIKE bapisdh1,
         order_header_inx LIKE bapisdh1x,
         i_return         LIKE bapiret2   OCCURS 0 WITH HEADER LINE,
         c_all0      LIKE  vbap-posnr    VALUE '000000',
         w_vbeln LIKE bapivbeln-vbeln.

  DATA : BEGIN OF i_vbeln OCCURS 0,
  vbelv LIKE vbfa-vbeln,
         END OF i_vbeln.

  DATA : BEGIN OF i_vbfa OCCURS 0,
  vbeln LIKE vbfa-vbeln,
         END OF i_vbfa.

* Get Return Sales orders from Delivery
  CLEAR  vbfa.
  SELECT DISTINCT vbelv FROM vbfa INTO TABLE i_vbeln
  WHERE  vbeln   = delivery
    AND  vbtyp_n = 'J'.

  IF sy-subrc NE 0.
    result = 'S'.
    EXIT.
  ENDIF.

  CLEAR likp.
  SELECT SINGLE vkorg FROM likp INTO salesorg
  WHERE vbeln = delivery.

  SELECT vbeln FROM vbfa INTO TABLE i_vbfa
  FOR ALL ENTRIES IN i_vbeln
  WHERE vbelv = i_vbeln-vbelv
   AND  posnv   = '000000'
   AND  posnn   = '000000'
   AND  vbtyp_n = 'H'.

  IF sy-subrc NE 0.
    result = 'S'.
    EXIT.
  ENDIF.

  CLEAR : order_header_in, order_header_inx.
  order_header_inx-updateflag = 'U'.
  order_header_inx-bill_block = 'X'.
  LOOP AT i_vbfa.
* For each document
    w_vbeln = i_vbfa-vbeln.
    CALL FUNCTION 'SD_SALES_DOCUMENT_ENQUEUE'
         EXPORTING
              mandt          = sy-mandt
              vbeln          = w_vbeln
         EXCEPTIONS
              foreign_lock   = 1
              system_failure = 2
              OTHERS         = 3.
    IF sy-subrc NE 0.
      CONCATENATE 'Sales document' w_vbeln
      'is currently being processed'  INTO message.
    ELSE.

* Clear Billing block
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
           EXPORTING
                salesdocument    = w_vbeln
                order_header_in  = order_header_in
                order_header_inx = order_header_inx
           TABLES
                return           = i_return.

      LOOP AT i_return WHERE type = 'E' OR type = 'A'.
        REPLACE '&1' WITH return-message_v1 INTO i_return-message.
        REPLACE '&2' WITH return-message_v2 INTO i_return-message.
        REPLACE '&3' WITH return-message_v3 INTO i_return-message.
        REPLACE '&4' WITH return-message_v4 INTO i_return-message.
        message = i_return-message.
      ENDLOOP.
      IF sy-subrc = 0.
        APPEND i_return TO return.
        result = 'F'.   "failed created
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
             EXPORTING
                  wait = 'X'.

        IF result NE 'F'.
          result = 'S'.   " Success created
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFUNCTION.
