include "proto/base.thrift"
include "proto/domain.thrift"
include "proto/payout_manager.thrift"
include "proto/geo_ip.thrift"

namespace java com.rbkmoney.magista
namespace erlang magista

typedef string ContinuationToken

exception BadContinuationToken { 1: string reason }
exception LimitExceeded {}

struct InvoiceSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: required PaymentParams payment_params
    3: optional list<domain.InvoiceID> invoice_ids
    4: optional domain.InvoiceStatus invoice_status
    5: optional domain.Amount invoice_amount
    6: optional string external_id
}

struct PaymentSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: required PaymentParams payment_params
    3: optional list<domain.InvoiceID> invoice_ids
    4: optional string external_id
    5: optional list<domain.ShopID> excluded_shop_ids
}

struct RefundSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: optional list<domain.InvoiceID> invoice_ids
    3: optional domain.InvoicePaymentID payment_id
    4: optional domain.InvoicePaymentRefundID refund_id
    5: optional domain.InvoicePaymentRefundStatus refund_status
    6: optional string external_id
}

struct ChargebackSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: optional list<domain.InvoiceID> invoice_ids
    3: optional domain.InvoicePaymentID payment_id
    4: optional domain.InvoicePaymentChargebackID chargeback_id
    5: optional list<domain.InvoicePaymentChargebackStatus> chargeback_statuses
    6: optional list<domain.InvoicePaymentChargebackStage> chargeback_stages
    7: optional list<domain.InvoicePaymentChargebackCategory> chargeback_categories
}

struct PayoutSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: optional payout_manager.PayoutID payout_id
    3: optional list<payout_manager.PayoutStatus> payout_statuses
    4: optional domain.PayoutToolInfo payout_type
}

struct InvoiceTemplateSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: optional domain.InvoiceTemplateID invoice_template_id
    3: optional base.Timestamp invoice_valid_until
    4: optional string product
    5: optional string name
}

struct CommonSearchQueryParams {
    1: required base.Timestamp to_time
    2: required base.Timestamp from_time
    3: required domain.PartyID party_id
    4: optional list<domain.ShopID> shop_ids
    5: optional ContinuationToken continuation_token
    6: optional i32 limit
}

struct PaymentParams {
    1: optional domain.InvoicePaymentID payment_id
    2: optional domain.InvoicePaymentStatus payment_status
    3: optional domain.InvoicePaymentFlow payment_flow
    4: optional domain.PaymentTool payment_tool
    5: optional domain.LegacyTerminalPaymentProvider payment_terminal_provider
    6: optional string payment_email
    7: optional string payment_ip
    8: optional string payment_fingerprint
    9: optional string payment_first6
    10: optional domain.LegacyBankCardPaymentSystem payment_system
    12: optional string payment_last4
    11: optional domain.CustomerID payment_customer_id
    13: optional string payment_provider_id
    14: optional string payment_terminal_id
    15: optional domain.Amount payment_amount
    16: optional domain.DataRevision payment_domain_revision
    17: optional domain.DataRevision from_payment_domain_revision
    18: optional domain.DataRevision to_payment_domain_revision
    19: optional string payment_rrn
    20: optional string payment_approval_code
    21: optional domain.Amount payment_amount_from
    22: optional domain.Amount payment_amount_to
    23: optional domain.LegacyBankCardTokenProvider payment_token_provider
}

struct StatInvoiceResponse {
    1: required list<StatInvoice> invoices
    2: optional string continuation_token
}

struct StatPaymentResponse {
    1: required list<StatPayment> payments
    2: optional string continuation_token
}

struct StatRefundResponse {
    1: required list<StatRefund> refunds
    2: optional string continuation_token
}

struct StatChargebackResponse {
    1: required list<StatChargeback> chargebacks
    2: optional string continuation_token
}

struct StatPayoutResponse {
    1: required list<StatPayout> payouts
    2: optional string continuation_token
}

struct StatInvoiceTemplateResponse {
    1: required list<StatInvoiceTemplate> invoice_templates
    2: optional string continuation_token
}

struct StatPayment {
    1: required domain.InvoicePaymentID id
    2: required domain.InvoiceID invoice_id
    3: required domain.PartyID owner_id
    4: required domain.ShopID shop_id
    5: required base.Timestamp created_at
    6: required InvoicePaymentStatus status
    7: required domain.Amount amount
    8: required domain.Amount fee
    9: required string currency_symbolic_code
    10: required Payer payer
    12: optional base.Content context
    13: optional geo_ip.LocationInfo location_info
    14: required InvoicePaymentFlow flow
    15: optional string short_id
    16: optional bool make_recurrent
    17: required domain.DataRevision domain_revision
    18: optional domain.InvoiceCart cart
    19: optional domain.AdditionalTransactionInfo additional_transaction_info
    20: optional string external_id
    21: optional domain.ProviderRef provider_id
    22: optional domain.TerminalRef terminal_id
}

