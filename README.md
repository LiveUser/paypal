# Pay Pal
Unofficial pay pal SDK
Hecho en 🇵🇷 por Radamés J. Valentín Reyes

--------------------------------------------------------
# Import
~~~dart
import 'package:unofficial_paypal_sdk/unofficial_paypal_sdk.dart';
~~~
--------------------------------------------------------
# Initiate an instance of Pay Pal
Uses the client ID and client secret to fetch an access token. init() Must be called before any other function. Tokens expire so this function has to be called again before expirations to avoid errors when performing API calls.
~~~dart
PayPal payPal = PayPal(
  clientID: appKey, 
  clientSecret: appSecret,
  sandboxMode: false,//Sandbox mode false to go live. Perform real transactions
);
PayPalAccessToken payPalAccessToken = await payPal.init();
print(payPalAccessToken.access_token);
~~~
# Catalog Products API
-------------------------------------------------------------------
## List Products
Gets a list of products saved into your paypal app
~~~dart
PayPalProductsList productsList = await payPal.listProducts();
~~~
## Create Product
~~~dart
PayPalProduct createdProduct = await payPal.createProduct(
  prefer: Prefer.representation,
  id: id,
  payPalRequestID: id,
  name: "Pay Pal Logo",
  description: "The logo of Pay Pal",
  category: ProductCatogory.ANIMATION,
);
print("Created " + createdProduct.name);
print("Category " + createdProduct.category!);
~~~
## Update Product
~~~dart
await payPal.updateProduct(
  product_id: createdProduct.id, 
  operation: UpdateProductOperation.replace, 
  attributeToModify: UpdateProductAttribute.category,
  newValue: ProductCatogory.ACCOUNTING,
);
~~~
## Show Product Details
~~~dart
PayPalProduct updatedProduct = await payPal.showProductDetails(
  product_id: createdProduct.id,
);
~~~

# Subscriptions API
-------------------------------------------------------------------

## List plans
~~~dart
ListOfPayPalPlans allPlans = await payPal.listPlans();
~~~

## Create Subscription Plan
~~~dart
SubscriptionPlan createdSubscription = await payPal.createPlan(
  payPalRequestId: id, 
  product_id: productsList.products.first.id, 
  name: "A test subscription", 
  description: "Just testing the API", 
  billingCycles: [
    BillingCycle(
      frequency: Frequency(
        interval_count: 1,
        interval_unit: "MONTH",
      ), 
      pricing_scheme: PricingScheme(
        value: "5.99",
        currency_code: "USD",
      ), 
      sequence: 1, 
      tenure_type: TenureType.TRIAL, 
      total_cycles: 1,
    ),
    BillingCycle(
      frequency: Frequency(
        interval_count: 1,
        interval_unit: "MONTH",
      ), 
      pricing_scheme: PricingScheme(
        value: "5.99",
        currency_code: "USD",
      ), 
      sequence: 2, 
      tenure_type: TenureType.REGULAR, 
      total_cycles: 1,
    ),
  ], 
  paymentPreferences: PaymentPreferences(
    auto_bill_outstanding: true, 
    setup_fee: SetupFee(
      value: "5",
      currency_code: "USD",
    ), 
    setup_fee_failure_action: SetupFeeFailureAction.CANCEL, 
    payment_failure_threshold: 1,
  ), 
  taxes: Taxes(
    percentage: "11.5", 
    inclusive: false,
  ), 
  quantity_supported: false,
);
~~~

## Update plan
~~~dart
ListOfPayPalPlans allPlans = await payPal.listPlans();
await payPal.updatePlan(
  id:allPlans.plans.first.id, 
  operation: UpdateSubscriptionPlanOperation.replace,
  attributeToModify: UpdateSubscriptionPlanAttribute.description,
  newValue: "Mi perrito ladra",
);
~~~
## Show plan details
~~~dart
ListOfPayPalPlans allPlans = await payPal.listPlans();
SubscriptionPlan planWithDetails = await payPal.showPlanDetails(id: allPlans.plans.first.id);
~~~
## Activate plan
~~~dart
ListOfPayPalPlans allPlans = await payPal.listPlans();
await payPal.activatePlan(id: allPlans.plans.first.id);
~~~
## Deactivate plan
~~~dart
ListOfPayPalPlans allPlans = await payPal.listPlans();
await payPal.deactivatePlan(id: allPlans.plans.first.id);
~~~

