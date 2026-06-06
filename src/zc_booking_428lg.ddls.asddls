@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking - Consupmtions'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_BOOKING_428LG as projection on ZI_BOOKING_428LG
{
    key BookingUUID,
    TravelUUID,
    BookingID,
    BookingDate,
    CustomerID,
    AirlineID,
    ConnectionID,
    FlightDate,
    CurrencyCode,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    BookingStatus,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    LocalLastChangedAt,
    /* Associations */
    _BookingStatus,
    _BookingSupplement : redirected to composition child ZC_BSUPPL_428LG,
    _Carrier,
    _Connection,
    _Currency,
    _Customer,
    _Travel : redirected to parent ZC_TRAVEL_428LG
}
