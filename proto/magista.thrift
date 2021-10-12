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
    4: optional InvoiceStatus invoice_status
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
    5: optional InvoicePaymentRefundStatus refund_status
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
    4: optional PayoutToolType payout_type
}

enum PayoutToolType {
    payout_account
    wallet
    payment_institution_account
}

struct InvoiceTemplateSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: optional domain.InvoiceTemplateID invoice_template_id
    3: optional base.Timestamp invoice_valid_until
    4: optional string product
    5: optional string name
    6: optional InvoiceTemplateStatus invoice_template_status
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
    2: optional InvoicePaymentStatus payment_status
    3: optional InvoicePaymentFlowType payment_flow
    4: optional PaymentToolType payment_tool
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

enum InvoiceTemplateStatus {
    created
    deleted
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
    6: required domain.InvoicePaymentStatus status
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
    23: optional base.Timestamp status_changed_at
}

union Payer {
    1: domain.PaymentResourcePayer payment_resource
    2: CustomerPayer        customer
    3: domain.RecurrentPayer       recurrent
}

struct CustomerPayer {
    1: required domain.CustomerID customer_id
    2: required domain.PaymentTool payment_tool
    3: optional domain.ContactInfo contact_info
}

enum InvoicePaymentFlowType {
    instant
    hold
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

enum InvoicePaymentStatus {
    pending
    processed
    captured
    cancelled
    refunded
    failed
    charged_back
}

enum PaymentToolType {
    bank_card
    payment_terminal
    digital_wallet
    crypto_currency
    mobile_commerce
}

struct StatInvoice {
    1: required domain.InvoiceID id
    2: required domain.PartyID owner_id
    3: required domain.ShopID shop_id
    4: required base.Timestamp created_at
    5: required domain.InvoiceStatus status
    6: required string product
    7: optional string description
    8: required base.Timestamp due
    9: required domain.Amount amount
    10: required string currency_symbolic_code
    11: optional base.Content context
    12: optional domain.InvoiceCart cart
    13: optional string external_id
    14: optional base.Timestamp status_changed_at
}

enum InvoiceStatus {
    unpaid
    paid
    cancelled
    fulfilled
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
    6: required domain.InvoicePaymentRefundStatus status
    7: required base.Timestamp created_at
    8: required domain.Amount amount
    9: required domain.Amount fee
    10: required string currency_symbolic_code
    11: optional string reason
    12: optional domain.InvoiceCart cart
    13: optional string external_id
    14: optional base.Timestamp status_changed_at
}

enum InvoicePaymentRefundStatus {
    pending
    succeeded
    failed
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
    1: required base.Timestamp event_created_at
    2: required domain.PartyID party_id
    3: required domain.ShopID shop_id
    4: required domain.InvoiceTemplateID invoice_template_id
    5: required base.Timestamp invoice_valid_until
    6: required string product
    7: optional string description
    8: optional domain.InvoiceTemplateDetails details
    9: optional domain.InvoiceContext context
    10: optional string name
    11: optional InvoiceTemplateStatus invoice_template_status
    12: optional base.Timestamp invoice_template_created_at
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