# Invoices API
-------------------------------------------------------------------
## Generate invoice number
~~~dart
import 'package:power_plant/power_plant.dart';//A token/alphanumeric combination generator
String invoice_number = uniqueAlphanumeric(tokenLength: 25);
String generatedInvoiceNumber = await payPal.generateInvoiceNumber(invoice_number: invoice_number);
~~~
--------------------------------------------------------

## Contribute/donate by tapping on the Pay Pal logo/image
<a href="https://www.paypal.com/paypalme/onlinespawn"><img src="https://www.paypalobjects.com/webstatic/mktg/logo/pp_cc_mark_74x46.jpg"/></a>

------------------------------------------------------------

# Examples

## Example 1
~~~dart
String id = uniqueAlphanumeric(tokenLength: 30);
PayPalProduct createdProduct = await payPal.createProduct(
  prefer: Prefer.representation,
  id: id,
  payPalRequestID: id,
  name: "Pay Pal Logo",
  description: "The logo of Pay Pal",
  category: ProductCatogory.ANIMATION,
);
print("Created " + createdProduct.name);
print("Category " + createdProduct.category!);
//Test 
await payPal.updateProduct(
  product_id: createdProduct.id,
  operation: UpdateProductOperation.replace, 
  attributeToModify: UpdateProductAttribute.category,
  newValue: ProductCatogory.ACCOUNTING,
);
PayPalProduct updatedProduct = await payPal.showProductDetails(
  product_id: createdProduct.id,
);
print(updatedProduct.category);
~~~

## Example 2
~~~dart
String id = uniqueAlphanumeric(tokenLength: 30);
await payPal.init();
PayPalProductsList productsList = await payPal.listProducts();
SubscriptionPlan createdSubscription = await payPal.createPlan(
  payPalRequestId: id, 
  product_id: productsList.products.first.id, 
  name: "A test subscription", 
  description: "Just testing the API", 
  billingCycles: [
    BillingCycle(
      frequency: Frequency(
        interval_count: 1,
        interval_unit: "MONTH",
      ), 
      pricing_scheme: PricingScheme(
        value: "5.99",
        currency_code: "USD",
      ), 
      sequence: 1, 
      tenure_type: TenureType.TRIAL, 
      total_cycles: 1,
    ),
    BillingCycle(
      frequency: Frequency(
        interval_count: 1,
        interval_unit: "MONTH",
      ), 
      pricing_scheme: PricingScheme(
        value: "5.99",
        currency_code: "USD",
      ), 
      sequence: 2, 
      tenure_type: TenureType.REGULAR, 
      total_cycles: 1,
    ),
  ], 
  paymentPreferences: PaymentPreferences(
    auto_bill_outstanding: true, 
    setup_fee: SetupFee(
      value: "5",
      currency_code: "USD",
    ), 
    setup_fee_failure_action: SetupFeeFailureAction.CANCEL, 
    payment_failure_threshold: 1,
  ), 
  taxes: Taxes(
    percentage: "11.5", 
    inclusive: false,
  ), 
  quantity_supported: false,
);
print(createdSubscription.name);
~~~
------------------------------------------------------------
# References

- https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST
- https://developer.paypal.com/api/rest/
- https://www.postman.com/anthonylacitelp/workspace/paypal-payment-and-subscription/request/16680306-6467af3a-ed1e-42ac-911d-e40b980f836f
- https://www.rfc-editor.org/rfc/rfc6749#page-37
- https://www.postman.com/anthonylacitelp/workspace/paypal-payment-and-subscription/documentation/16680306-fb87a596-dec5-4dcf-ac9e-9dd63be850f9
- https://www.twilio.com/docs/glossary/what-is-basic-authentication#:~:text=Basic%20Authentication%20is%20a%20method,of%20each%20request%20they%20make.
- https://api.dart.dev/stable/2.16.1/dart-convert/base64Encode.html
- https://www.postman.com/anthonylacitelp/workspace/paypal-payment-and-subscription/request/16680306-6467af3a-ed1e-42ac-911d-e40b980f836f
- https://developer.paypal.com/docs/api/orders/v2/
- https://developer.paypal.com/docs/api/catalog-products/v1/
- https://www.postman.com/anthonylacitelp/workspace/paypal-payment-and-subscription/request/16680306-8df7d744-8f42-4385-96ee-5b1f5407246a
- https://developer.paypal.com/docs/api/subscriptions/v1/
- https://developer.paypal.com/docs/api/invoicing/v2/
- https://developer.paypal.com/docs/api/invoicing/v2/#definition-item