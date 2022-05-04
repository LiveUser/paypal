# Pay Pal
Unofficial pay pal SDK
Hecho en 🇵🇷 por Radamés J. Valentín Reyes
# Import
~~~dart
import 'package:paypal/paypal.dart';
~~~
--------------------------------------------------------
# Initiate an instance of PayPay
Uses the client ID and client secret to fetch an access token. init() Must be called before any other function. Tokens expire so this function has to be called again before expirations to avoid errors when performing API calls.
~~~dart
PayPal payPal = PayPal(
  clientID: appKey, 
  clientSecret: appSecret,
);
PayPalAccessToken payPalAccessToken = await payPal.init();
print(payPalAccessToken.access_token);
~~~
--------------------------------------------------------


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
- 