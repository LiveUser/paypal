import 'package:paypal/paypal.dart';
import 'package:test/test.dart';
import 'package:power_plant/power_plant.dart';

void main() {
  const String appKey = "ATVaqMfNztzxCZlEb3qpe1B1WlZTuA46kmRQ96jPnVzpY7mqYYSa6OZlcdDe7jZ4OvxZR72GEhXmP-eD";
  const String appSecret = "EHaJ2X4x9w0ASDNOYmYFMVX8dO44VMSqfwDKvn6RJH5BXoDLtHm0wIfgdjyenr64_dmTRkFaZd0VUK1R";
  PayPal payPal = PayPal(
    clientID: appKey, 
    clientSecret: appSecret,
  );
  test("Get Access Token", ()async{
    PayPalAccessToken payPalAccessToken = await payPal.init();
    print(payPalAccessToken.access_token);
  });
  test("Get products list", ()async{
    PayPalProductsList productsList = await payPal.listProducts();
    print(productsList.products);
  });
  test("Create Product", ()async{
    String uniqueProductId = uniqueToken(tokenLength: 40);
    PayPalProduct createdProduct = await payPal.createProduct(
      prefer: Prefer.minimal,
      payPalRequestID: "test-sale-1", 
      id: uniqueProductId, 
      name: "Pay Pal Logo", 
      description: "The official logo of Pay Pal", 
      productType: ProductType.DIGITAL, 
      category: ProductCatogory.COMMERCIAL_PHOTOGRAPHY_ART_AND_GRAPHICS, 
      image_url: "https://www.paypalobjects.com/webstatic/mktg/logo/pp_cc_mark_74x46.jpg", 
      home_url: "http://domain.com/test/paypallogo.jpg",
    );
    print("Created " + createdProduct.name);
  });
}
