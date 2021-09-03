include "proto/base.thrift"
include "proto/domain.thrift"
include "magista.thrift"

namespace java com.rbkmoney.magista.dark.messiah
namespace erlang magista_dark_messiah

typedef string ContinuationToken

exception BadContinuationToken { 1: string reason }
exception LimitExceeded {}

struct PaymentSearchQuery {
    1: required magista.CommonSearchQueryParams common_search_query_params
    2: optional domain.InvoiceID invoice_id
    3: optional domain.InvoicePaymentID payment_id
    4: optional domain.InvoicePaymentStatus payment_status
    5: optional domain.InvoicePaymentFlow payment_flow
    6: optional domain.PaymentTool payment_tool
    7: optional domain.LegacyTerminalPaymentProvider payment_terminal_provider
    8: optional string payment_email
    9: optional string payment_ip
    10: optional string payment_fingerprint
    11: optional string payment_first6
    12: optional domain.LegacyBankCardPaymentSystem payment_system
    13: optional string payment_last4
    14: optional domain.CustomerID payment_customer_id
    15: optional domain.Amount payment_amount
    16: optional domain.DataRevision payment_domain_revision
    17: optional domain.DataRevision from_payment_domain_revision
    18: optional domain.DataRevision to_payment_domain_revision
    19: optional string payment_rrn
    20: optional string payment_approval_code
    21: optional string external_id
    22: optional domain.LegacyBankCardTokenProvider payment_token_provider
}

struct RefundSearchQuery {
    1: required magista.CommonSearchQueryParams common_search_query_params
    2: optional domain.InvoiceID invoice_id
    3: optional domain.InvoicePaymentID payment_id
    4: optional domain.InvoicePaymentRefundID refund_id
    5: optional domain.InvoicePaymentRefundStatus refund_status
    6: optional string external_id
}

struct StatEnrichedStatInvoiceResponse {
    1: required list<EnrichedStatInvoice> enriched_invoices
    2: optional ContinuationToken continuation_token
}

struct EnrichedStatInvoice {
    1: required magista.StatInvoice invoice
    2: required list<magista.StatPayment> payments
    3: required list<magista.StatRefund> refunds
}

service DarkMessiahMerchantStatisticsService {

    StatEnrichedStatInvoiceResponse SearchInvoicesByPaymentSearchQuery (1: PaymentSearchQuery payment_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

    StatEnrichedStatInvoiceResponse SearchInvoicesByRefundSearchQuery (1: RefundSearchQuery refund_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

}
