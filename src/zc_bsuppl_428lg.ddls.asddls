@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplement - Consupmtions Entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BSUPPL_428LG as projection on ZI_BSUPPL_428LG
{
    key BooksupplUUID,
    TravelUUID,
    BookingUUID,
    BookingSupplementID,
    SupplementID,
    CurrencyCode,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    LocalLastChangedAt,
    /* Associations */
    _Booking : redirected to parent ZC_BOOKING_428LG,
    _Currency,
    _Product,
    _SupplementText,
    _Travel : redirected to ZC_TRAVEL_428LG
}