union Payer {
    1: PaymentResourcePayer payment_resource
    2: CustomerPayer        customer
    3: RecurrentPayer       recurrent
}

struct RecurrentParentPayment {
    1: required domain.InvoiceID invoice_id
    2: required domain.InvoicePaymentID payment_id
}

struct RecurrentPayer {
    1: required PaymentTool payment_tool
    2: required RecurrentParentPayment recurrent_parent
    3: optional string phone_number
    4: optional string email
}

struct PaymentResourcePayer {
    1: required PaymentTool payment_tool
    2: optional domain.IPAddress ip_address
    3: optional domain.Fingerprint fingerprint
    4: optional string phone_number
    5: optional string email
    6: optional domain.PaymentSessionID session_id
}

struct CustomerPayer {
    1: required domain.CustomerID customer_id
    2: required PaymentTool payment_tool
    3: optional string phone_number
    4: optional string email
}

union InvoicePaymentFlow {
    1: InvoicePaymentFlowInstant instant
    2: InvoicePaymentFlowHold hold
}

struct InvoicePaymentFlowInstant   {}

struct InvoicePaymentFlowHold {
    1: required OnHoldExpiration on_hold_expiration
    2: required base.Timestamp held_until
}

enum OnHoldExpiration {
    cancel
    capture
}

union OperationFailure {
    1: OperationTimeout operation_timeout
    2: domain.Failure  failure
}

struct OperationTimeout {}

struct InvoicePaymentPending   {}
struct InvoicePaymentProcessed { 1: optional base.Timestamp at }
struct InvoicePaymentCaptured  { 1: optional base.Timestamp at }
struct InvoicePaymentCancelled { 1: optional base.Timestamp at }
struct InvoicePaymentRefunded  { 1: optional base.Timestamp at }
struct InvoicePaymentChargedBack { 1: optional base.Timestamp at }
struct InvoicePaymentFailed    {
    1: required OperationFailure failure
    2: optional base.Timestamp at
}

union InvoicePaymentStatus {
    1: InvoicePaymentPending pending
    4: InvoicePaymentProcessed processed
    2: InvoicePaymentCaptured captured
    5: InvoicePaymentCancelled cancelled
    6: InvoicePaymentRefunded refunded
    3: InvoicePaymentFailed failed
    7: InvoicePaymentChargedBack charged_back
}

union PaymentTool {
    1: BankCard bank_card
    2: PaymentTerminal payment_terminal
    3: DigitalWallet digital_wallet
    4: CryptoCurrency crypto_currency
    5: MobileCommerce mobile_commerce
}

struct MobileCommerce {
    1: required MobileOperator operator
    2: required MobilePhone    phone
}

enum MobileOperator {
    mts      = 1
    beeline  = 2
    megafone = 3
    tele2    = 4
    yota     = 5
}

struct MobilePhone {
    1: required string cc
    2: required string ctn
}

struct BankCard {
    1: required domain.Token token
    6: optional domain.PaymentSystemRef payment_system
    3: required string bin
    4: required string masked_pan
    7: optional domain.BankCardTokenServiceRef payment_token
    /** Deprecated **/
    2: optional domain.LegacyBankCardPaymentSystem payment_system_deprecated
    5: optional domain.LegacyBankCardTokenProvider token_provider_deprecated
}

enum CryptoCurrency {
    bitcoin
    litecoin
    bitcoin_cash
    ripple
    ethereum
    zcash
}

struct PaymentTerminal {
    1: required TerminalPaymentProvider terminal_type
}

enum TerminalPaymentProvider {
    euroset
    wechat
    alipay
    zotapay
    qps
    uzcard
    rbs // Рунет Бизнес Системы
}

typedef string DigitalWalletID

struct DigitalWallet {
    1: required DigitalWalletProvider provider
    2: required DigitalWalletID       id
}

enum DigitalWalletProvider {
    qiwi
}

struct StatInvoice {
    1: required domain.InvoiceID id
    2: required domain.PartyID owner_id
    3: required domain.ShopID shop_id
    4: required base.Timestamp created_at
    5: required InvoiceStatus status
    6: required string product
    7: optional string description
    8: required base.Timestamp due
    9: required domain.Amount amount
    10: required string currency_symbolic_code
    11: optional base.Content context
    12: optional domain.InvoiceCart cart
    13: optional string external_id
}

