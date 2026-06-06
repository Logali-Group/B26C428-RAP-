@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel - Consupmtions Entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_TRAVEL_428LG 
    provider contract transactional_query
    as projection on ZI_TRAVEL_428LG
{
    key TravelUUID,
    TravelID,
    @ObjectModel.text.element: [ 'AgencyName' ]
    @Consumption.valueHelpDefinition: [{ 
        entity: { name: '/DMO/I_Agency', element: 'AgencyID' }
     }]
    AgencyID,
    AgencyName,
    @ObjectModel.text.element: [ 'CustomerName' ]
    CustomerID,
    CustomerName,
    BeginDate,
    EndDate,
    CurrencyCode,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    Description,
    @ObjectModel.text.element: [ 'OverallStatusText' ]
    OverallStatus,
    _OverallStatus._Text.Text as OverallStatusText : localized,
    OverallStatusCriticality,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    LocalLastChangedAt,
    @Semantics.systemDateTime.lastChangedAt: true
    LastChangedAt,
    /* Associations */
    _Agency,
    _Booking : redirected to composition child ZC_BOOKING_428LG,
    _Currency,
    _Customer,
    _OverallStatus
}
