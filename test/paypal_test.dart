import 'package:unofficial_paypal_sdk/unofficial_paypal_sdk.dart';
import 'package:test/test.dart';
import 'package:power_plant/power_plant.dart';

void main() async{
  const String appKey = "ATVaqMfNztzxCZlEb3qpe1B1WlZTuA46kmRQ96jPnVzpY7mqYYSa6OZlcdDe7jZ4OvxZR72GEhXmP-eD";
  const String appSecret = "EHaJ2X4x9w0ASDNOYmYFMVX8dO44VMSqfwDKvn6RJH5BXoDLtHm0wIfgdjyenr64_dmTRkFaZd0VUK1R";
  PayPal payPal = PayPal(
    clientID: appKey, 
    clientSecret: appSecret,
  );
  await payPal.init();
  test("Get Access Token", ()async{
    PayPalAccessToken payPalAccessToken = await payPal.init();
    print(payPalAccessToken.access_token);
  });
  test("Create Product, modify it and show modifications", ()async{
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
  });
  test("Get products list", ()async{
    PayPalProductsList productsList = await payPal.listProducts();
    print(productsList.products);
  });
  test("Pay Pal list Subscription test", ()async{
    ListOfPayPalPlans allPlans = await payPal.listPlans();
    print(allPlans.plans);
  });
  //Subscription
  //---------------------------------------------------------------------------------------------
  test("Create subscription", ()async{
    String id = uniqueAlphanumeric(tokenLength: 30);
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
  });
  test("Update Plan and show plan details", ()async{
    ListOfPayPalPlans allPlans = await payPal.listPlans();
    await payPal.updatePlan(
      id:allPlans.plans.first.id, 
      operation: UpdateSubscriptionPlanOperation.replace,
      attributeToModify: UpdateSubscriptionPlanAttribute.description,
      newValue: "Mi perrito ladra",
    );
    SubscriptionPlan planWithDetails = await payPal.showPlanDetails(id: allPlans.plans.first.id);
    print(planWithDetails.description);
  });
  test("Activate and deactivate plans", ()async{
    ListOfPayPalPlans allPlans = await payPal.listPlans();
    //Deactivate function/method
    await payPal.deactivatePlan(id: allPlans.plans.first.id);
    SubscriptionPlan planWithDetails = await payPal.showPlanDetails(id: allPlans.plans.first.id);
    print(planWithDetails.status);
    //Activate function/method
    await payPal.activatePlan(id: allPlans.plans.first.id);
    planWithDetails = await payPal.showPlanDetails(id: allPlans.plans.first.id);
    print(planWithDetails.status);
  });
}