struct InvoiceUnpaid    {}
struct InvoicePaid      { 1: optional base.Timestamp at }
struct InvoiceCancelled {
    1: required string details
    2: optional base.Timestamp at
}
struct InvoiceFulfilled {
    1: required string details
    2: optional base.Timestamp at
}

union InvoiceStatus {
    1: InvoiceUnpaid unpaid
    2: InvoicePaid paid
    3: InvoiceCancelled cancelled
    4: InvoiceFulfilled fulfilled
}

struct StatCustomer {
    1: required domain.Fingerprint id
    2: required base.Timestamp created_at
}

typedef base.ID PayoutID

struct StatPayout {
    1: required PayoutID id
    2: required domain.PartyID party_id
    3: required domain.ShopID shop_id
    4: required base.Timestamp created_at
    5: required PayoutStatus status
    6: required domain.Amount amount
    7: required domain.Amount fee
    8: required string currency_symbolic_code
    9: required domain.PayoutToolInfo payout_tool_info
}

union PayoutStatus {
    1: PayoutUnpaid unpaid
    2: PayoutPaid paid
    3: PayoutCancelled cancelled
    4: PayoutConfirmed confirmed
}

struct PayoutUnpaid {}
struct PayoutPaid {}
struct PayoutCancelled { 1: required string details }
struct PayoutConfirmed {}

struct StatRefund {
    1: required domain.InvoicePaymentRefundID id
    2: required domain.InvoicePaymentID payment_id
    3: required domain.InvoiceID invoice_id
    4: required domain.PartyID owner_id
    5: required domain.ShopID shop_id
    6: required InvoicePaymentRefundStatus status
    7: required base.Timestamp created_at
    8: required domain.Amount amount
    9: required domain.Amount fee
    10: required string currency_symbolic_code
    11: optional string reason
    12: optional domain.InvoiceCart cart
    13: optional string external_id
}

union InvoicePaymentRefundStatus {
    1: InvoicePaymentRefundPending pending
    2: InvoicePaymentRefundSucceeded succeeded
    3: InvoicePaymentRefundFailed failed
}

struct InvoicePaymentRefundPending {}
struct InvoicePaymentRefundSucceeded {
    1: required base.Timestamp at
}

struct InvoicePaymentRefundFailed {
    1: required OperationFailure failure
    2: required base.Timestamp at
}

typedef map<string, string> StatInfo
typedef base.InvalidRequest InvalidRequest

struct StatChargeback {
    1: required domain.InvoiceID invoice_id
    2: required domain.InvoicePaymentID payment_id
    3: required domain.InvoicePaymentChargebackID chargeback_id
    4: required domain.PartyID party_id
    5: required domain.ShopID shop_id
    6: required domain.InvoicePaymentChargebackStatus chargeback_status
    7: required base.Timestamp created_at
    8: optional domain.InvoicePaymentChargebackReason chargeback_reason
    10: required domain.Amount levy_amount
    11: required domain.Currency levy_currency_code
    12: required domain.Amount amount
    13: required domain.Currency currency_code
    14: optional domain.Amount fee
    15: optional domain.Amount provider_fee
    16: optional domain.Amount external_fee
    17: optional domain.InvoicePaymentChargebackStage stage
    18: optional base.Content content
    19: optional string external_id
}

struct StatInvoiceTemplate {
    1: required base.Timestamp created_at
    2: required domain.PartyID party_id
    3: required domain.ShopID shop_id
    4: required domain.InvoiceTemplateID invoice_template_id
    5: required base.Timestamp invoice_valid_until
    6: required string product
    10: optional string name
    7: optional string description
    8: optional domain.InvoiceTemplateDetails details
    9: optional domain.InvoiceContext context
}

service MerchantStatisticsService {

    StatInvoiceResponse SearchInvoices (1: InvoiceSearchQuery invoice_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

    StatPaymentResponse SearchPayments (1: PaymentSearchQuery payment_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

    StatRefundResponse SearchRefunds (1: RefundSearchQuery refund_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

    StatChargebackResponse SearchChargebacks (1: ChargebackSearchQuery chargeback_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

    StatPayoutResponse SearchPayouts (1: PayoutSearchQuery payout_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

    StatInvoiceTemplateResponse SearchInvoiceTemplates (1: InvoiceTemplateSearchQuery invoice_template_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

}
