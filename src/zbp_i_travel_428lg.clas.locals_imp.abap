CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS setTravelNumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR Travel~setTravelNumber.

    METHODS setInitialValue FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Travel~setInitialValue.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

   CONSTANTS:
        BEGIN OF travel_status,
            open TYPE c LENGTH 1 VALUE 'O',
            accepted TYPE c LENGTH 1 VALUE 'A',
            rejected TYPE c LENGTH 1 VALUE 'X',
       END OF TRAVEL_status,
       BEGIN OF travel_criticality,
        neutral TYPE i VALUE 0,
        negative TYPE i VALUE 1,
        positive TYPE i VALUE 3,
        information TYPE i VALUE 5,
       END OF TRAVEL_criticality.


ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setTravelNumber.

    READ ENTITIES OF ZI_TRAVEL_428LG IN LOCAL MODE
        ENTITY Travel
        FIELDS ( TravelID )
        WITH CORRESPONDING #( keys )
        RESULT DATA(travels).

   DELETE travels WHERE TravelID IS NOT INITIAL.
   CHECK travels IS NOT INITIAL.

   SELECT SINGLE FROM ztravel_428lg FIELDS MAX( travel_id ) INTO @DATA(max_travelid).

   MODIFY ENTITIES OF ZI_TRAVEL_428LG IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( TravelID )
    WITH VALUE #(
        FOR travel IN travels INDEX INTO i (
            %tky = travel-%tky
            TravelID = max_travelid + i
        )
    ).

  ENDMETHOD.

  METHOD setInitialValue.

    READ ENTITIES OF ZI_TRAVEL_428LG IN LOCAL MODE
        ENTITY Travel
        FIELDS ( OverallStatus OverallStatusCriticality CurrencyCode )
        WITH CORRESPONDING #( keys )
    RESULT DATA(travels).

    DELETE travels WHERE OverallStatus IS NOT INITIAL AND CurrencyCode IS NOT INITIAL.
    CHECK travels IS NOT INITIAL.

    MODIFY ENTITIES OF ZI_TRAVEL_428LG IN LOCAL MODE
        ENTITY Travel
        UPDATE FIELDS ( OverallStatus OverallStatusCriticality CurrencyCode  )
        WITH VALUE #( FOR travel IN travels (
            %tky = travel-%tky
            OverallStatus = COND #(
                WHEN travel-OverallStatus IS INITIAL
                THEN travel_status-open
                ELSE travel-OverallStatus
            )
            OverallStatusCriticality = COND #(
                WHEN travel-OverallStatus IS INITIAL
                THEN travel_criticality-information
                ELSE travel-OverallStatusCriticality
            )
            CurrencyCode = COND #(
                WHEN travel-CurrencyCode IS INITIAL
                THEN 'USD'
                ELSE travel-CurrencyCode
            )
        ) ).

  ENDMETHOD.

  METHOD acceptTravel.

    MODIFY ENTITIES OF ZI_TRAVEL_428LG IN LOCAL MODE
        ENTITY Travel
        UPDATE FIELDS ( OverallStatus OverallStatusCriticality )
        WITH VALUE #( FOR key IN keys (
            %tky = key-%tky
            OverallStatus = travel_status-accepted
            OverallStatusCriticality = travel_criticality-positive
        ) ).

    READ ENTITIES OF ZI_TRAVEL_428LG IN LOCAL MODE
        ENTITY Travel
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(travels).

   result = VALUE #( FOR travel IN travels (
        %tky = travel-%tky
        %param = travel
   ) ).

  ENDMETHOD.

  METHOD rejectTravel.

    MODIFY ENTITIES OF ZI_TRAVEL_428LG IN LOCAL MODE
        ENTITY Travel
        UPDATE FIELDS ( OverallStatus OverallStatusCriticality )
        WITH VALUE #( FOR key IN keys (
            %tky = key-%tky
            OverallStatus = travel_status-rejected
            OverallStatusCriticality = travel_criticality-negative
        ) ).

    READ ENTITIES OF ZI_TRAVEL_428LG IN LOCAL MODE
        ENTITY Travel
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(travels).

   result = VALUE #( FOR travel IN travels (
        %tky = travel-%tky
        %param = travel
   ) ).

  ENDMETHOD.

ENDCLASS.
