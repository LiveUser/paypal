library unofficial_paypal_sdk;

import 'package:sexy_api_client/sexy_api_client.dart';
import 'parsing.dart';
import 'dart:convert';

//Types
//----------------------------------------------------------------------
class PayPalAccessToken{
  PayPalAccessToken({
    required this.scope,
    required this.access_token,
    required this.token_type,
    required this.app_id,
    required this.expires_in,
    required this.nonce,
  });
  final String scope;
  final String access_token;
  final String token_type;
  final String app_id;
  final Duration expires_in;
  final String nonce;
  static PayPalAccessToken parse(Map<String,dynamic> parsedJSON){
    return PayPalAccessToken(
      scope: parsedJSON["scope"], 
      access_token: parsedJSON["access_token"], 
      token_type: parsedJSON["token_type"], 
      app_id: parsedJSON["app_id"], 
      expires_in: Duration(
        seconds: parsedJSON["expires_in"],
      ), 
      nonce: parsedJSON["nonce"],
    );
  }
}
class PayPalProductLink{
  PayPalProductLink({
    required this.href,
    required this.method,
    required this.rel,
  });
  final String href;
  final String rel;
  final String method;
  static List<PayPalProductLink> parseLinks(List<Map<String,dynamic>> links){
    List<PayPalProductLink> parsedLinks = [];
    for(Map<String,dynamic> link in links){
      parsedLinks.add(PayPalProductLink(
        href: link["href"], 
        method: link["method"],
        rel: link["rel"],
      ));
    }
    return parsedLinks;
  }
}
class PayPalProduct{
  PayPalProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.create_time,
    required this.links,
    required this.category,
  });
  final String id;
  final String name;
  final String? description;
  final String create_time;
  final List<PayPalProductLink> links;
  final String? category;
  static PayPalProduct parse(Map<String,dynamic> product){
    List<PayPalProductLink> links = [];
    for(Map<String,dynamic> link in product["links"]){
      links.add(PayPalProductLink(
        href: link["href"],
        method: link["method"],
        rel: link["rel"],
      ));
    }
    return PayPalProduct(
      id: product["id"], 
      name: product["name"], 
      description: product["description"], 
      create_time: product["create_time"], 
      links: links,
      category: product["category"],
    );
  }
}
class PayPalProductsList{
  PayPalProductsList({
    required this.total_items,
    required this.total_pages,
    required this.products,
  });
  final int total_items;
  final int total_pages;
  final List<PayPalProduct> products;
  static PayPalProductsList parse(Map<String,dynamic> parsedJSON){
    List<PayPalProduct> products = [];
    //Parse products
    for(Map<String,dynamic> product in parsedJSON["products"]){
      products.add(PayPalProduct.parse(product));
    }
    return PayPalProductsList(
      total_items: parsedJSON["total_items"], 
      total_pages: parsedJSON["total_pages"], 
      products: products,
    );
  }
}
class CreatedPayPalProduct{
  CreatedPayPalProduct({
    required this.id,
    required this.status,
    required this.links,
  });
  final String id;
  final String status;
  final List<PayPalProductLink> links;
}
class PayPalBillingPlan{
  PayPalBillingPlan({
    required this.id,
    required this.product_id,
    required this.status,
    required this.name,
    required this.description,
    required this.create_time,
    required this.links,
  });
  final String id;
  final String product_id;
  final String status;
  final String name;
  final String description;
  final String create_time;
  final List<PayPalProductLink> links;
}
class PayPalPlanId{
  PayPalPlanId({
    required this.plan_id,
  });
  final String plan_id;
}
class ListOfPayPalPlans{
  ListOfPayPalPlans({
    required this.total_items,
    required this.total_pages,
    required this.plans,
  });
  final int total_items;
  final int total_pages;
  final List<PayPalBillingPlan> plans;
}
class Frequency{
  Frequency({
    required this.interval_count,
    required this.interval_unit,
  });
  ///The possible values are:
  ///DAY. A daily billing cycle.
  ///WEEK. A weekly billing cycle.
  ///MONTH. A monthly billing cycle.
  ///YEAR. A yearly billing cycle.
  final String interval_unit;
  ///The number of intervals after which a subscriber is billed. For example, if the interval_unit is DAY with an interval_count of 2, the subscription is billed once every two days. The following table lists the maximum allowed values for the interval_count for each interval_unit:
  ///https://developer.paypal.com/docs/api/subscriptions/v1/#definition-frequency
  final interval_count;
}
class PricingScheme{
  PricingScheme({
    required this.currency_code,
    required this.value,
  });
  ///Amount
  final String value;
  final String currency_code;
}
class BillingCycle{
  BillingCycle({
    required this.frequency,
    required this.pricing_scheme,
    required this.sequence,
    required this.tenure_type,
    required this.total_cycles,
  });
  PricingScheme pricing_scheme;
  Frequency frequency;
  TenureType tenure_type;
  ///The order in which this cycle is to run among other billing cycles. For example, a trial billing cycle has a sequence of 1 while a regular billing cycle has a sequence of 2, so that trial cycle runs before the regular cycle.
  ///Minimum value: 1.
  ///Maximum value: 99.
  int sequence;
  ///The number of times this billing cycle gets executed. Trial billing cycles can only be executed a finite number of times (value between 1 and 999 for total_cycles). Regular billing cycles can be executed infinite times (value of 0 for total_cycles) or a finite number of times (value between 1 and 999 for total_cycles).
  ///Maximum value: 999.
  int total_cycles;
}
class SetupFee{
  SetupFee({
    required this.value,
    required this.currency_code,
  });
  ///Ammount
  String value;
  ///Something like USD,
  String currency_code;
}
class PaymentPreferences{
  PaymentPreferences({
    required this.auto_bill_outstanding,
    required this.setup_fee,
    required this.setup_fee_failure_action,
    required this.payment_failure_threshold,
  });
  ///Indicates whether to automatically bill the outstanding amount in the next billing cycle.
  final bool auto_bill_outstanding;
  ///The initial set-up fee for the service.
  final SetupFee setup_fee;
  ///The action to take on the subscription if the initial payment for the setup fails.
  final SetupFeeFailureAction setup_fee_failure_action;
  ///The maximum number of payment failures before a subscription is suspended. For example, if payment_failure_threshold is 2, the subscription automatically updates to the SUSPEND state if two consecutive payments fail.
  ///Maximum value: 999.
  final payment_failure_threshold;
}
class Taxes{
  Taxes({
    required this.percentage,
    required this.inclusive,
  });
  ///The tax percentage on the billing amount.
  final String percentage;
  ///Indicates whether the tax was already included in the billing amount.
  final bool inclusive;
}
class SubscriptionPlan{
  SubscriptionPlan({
    required this.id,
    required this.product_id,
    required this.name,
    required this.status,
    required this.description,
    required this.usage_type,
    required this.create_time,
    required this.links,
  });
  final String id;
  final String product_id;
  final String name;
  final String status;
  final String description;
  final String usage_type;
  final String create_time;
  final List<PayPalProductLink> links;
  static SubscriptionPlan parse(String json){
    Map<String,dynamic> parsedJSON = jsonDecode(json);
    List<PayPalProductLink> links = [];
    for(Map<String,dynamic> link in parsedJSON["links"]){
      links.add(PayPalProductLink(
        href: link["href"],
        method: link["method"],
        rel: link["rel"],
      ));
    }
    return SubscriptionPlan(
      id: parsedJSON["id"], 
      product_id: parsedJSON["product_id"], 
      name: parsedJSON["name"], 
      status: parsedJSON["status"], 
      description: parsedJSON["description"], 
      usage_type: parsedJSON["usage_type"], 
      create_time: parsedJSON["create_time"], 
      links: links,
    );
  }
}
//enums
//----------------------------------------------------------------------
enum SetupFeeFailureAction{
  ///Continues the subscription if the initial payment for the setup fails.
  CONTINUE,
  ///Cancels the subscription if the initial payment for the setup fails.
  CANCEL,
}
enum TenureType{
  REGULAR,
  TRIAL,
}
enum HttpStatusCodes{
  ///The request succeeded.
  ok200,
  ///A POST method successfully created a resource. If the resource was already created by a previous execution of the same method, for example, the server returns the HTTP 200 OK status code.
  created201,
  ///The server accepted the request and will execute it later.
  accepted202,
  ///The server successfully executed the method but returns no response body.
  noContent204,
}
enum Prefer{
  ///The server returns a minimal response to optimize communication between the API caller and the server. A minimal response includes the id, status and HATEOAS links.
  minimal,
  ///The server returns a complete resource representation, including the current state of the resource.
  representation,
}
enum ProductType{
  ///Physical goods.
  PHYSICAL,
  ///Digital goods.
  DIGITAL,
  ///A service. For example, technical support.
  SERVICE,
}
class ProductCatogory{
  static const String PHYSICAL = "PHYSICAL";
static const String DIGITAL = "DIGITAL";
static const String SERVICE = "SERVICE";
static const String AC_REFRIGERATION_REPAIR = "AC_REFRIGERATION_REPAIR";
static const String ACADEMIC_SOFTWARE = "ACADEMIC_SOFTWARE";
static const String ACCESSORIES = "ACCESSORIES";
static const String ACCOUNTING = "ACCOUNTING";
static const String ADULT = "ADULT";
static const String ADVERTISING = "ADVERTISING";
static const String AFFILIATED_AUTO_RENTAL = "AFFILIATED_AUTO_RENTAL";
static const String AGENCIES = "AGENCIES";
static const String AGGREGATORS = "AGGREGATORS";
static const String AGRICULTURAL_COOPERATIVE_FOR_MAIL_ORDER = "AGRICULTURAL_COOPERATIVE_FOR_MAIL_ORDER";
static const String AIR_CARRIERS_AIRLINES = "AIR_CARRIERS_AIRLINES";
static const String AIRPORTS_FLYING_FIELDS = "AIRPORTS_FLYING_FIELDS";
static const String ALCOHOLIC_BEVERAGES = "ALCOHOLIC_BEVERAGES";
static const String AMUSEMENT_PARKS_CARNIVALS = "AMUSEMENT_PARKS_CARNIVALS";
static const String ANIMATION = "ANIMATION";
static const String ANTIQUES = "ANTIQUES";
static const String APPLIANCES = "APPLIANCES";
static const String AQUARIAMS_SEAQUARIUMS_DOLPHINARIUMS = "AQUARIAMS_SEAQUARIUMS_DOLPHINARIUMS";
static const String ARCHITECTURAL_ENGINEERING_AND_SURVEYING_SERVICES = "ARCHITECTURAL_ENGINEERING_AND_SURVEYING_SERVICES";
static const String ART_AND_CRAFT_SUPPLIES = "ART_AND_CRAFT_SUPPLIES";
static const String ART_DEALERS_AND_GALLERIES = "ART_DEALERS_AND_GALLERIES";
static const String ARTIFACTS_GRAVE_RELATED_AND_NATIVE_AMERICAN_CRAFTS = "ARTIFACTS_GRAVE_RELATED_AND_NATIVE_AMERICAN_CRAFTS";
static const String ARTS_AND_CRAFTS = "ARTS_AND_CRAFTS";
static const String ARTS_CRAFTS_AND_COLLECTIBLES = "ARTS_CRAFTS_AND_COLLECTIBLES";
static const String AUDIO_BOOKS = "AUDIO_BOOKS";
static const String AUTO_ASSOCIATIONS_CLUBS = "AUTO_ASSOCIATIONS_CLUBS";
static const String AUTO_DEALER_USED_ONLY = "AUTO_DEALER_USED_ONLY";
static const String AUTO_RENTALS = "AUTO_RENTALS";
static const String AUTO_SERVICE = "AUTO_SERVICE";
static const String AUTOMATED_FUEL_DISPENSERS = "AUTOMATED_FUEL_DISPENSERS";
static const String AUTOMOBILE_ASSOCIATIONS = "AUTOMOBILE_ASSOCIATIONS";
static const String AUTOMOTIVE = "AUTOMOTIVE";
static const String AUTOMOTIVE_REPAIR_SHOPS_NON_DEALER = "AUTOMOTIVE_REPAIR_SHOPS_NON_DEALER";
static const String AUTOMOTIVE_TOP_AND_BODY_SHOPS = "AUTOMOTIVE_TOP_AND_BODY_SHOPS";
static const String AVIATION = "AVIATION";
static const String BABIES_CLOTHING_AND_SUPPLIES = "BABIES_CLOTHING_AND_SUPPLIES";
static const String BABY = "BABY";
static const String BANDS_ORCHESTRAS_ENTERTAINERS = "BANDS_ORCHESTRAS_ENTERTAINERS";
static const String BARBIES = "BARBIES";
static const String BATH_AND_BODY = "BATH_AND_BODY";
static const String BATTERIES = "BATTERIES";
static const String BEAN_BABIES = "BEAN_BABIES";
static const String BEAUTY = "BEAUTY";
static const String BEAUTY_AND_FRAGRANCES = "BEAUTY_AND_FRAGRANCES";
static const String BED_AND_BATH = "BED_AND_BATH";
static const String BICYCLE_SHOPS_SALES_AND_SERVICE = "BICYCLE_SHOPS_SALES_AND_SERVICE";
static const String BICYCLES_AND_ACCESSORIES = "BICYCLES_AND_ACCESSORIES";
static const String BILLIARD_POOL_ESTABLISHMENTS = "BILLIARD_POOL_ESTABLISHMENTS";
static const String BOAT_DEALERS = "BOAT_DEALERS";
static const String BOAT_RENTALS_AND_LEASING = "BOAT_RENTALS_AND_LEASING";
static const String BOATING_SAILING_AND_ACCESSORIES = "BOATING_SAILING_AND_ACCESSORIES";
static const String BOOKS_AND_MAGAZINES = "BOOKS_AND_MAGAZINES";
static const String BOOKS_MANUSCRIPTS = "BOOKS_MANUSCRIPTS";
static const String BOOKS_PERIODICALS_AND_NEWSPAPERS = "BOOKS_PERIODICALS_AND_NEWSPAPERS";
static const String BOWLING_ALLEYS = "BOWLING_ALLEYS";
static const String BULLETIN_BOARD = "BULLETIN_BOARD";
static const String BUS_LINE = "BUS_LINE";
static const String BUS_LINES_CHARTERS_TOUR_BUSES = "BUS_LINES_CHARTERS_TOUR_BUSES";
static const String BUSINESS = "BUSINESS";
static const String BUSINESS_AND_SECRETARIAL_SCHOOLS = "BUSINESS_AND_SECRETARIAL_SCHOOLS";
static const String BUYING_AND_SHOPPING_SERVICES_AND_CLUBS = "BUYING_AND_SHOPPING_SERVICES_AND_CLUBS";
static const String CABLE_SATELLITE_AND_OTHER_PAY_TELEVISION_AND_RADIO_SERVICES = "CABLE_SATELLITE_AND_OTHER_PAY_TELEVISION_AND_RADIO_SERVICES";
static const String CABLE_SATELLITE_AND_OTHER_PAY_TV_AND_RADIO = "CABLE_SATELLITE_AND_OTHER_PAY_TV_AND_RADIO";
static const String CAMERA_AND_PHOTOGRAPHIC_SUPPLIES = "CAMERA_AND_PHOTOGRAPHIC_SUPPLIES";
static const String CAMERAS = "CAMERAS";
static const String CAMERAS_AND_PHOTOGRAPHY = "CAMERAS_AND_PHOTOGRAPHY";
static const String CAMPER_RECREATIONAL_AND_UTILITY_TRAILER_DEALERS = "CAMPER_RECREATIONAL_AND_UTILITY_TRAILER_DEALERS";
static const String CAMPING_AND_OUTDOORS = "CAMPING_AND_OUTDOORS";
static const String CAMPING_AND_SURVIVAL = "CAMPING_AND_SURVIVAL";
static const String CAR_AND_TRUCK_DEALERS = "CAR_AND_TRUCK_DEALERS";
static const String CAR_AND_TRUCK_DEALERS_USED_ONLY = "CAR_AND_TRUCK_DEALERS_USED_ONLY";
static const String CAR_AUDIO_AND_ELECTRONICS = "CAR_AUDIO_AND_ELECTRONICS";
static const String CAR_RENTAL_AGENCY = "CAR_RENTAL_AGENCY";
static const String CATALOG_MERCHANT = "CATALOG_MERCHANT";
static const String CATALOG_RETAIL_MERCHANT = "CATALOG_RETAIL_MERCHANT";
static const String CATERING_SERVICES = "CATERING_SERVICES";
static const String CHARITY = "CHARITY";
static const String CHECK_CASHIER = "CHECK_CASHIER";
static const String CHILD_CARE_SERVICES = "CHILD_CARE_SERVICES";
static const String CHILDREN_BOOKS = "CHILDREN_BOOKS";
static const String CHIROPODISTS_PODIATRISTS = "CHIROPODISTS_PODIATRISTS";
static const String CHIROPRACTORS = "CHIROPRACTORS";
static const String CIGAR_STORES_AND_STANDS = "CIGAR_STORES_AND_STANDS";
static const String CIVIC_SOCIAL_FRATERNAL_ASSOCIATIONS = "CIVIC_SOCIAL_FRATERNAL_ASSOCIATIONS";
static const String CIVIL_SOCIAL_FRAT_ASSOCIATIONS = "CIVIL_SOCIAL_FRAT_ASSOCIATIONS";
static const String CLOTHING_ACCESSORIES_AND_SHOES = "CLOTHING_ACCESSORIES_AND_SHOES";
static const String CLOTHING_RENTAL = "CLOTHING_RENTAL";
static const String COFFEE_AND_TEA = "COFFEE_AND_TEA";
static const String COIN_OPERATED_BANKS_AND_CASINOS = "COIN_OPERATED_BANKS_AND_CASINOS";
static const String COLLECTION_AGENCY = "COLLECTION_AGENCY";
static const String COLLEGES_AND_UNIVERSITIES = "COLLEGES_AND_UNIVERSITIES";
static const String COMMERCIAL_EQUIPMENT = "COMMERCIAL_EQUIPMENT";
static const String COMMERCIAL_FOOTWEAR = "COMMERCIAL_FOOTWEAR";
static const String COMMERCIAL_PHOTOGRAPHY = "COMMERCIAL_PHOTOGRAPHY";
static const String COMMERCIAL_PHOTOGRAPHY_ART_AND_GRAPHICS = "COMMERCIAL_PHOTOGRAPHY_ART_AND_GRAPHICS";
static const String COMMERCIAL_SPORTS_PROFESSIONA = "COMMERCIAL_SPORTS_PROFESSIONA";
static const String COMMODITIES_AND_FUTURES_EXCHANGE = "COMMODITIES_AND_FUTURES_EXCHANGE";
static const String COMPUTER_AND_DATA_PROCESSING_SERVICES = "COMPUTER_AND_DATA_PROCESSING_SERVICES";
static const String COMPUTER_HARDWARE_AND_SOFTWARE = "COMPUTER_HARDWARE_AND_SOFTWARE";
static const String COMPUTER_MAINTENANCE_REPAIR_AND_SERVICES_NOT_ELSEWHERE_CLAS = "COMPUTER_MAINTENANCE_REPAIR_AND_SERVICES_NOT_ELSEWHERE_CLAS";
static const String CONSTRUCTION = "CONSTRUCTION";
static const String CONSTRUCTION_MATERIALS_NOT_ELSEWHERE_CLASSIFIED = "CONSTRUCTION_MATERIALS_NOT_ELSEWHERE_CLASSIFIED";
static const String CONSULTING_SERVICES = "CONSULTING_SERVICES";
static const String CONSUMER_CREDIT_REPORTING_AGENCIES = "CONSUMER_CREDIT_REPORTING_AGENCIES";
static const String CONVALESCENT_HOMES = "CONVALESCENT_HOMES";
static const String COSMETIC_STORES = "COSMETIC_STORES";
static const String COUNSELING_SERVICES_DEBT_MARRIAGE_PERSONAL = "COUNSELING_SERVICES_DEBT_MARRIAGE_PERSONAL";
static const String COUNTERFEIT_CURRENCY_AND_STAMPS = "COUNTERFEIT_CURRENCY_AND_STAMPS";
static const String COUNTERFEIT_ITEMS = "COUNTERFEIT_ITEMS";
static const String COUNTRY_CLUBS = "COUNTRY_CLUBS";
static const String COURIER_SERVICES = "COURIER_SERVICES";
static const String COURIER_SERVICES_AIR_AND_GROUND_AND_FREIGHT_FORWARDERS = "COURIER_SERVICES_AIR_AND_GROUND_AND_FREIGHT_FORWARDERS";
static const String COURT_COSTS_ALIMNY_CHILD_SUPT = "COURT_COSTS_ALIMNY_CHILD_SUPT";
static const String COURT_COSTS_INCLUDING_ALIMONY_AND_CHILD_SUPPORT_COURTS_OF_LAW = "COURT_COSTS_INCLUDING_ALIMONY_AND_CHILD_SUPPORT_COURTS_OF_LAW";
static const String CREDIT_CARDS = "CREDIT_CARDS";
static const String CREDIT_UNION = "CREDIT_UNION";
static const String CULTURE_AND_RELIGION = "CULTURE_AND_RELIGION";
static const String DAIRY_PRODUCTS_STORES = "DAIRY_PRODUCTS_STORES";
static const String DANCE_HALLS_STUDIOS_AND_SCHOOLS = "DANCE_HALLS_STUDIOS_AND_SCHOOLS";
static const String DECORATIVE = "DECORATIVE";
static const String DENTAL = "DENTAL";
static const String DENTISTS_AND_ORTHODONTISTS = "DENTISTS_AND_ORTHODONTISTS";
static const String DEPARTMENT_STORES = "DEPARTMENT_STORES";
static const String DESKTOP_PCS = "DESKTOP_PCS";
static const String DEVICES = "DEVICES";
static const String DIECAST_TOYS_VEHICLES = "DIECAST_TOYS_VEHICLES";
static const String DIGITAL_GAMES = "DIGITAL_GAMES";
static const String DIGITAL_MEDIA_BOOKS_MOVIES_MUSIC = "DIGITAL_MEDIA_BOOKS_MOVIES_MUSIC";
static const String DIRECT_MARKETING = "DIRECT_MARKETING";
static const String DIRECT_MARKETING_CATALOG_MERCHANT = "DIRECT_MARKETING_CATALOG_MERCHANT";
static const String DIRECT_MARKETING_INBOUND_TELE = "DIRECT_MARKETING_INBOUND_TELE";
static const String DIRECT_MARKETING_OUTBOUND_TELE = "DIRECT_MARKETING_OUTBOUND_TELE";
static const String DIRECT_MARKETING_SUBSCRIPTION = "DIRECT_MARKETING_SUBSCRIPTION";
static const String DISCOUNT_STORES = "DISCOUNT_STORES";
static const String DOOR_TO_DOOR_SALES = "DOOR_TO_DOOR_SALES";
static const String DRAPERY_WINDOW_COVERING_AND_UPHOLSTERY = "DRAPERY_WINDOW_COVERING_AND_UPHOLSTERY";
static const String DRINKING_PLACES = "DRINKING_PLACES";
static const String DRUGSTORE = "DRUGSTORE";
static const String DURABLE_GOODS = "DURABLE_GOODS";
static const String ECOMMERCE_DEVELOPMENT = "ECOMMERCE_DEVELOPMENT";
static const String ECOMMERCE_SERVICES = "ECOMMERCE_SERVICES";
static const String EDUCATIONAL_AND_TEXTBOOKS = "EDUCATIONAL_AND_TEXTBOOKS";
static const String ELECTRIC_RAZOR_STORES = "ELECTRIC_RAZOR_STORES";
static const String ELECTRICAL_AND_SMALL_APPLIANCE_REPAIR = "ELECTRICAL_AND_SMALL_APPLIANCE_REPAIR";
static const String ELECTRICAL_CONTRACTORS = "ELECTRICAL_CONTRACTORS";
static const String ELECTRICAL_PARTS_AND_EQUIPMENT = "ELECTRICAL_PARTS_AND_EQUIPMENT";
static const String ELECTRONIC_CASH = "ELECTRONIC_CASH";
static const String ELEMENTARY_AND_SECONDARY_SCHOOLS = "ELEMENTARY_AND_SECONDARY_SCHOOLS";
static const String EMPLOYMENT = "EMPLOYMENT";
static const String ENTERTAINMENT_AND_MEDIA = "ENTERTAINMENT_AND_MEDIA";
static const String EQUIP_TOOL_FURNITURE_AND_APPLIANCE_RENTAL_AND_LEASING = "EQUIP_TOOL_FURNITURE_AND_APPLIANCE_RENTAL_AND_LEASING";
static const String ESCROW = "ESCROW";
static const String EVENT_AND_WEDDING_PLANNING = "EVENT_AND_WEDDING_PLANNING";
static const String EXERCISE_AND_FITNESS = "EXERCISE_AND_FITNESS";
static const String EXERCISE_EQUIPMENT = "EXERCISE_EQUIPMENT";
static const String EXTERMINATING_AND_DISINFECTING_SERVICES = "EXTERMINATING_AND_DISINFECTING_SERVICES";
static const String FABRICS_AND_SEWING = "FABRICS_AND_SEWING";
static const String FAMILY_CLOTHING_STORES = "FAMILY_CLOTHING_STORES";
static const String FASHION_JEWELRY = "FASHION_JEWELRY";
static const String FAST_FOOD_RESTAURANTS = "FAST_FOOD_RESTAURANTS";
static const String FICTION_AND_NONFICTION = "FICTION_AND_NONFICTION";
static const String FINANCE_COMPANY = "FINANCE_COMPANY";
static const String FINANCIAL_AND_INVESTMENT_ADVICE = "FINANCIAL_AND_INVESTMENT_ADVICE";
static const String FINANCIAL_INSTITUTIONS_MERCHANDISE_AND_SERVICES = "FINANCIAL_INSTITUTIONS_MERCHANDISE_AND_SERVICES";
static const String FIREARM_ACCESSORIES = "FIREARM_ACCESSORIES";
static const String FIREARMS_WEAPONS_AND_KNIVES = "FIREARMS_WEAPONS_AND_KNIVES";
static const String FIREPLACE_AND_FIREPLACE_SCREENS = "FIREPLACE_AND_FIREPLACE_SCREENS";
static const String FIREWORKS = "FIREWORKS";
static const String FISHING = "FISHING";
static const String FLORISTS = "FLORISTS";
static const String FLOWERS = "FLOWERS";
static const String FOOD_DRINK_AND_NUTRITION = "FOOD_DRINK_AND_NUTRITION";
static const String FOOD_PRODUCTS = "FOOD_PRODUCTS";
static const String FOOD_RETAIL_AND_SERVICE = "FOOD_RETAIL_AND_SERVICE";
static const String FRAGRANCES_AND_PERFUMES = "FRAGRANCES_AND_PERFUMES";
static const String FREEZER_AND_LOCKER_MEAT_PROVISIONERS = "FREEZER_AND_LOCKER_MEAT_PROVISIONERS";
static const String FUEL_DEALERS_FUEL_OIL_WOOD_AND_COAL = "FUEL_DEALERS_FUEL_OIL_WOOD_AND_COAL";
static const String FUEL_DEALERS_NON_AUTOMOTIVE = "FUEL_DEALERS_NON_AUTOMOTIVE";
static const String FUNERAL_SERVICES_AND_CREMATORIES = "FUNERAL_SERVICES_AND_CREMATORIES";
static const String FURNISHING_AND_DECORATING = "FURNISHING_AND_DECORATING";
static const String FURRIERS_AND_FUR_SHOPS = "FURRIERS_AND_FUR_SHOPS";
static const String GADGETS_AND_OTHER_ELECTRONICS = "GADGETS_AND_OTHER_ELECTRONICS";
static const String GAMBLING = "GAMBLING";
static const String GAME_SOFTWARE = "GAME_SOFTWARE";
static const String GARDEN_SUPPLIES = "GARDEN_SUPPLIES";
static const String GENERAL = "GENERAL";
static const String GENERAL_CONTRACTORS = "GENERAL_CONTRACTORS";
static const String GENERAL_GOVERNMENT = "GENERAL_GOVERNMENT";
static const String GENERAL_SOFTWARE = "GENERAL_SOFTWARE";
static const String GENERAL_TELECOM = "GENERAL_TELECOM";
static const String GIFTS_AND_FLOWERS = "GIFTS_AND_FLOWERS";
static const String GLASS_PAINT_AND_WALLPAPER_STORES = "GLASS_PAINT_AND_WALLPAPER_STORES";
static const String GLASSWARE_CRYSTAL_STORES = "GLASSWARE_CRYSTAL_STORES";
static const String GOVERNMENT_IDS_AND_LICENSES = "GOVERNMENT_IDS_AND_LICENSES";
static const String GOVERNMENT_LICENSED_ON_LINE_CASINOS_ON_LINE_GAMBLING = "GOVERNMENT_LICENSED_ON_LINE_CASINOS_ON_LINE_GAMBLING";
static const String GOVERNMENT_OWNED_LOTTERIES = "GOVERNMENT_OWNED_LOTTERIES";
static const String GOVERNMENT_SERVICES = "GOVERNMENT_SERVICES";
static const String GRAPHIC_AND_COMMERCIAL_DESIGN = "GRAPHIC_AND_COMMERCIAL_DESIGN";
static const String GREETING_CARDS = "GREETING_CARDS";
static const String GROCERY_STORES_AND_SUPERMARKETS = "GROCERY_STORES_AND_SUPERMARKETS";
static const String HARDWARE_AND_TOOLS = "HARDWARE_AND_TOOLS";
static const String HARDWARE_EQUIPMENT_AND_SUPPLIES = "HARDWARE_EQUIPMENT_AND_SUPPLIES";
static const String HAZARDOUS_RESTRICTED_AND_PERISHABLE_ITEMS = "HAZARDOUS_RESTRICTED_AND_PERISHABLE_ITEMS";
static const String HEALTH_AND_BEAUTY_SPAS = "HEALTH_AND_BEAUTY_SPAS";
static const String HEALTH_AND_NUTRITION = "HEALTH_AND_NUTRITION";
static const String HEALTH_AND_PERSONAL_CARE = "HEALTH_AND_PERSONAL_CARE";
static const String HEARING_AIDS_SALES_AND_SUPPLIES = "HEARING_AIDS_SALES_AND_SUPPLIES";
static const String HEATING_PLUMBING_AC = "HEATING_PLUMBING_AC";
static const String HIGH_RISK_MERCHANT = "HIGH_RISK_MERCHANT";
static const String HIRING_SERVICES = "HIRING_SERVICES";
static const String HOBBIES_TOYS_AND_GAMES = "HOBBIES_TOYS_AND_GAMES";
static const String HOME_AND_GARDEN = "HOME_AND_GARDEN";
static const String HOME_AUDIO = "HOME_AUDIO";
static const String HOME_DECOR = "HOME_DECOR";
static const String HOME_ELECTRONICS = "HOME_ELECTRONICS";
static const String HOSPITALS = "HOSPITALS";
static const String HOTELS_MOTELS_INNS_RESORTS = "HOTELS_MOTELS_INNS_RESORTS";
static const String HOUSEWARES = "HOUSEWARES";
static const String HUMAN_PARTS_AND_REMAINS = "HUMAN_PARTS_AND_REMAINS";
static const String HUMOROUS_GIFTS_AND_NOVELTIES = "HUMOROUS_GIFTS_AND_NOVELTIES";
static const String HUNTING = "HUNTING";
static const String IDS_LICENSES_AND_PASSPORTS = "IDS_LICENSES_AND_PASSPORTS";
static const String ILLEGAL_DRUGS_AND_PARAPHERNALIA = "ILLEGAL_DRUGS_AND_PARAPHERNALIA";
static const String INDUSTRIAL = "INDUSTRIAL";
static const String INDUSTRIAL_AND_MANUFACTURING_SUPPLIES = "INDUSTRIAL_AND_MANUFACTURING_SUPPLIES";
static const String INSURANCE_AUTO_AND_HOME = "INSURANCE_AUTO_AND_HOME";
static const String INSURANCE_DIRECT = "INSURANCE_DIRECT";
static const String INSURANCE_LIFE_AND_ANNUITY = "INSURANCE_LIFE_AND_ANNUITY";
static const String INSURANCE_SALES_UNDERWRITING = "INSURANCE_SALES_UNDERWRITING";
static const String INSURANCE_UNDERWRITING_PREMIUMS = "INSURANCE_UNDERWRITING_PREMIUMS";
static const String INTERNET_AND_NETWORK_SERVICES = "INTERNET_AND_NETWORK_SERVICES";
static const String INTRA_COMPANY_PURCHASES = "INTRA_COMPANY_PURCHASES";
static const String LABORATORIES_DENTAL_MEDICAL = "LABORATORIES_DENTAL_MEDICAL";
static const String LANDSCAPING = "LANDSCAPING";
static const String LANDSCAPING_AND_HORTICULTURAL_SERVICES = "LANDSCAPING_AND_HORTICULTURAL_SERVICES";
static const String LAUNDRY_CLEANING_SERVICES = "LAUNDRY_CLEANING_SERVICES";
static const String LEGAL_SERVICES_AND_ATTORNEYS = "LEGAL_SERVICES_AND_ATTORNEYS";
static const String LOCAL_DELIVERY_SERVICE = "LOCAL_DELIVERY_SERVICE";
static const String LOCKSMITH = "LOCKSMITH";
static const String LODGING_AND_ACCOMMODATIONS = "LODGING_AND_ACCOMMODATIONS";
static const String LOTTERY_AND_CONTESTS = "LOTTERY_AND_CONTESTS";
static const String LUGGAGE_AND_LEATHER_GOODS = "LUGGAGE_AND_LEATHER_GOODS";
static const String LUMBER_AND_BUILDING_MATERIALS = "LUMBER_AND_BUILDING_MATERIALS";
static const String MAINTENANCE_AND_REPAIR_SERVICES = "MAINTENANCE_AND_REPAIR_SERVICES";
static const String MAKEUP_AND_COSMETICS = "MAKEUP_AND_COSMETICS";
static const String MANUAL_CASH_DISBURSEMENTS = "MANUAL_CASH_DISBURSEMENTS";
static const String MASSAGE_PARLORS = "MASSAGE_PARLORS";
static const String MEDICAL_AND_PHARMACEUTICAL = "MEDICAL_AND_PHARMACEUTICAL";
static const String MEDICAL_CARE = "MEDICAL_CARE";
static const String MEDICAL_EQUIPMENT_AND_SUPPLIES = "MEDICAL_EQUIPMENT_AND_SUPPLIES";
static const String MEDICAL_SERVICES = "MEDICAL_SERVICES";
static const String MEETING_PLANNERS = "MEETING_PLANNERS";
static const String MEMBERSHIP_CLUBS_AND_ORGANIZATIONS = "MEMBERSHIP_CLUBS_AND_ORGANIZATIONS";
static const String MEMBERSHIP_COUNTRY_CLUBS_GOLF = "MEMBERSHIP_COUNTRY_CLUBS_GOLF";
static const String MEMORABILIA = "MEMORABILIA";
static const String MEN_AND_BOY_CLOTHING_AND_ACCESSORY_STORES = "MEN_AND_BOY_CLOTHING_AND_ACCESSORY_STORES";
static const String MEN_CLOTHING = "MEN_CLOTHING";
static const String METAPHYSICAL = "METAPHYSICAL";
static const String MILITARIA = "MILITARIA";
static const String MILITARY_AND_CIVIL_SERVICE_UNIFORMS = "MILITARY_AND_CIVIL_SERVICE_UNIFORMS";
static const String MISC_AUTOMOTIVE_AIRCRAFT_AND_FARM_EQUIPMENT_DEALERS = "MISC._AUTOMOTIVE_AIRCRAFT_AND_FARM_EQUIPMENT_DEALERS";
static const String MISC_GENERAL_MERCHANDISE = "MISC._GENERAL_MERCHANDISE";
static const String MISCELLANEOUS_GENERAL_SERVICES = "MISCELLANEOUS_GENERAL_SERVICES";
static const String MISCELLANEOUS_REPAIR_SHOPS_AND_RELATED_SERVICES = "MISCELLANEOUS_REPAIR_SHOPS_AND_RELATED_SERVICES";
static const String MODEL_KITS = "MODEL_KITS";
static const String MONEY_TRANSFER_MEMBER_FINANCIAL_INSTITUTION = "MONEY_TRANSFER_MEMBER_FINANCIAL_INSTITUTION";
static const String MONEY_TRANSFER_MERCHANT = "MONEY_TRANSFER_MERCHANT";
static const String MOTION_PICTURE_THEATERS = "MOTION_PICTURE_THEATERS";
static const String MOTOR_FREIGHT_CARRIERS_AND_TRUCKING = "MOTOR_FREIGHT_CARRIERS_AND_TRUCKING";
static const String MOTOR_HOME_AND_RECREATIONAL_VEHICLE_RENTAL = "MOTOR_HOME_AND_RECREATIONAL_VEHICLE_RENTAL";
static const String MOTOR_HOMES_DEALERS = "MOTOR_HOMES_DEALERS";
static const String MOTOR_VEHICLE_SUPPLIES_AND_NEW_PARTS = "MOTOR_VEHICLE_SUPPLIES_AND_NEW_PARTS";
static const String MOTORCYCLE_DEALERS = "MOTORCYCLE_DEALERS";
static const String MOTORCYCLES = "MOTORCYCLES";
static const String MOVIE_TICKETS = "MOVIE_TICKETS";
static const String MOVING_AND_STORAGE = "MOVING_AND_STORAGE";
static const String MULTI_LEVEL_MARKETING = "MULTI_LEVEL_MARKETING";
static const String MUSIC_CDS_CASSETTES_AND_ALBUMS = "MUSIC_CDS_CASSETTES_AND_ALBUMS";
static const String MUSIC_STORE_INSTRUMENTS_AND_SHEET_MUSIC = "MUSIC_STORE_INSTRUMENTS_AND_SHEET_MUSIC";
static const String NETWORKING = "NETWORKING";
static const String NEW_AGE = "NEW_AGE";
static const String NEW_PARTS_AND_SUPPLIES_MOTOR_VEHICLE = "NEW_PARTS_AND_SUPPLIES_MOTOR_VEHICLE";
static const String NEWS_DEALERS_AND_NEWSTANDS = "NEWS_DEALERS_AND_NEWSTANDS";
static const String NON_DURABLE_GOODS = "NON_DURABLE_GOODS";
static const String NON_FICTION = "NON_FICTION";
static const String NON_PROFIT_POLITICAL_AND_RELIGION = "NON_PROFIT_POLITICAL_AND_RELIGION";
static const String NONPROFIT = "NONPROFIT";
static const String OEM_SOFTWARE = "OEM_SOFTWARE";
static const String OFFICE_SUPPLIES_AND_EQUIPMENT = "OFFICE_SUPPLIES_AND_EQUIPMENT";
static const String ONLINE_DATING = "ONLINE_DATING";
static const String ONLINE_GAMING = "ONLINE_GAMING";
static const String ONLINE_GAMING_CURRENCY = "ONLINE_GAMING_CURRENCY";
static const String ONLINE_SERVICES = "ONLINE_SERVICES";
static const String OOUTBOUND_TELEMARKETING_MERCH = "OOUTBOUND_TELEMARKETING_MERCH";
static const String OPHTHALMOLOGISTS_OPTOMETRIST = "OPHTHALMOLOGISTS_OPTOMETRIST";
static const String OPTICIANS_AND_DISPENSING = "OPTICIANS_AND_DISPENSING";
static const String ORTHOPEDIC_GOODS_PROSTHETICS = "ORTHOPEDIC_GOODS_PROSTHETICS";
static const String OSTEOPATHS = "OSTEOPATHS";
static const String PACKAGE_TOUR_OPERATORS = "PACKAGE_TOUR_OPERATORS";
static const String PAINTBALL = "PAINTBALL";
static const String PAINTS_VARNISHES_AND_SUPPLIES = "PAINTS_VARNISHES_AND_SUPPLIES";
static const String PARKING_LOTS_AND_GARAGES = "PARKING_LOTS_AND_GARAGES";
static const String PARTS_AND_ACCESSORIES = "PARTS_AND_ACCESSORIES";
static const String PAWN_SHOPS = "PAWN_SHOPS";
static const String PAYCHECK_LENDER_OR_CASH_ADVANCE = "PAYCHECK_LENDER_OR_CASH_ADVANCE";
static const String PERIPHERALS = "PERIPHERALS";
static const String PERSONALIZED_GIFTS = "PERSONALIZED_GIFTS";
static const String PET_SHOPS_PET_FOOD_AND_SUPPLIES = "PET_SHOPS_PET_FOOD_AND_SUPPLIES";
static const String PETROLEUM_AND_PETROLEUM_PRODUCTS = "PETROLEUM_AND_PETROLEUM_PRODUCTS";
static const String PETS_AND_ANIMALS = "PETS_AND_ANIMALS";
static const String PHOTOFINISHING_LABORATORIES_PHOTO_DEVELOPING = "PHOTOFINISHING_LABORATORIES_PHOTO_DEVELOPING";
static const String PHOTOGRAPHIC_STUDIOS_PORTRAITS = "PHOTOGRAPHIC_STUDIOS_PORTRAITS";
static const String PHYSICAL_GOOD = "PHYSICAL_GOOD";
static const String PICTURE_VIDEO_PRODUCTION = "PICTURE_VIDEO_PRODUCTION";
static const String PIECE_GOODS_NOTIONS_AND_OTHER_DRY_GOODS = "PIECE_GOODS_NOTIONS_AND_OTHER_DRY_GOODS";
static const String PLANTS_AND_SEEDS = "PLANTS_AND_SEEDS";
static const String PLUMBING_AND_HEATING_EQUIPMENTS_AND_SUPPLIES = "PLUMBING_AND_HEATING_EQUIPMENTS_AND_SUPPLIES";
static const String POLICE_RELATED_ITEMS = "POLICE_RELATED_ITEMS";
static const String POLITICAL_ORGANIZATIONS = "POLITICAL_ORGANIZATIONS";
static const String POSTAL_SERVICES_GOVERNMENT_ONLY = "POSTAL_SERVICES_GOVERNMENT_ONLY";
static const String POSTERS = "POSTERS";
static const String PREPAID_AND_STORED_VALUE_CARDS = "PREPAID_AND_STORED_VALUE_CARDS";
static const String PRESCRIPTION_DRUGS = "PRESCRIPTION_DRUGS";
static const String PROMOTIONAL_ITEMS = "PROMOTIONAL_ITEMS";
static const String PUBLIC_WAREHOUSING_AND_STORAGE = "PUBLIC_WAREHOUSING_AND_STORAGE";
static const String PUBLISHING_AND_PRINTING = "PUBLISHING_AND_PRINTING";
static const String PUBLISHING_SERVICES = "PUBLISHING_SERVICES";
static const String RADAR_DECTORS = "RADAR_DECTORS";
static const String RADIO_TELEVISION_AND_STEREO_REPAIR = "RADIO_TELEVISION_AND_STEREO_REPAIR";
static const String REAL_ESTATE = "REAL_ESTATE";
static const String REAL_ESTATE_AGENT = "REAL_ESTATE_AGENT";
static const String REAL_ESTATE_AGENTS_AND_MANAGERS_RENTALS = "REAL_ESTATE_AGENTS_AND_MANAGERS_RENTALS";
static const String RELIGION_AND_SPIRITUALITY_FOR_PROFIT = "RELIGION_AND_SPIRITUALITY_FOR_PROFIT";
static const String RELIGIOUS = "RELIGIOUS";
static const String RELIGIOUS_ORGANIZATIONS = "RELIGIOUS_ORGANIZATIONS";
static const String REMITTANCE = "REMITTANCE";
static const String RENTAL_PROPERTY_MANAGEMENT = "RENTAL_PROPERTY_MANAGEMENT";
static const String RESIDENTIAL = "RESIDENTIAL";
static const String RETAIL_FINE_JEWELRY_AND_WATCHES = "RETAIL_FINE_JEWELRY_AND_WATCHES";
static const String REUPHOLSTERY_AND_FURNITURE_REPAIR = "REUPHOLSTERY_AND_FURNITURE_REPAIR";
static const String RINGS = "RINGS";
static const String ROOFING_SIDING_SHEET_METAL = "ROOFING_SIDING_SHEET_METAL";
static const String RUGS_AND_CARPETS = "RUGS_AND_CARPETS";
static const String SCHOOLS_AND_COLLEGES = "SCHOOLS_AND_COLLEGES";
static const String SCIENCE_FICTION = "SCIENCE_FICTION";
static const String SCRAPBOOKING = "SCRAPBOOKING";
static const String SCULPTURES = "SCULPTURES";
static const String SECURITIES_BROKERS_AND_DEALERS = "SECURITIES_BROKERS_AND_DEALERS";
static const String SECURITY_AND_SURVEILLANCE = "SECURITY_AND_SURVEILLANCE";
static const String SECURITY_AND_SURVEILLANCE_EQUIPMENT = "SECURITY_AND_SURVEILLANCE_EQUIPMENT";
static const String SECURITY_BROKERS_AND_DEALERS = "SECURITY_BROKERS_AND_DEALERS";
static const String SEMINARS = "SEMINARS";
static const String SERVICE_STATIONS = "SERVICE_STATIONS";
static const String SEWING_NEEDLEWORK_FABRIC_AND_PIECE_GOODS_STORES = "SEWING_NEEDLEWORK_FABRIC_AND_PIECE_GOODS_STORES";
static const String SHIPPING_AND_PACKING = "SHIPPING_AND_PACKING";
static const String SHOE_REPAIR_HAT_CLEANING = "SHOE_REPAIR_HAT_CLEANING";
static const String SHOE_STORES = "SHOE_STORES";
static const String SNOWMOBILE_DEALERS = "SNOWMOBILE_DEALERS";
static const String SPECIALTY_AND_MISC_FOOD_STORES = "SPECIALTY_AND_MISC._FOOD_STORES";
static const String SPECIALTY_CLEANING_POLISHING_AND_SANITATION_PREPARATIONS = "SPECIALTY_CLEANING_POLISHING_AND_SANITATION_PREPARATIONS";
static const String SPECIALTY_OR_RARE_PETS = "SPECIALTY_OR_RARE_PETS";
static const String SPORT_GAMES_AND_TOYS = "SPORT_GAMES_AND_TOYS";
static const String SPORTING_AND_RECREATIONAL_CAMPS = "SPORTING_AND_RECREATIONAL_CAMPS";
static const String SPORTING_GOODS = "SPORTING_GOODS";
static const String SPORTS_AND_OUTDOORS = "SPORTS_AND_OUTDOORS";
static const String SPORTS_AND_RECREATION = "SPORTS_AND_RECREATION";
static const String STAMP_AND_COIN = "STAMP_AND_COIN";
static const String STATIONARY_PRINTING_AND_WRITING_PAPER = "STATIONARY_PRINTING_AND_WRITING_PAPER";
static const String STENOGRAPHIC_AND_SECRETARIAL_SUPPORT_SERVICES = "STENOGRAPHIC_AND_SECRETARIAL_SUPPORT_SERVICES";
static const String STOCKS_BONDS_SECURITIES_AND_RELATED_CERTIFICATES = "STOCKS_BONDS_SECURITIES_AND_RELATED_CERTIFICATES";
static const String SUPPLIES_AND_TOYS = "SUPPLIES_AND_TOYS";
static const String SWIMMING_POOLS_AND_SPAS = "SWIMMING_POOLS_AND_SPAS";
static const String SWIMMING_POOLS_SALES_SUPPLIES_SERVICES = "SWIMMING_POOLS_SALES_SUPPLIES_SERVICES";
static const String TAILORS_AND_ALTERATIONS = "TAILORS_AND_ALTERATIONS";
static const String TAX_PAYMENTS = "TAX_PAYMENTS";
static const String TAX_PAYMENTS_GOVERNMENT_AGENCIES = "TAX_PAYMENTS_GOVERNMENT_AGENCIES";
static const String TAXICABS_AND_LIMOUSINES = "TAXICABS_AND_LIMOUSINES";
static const String TELECOMMUNICATION_SERVICES = "TELECOMMUNICATION_SERVICES";
static const String TELEPHONE_CARDS = "TELEPHONE_CARDS";
static const String TELEPHONE_EQUIPMENT = "TELEPHONE_EQUIPMENT";
static const String TELEPHONE_SERVICES = "TELEPHONE_SERVICES";
static const String TIRE_RETREADING_AND_REPAIR = "TIRE_RETREADING_AND_REPAIR";
static const String TOLL_OR_BRIDGE_FEES = "TOLL_OR_BRIDGE_FEES";
static const String TOOLS_AND_EQUIPMENT = "TOOLS_AND_EQUIPMENT";
static const String TOURIST_ATTRACTIONS_AND_EXHIBITS = "TOURIST_ATTRACTIONS_AND_EXHIBITS";
static const String TOWING_SERVICE = "TOWING_SERVICE";
static const String TRADE_AND_VOCATIONAL_SCHOOLS = "TRADE_AND_VOCATIONAL_SCHOOLS";
static const String TRADEMARK_INFRINGEMENT = "TRADEMARK_INFRINGEMENT";
static const String TRAILER_PARKS_AND_CAMPGROUNDS = "TRAILER_PARKS_AND_CAMPGROUNDS";
static const String TRAINING_SERVICES = "TRAINING_SERVICES";
static const String TRANSPORTATION_SERVICES = "TRANSPORTATION_SERVICES";
static const String TRAVEL = "TRAVEL";
static const String TRUCK_AND_UTILITY_TRAILER_RENTALS = "TRUCK_AND_UTILITY_TRAILER_RENTALS";
static const String TRUCK_STOP = "TRUCK_STOP";
static const String TYPESETTING_PLATE_MAKING_AND_RELATED_SERVICES = "TYPESETTING_PLATE_MAKING_AND_RELATED_SERVICES";
static const String USED_MERCHANDISE_AND_SECONDHAND_STORES = "USED_MERCHANDISE_AND_SECONDHAND_STORES";
static const String USED_PARTS_MOTOR_VEHICLE = "USED_PARTS_MOTOR_VEHICLE";
static const String UTILITIES = "UTILITIES";
static const String UTILITIES_ELECTRIC_GAS_WATER_SANITARY = "UTILITIES_ELECTRIC_GAS_WATER_SANITARY";
static const String VARIETY_STORES = "VARIETY_STORES";
static const String VEHICLE_SALES = "VEHICLE_SALES";
static const String VEHICLE_SERVICE_AND_ACCESSORIES = "VEHICLE_SERVICE_AND_ACCESSORIES";
static const String VIDEO_EQUIPMENT = "VIDEO_EQUIPMENT";
static const String VIDEO_GAME_ARCADES_ESTABLISH = "VIDEO_GAME_ARCADES_ESTABLISH";
static const String VIDEO_GAMES_AND_SYSTEMS = "VIDEO_GAMES_AND_SYSTEMS";
static const String VIDEO_TAPE_RENTAL_STORES = "VIDEO_TAPE_RENTAL_STORES";
static const String VINTAGE_AND_COLLECTIBLE_VEHICLES = "VINTAGE_AND_COLLECTIBLE_VEHICLES";
static const String VINTAGE_AND_COLLECTIBLES = "VINTAGE_AND_COLLECTIBLES";
static const String VITAMINS_AND_SUPPLEMENTS = "VITAMINS_AND_SUPPLEMENTS";
static const String VOCATIONAL_AND_TRADE_SCHOOLS = "VOCATIONAL_AND_TRADE_SCHOOLS";
static const String WATCH_CLOCK_AND_JEWELRY_REPAIR = "WATCH_CLOCK_AND_JEWELRY_REPAIR";
static const String WEB_HOSTING_AND_DESIGN = "WEB_HOSTING_AND_DESIGN";
static const String WELDING_REPAIR = "WELDING_REPAIR";
static const String WHOLESALE_CLUBS = "WHOLESALE_CLUBS";
static const String WHOLESALE_FLORIST_SUPPLIERS = "WHOLESALE_FLORIST_SUPPLIERS";
static const String WHOLESALE_PRESCRIPTION_DRUGS = "WHOLESALE_PRESCRIPTION_DRUGS";
static const String WILDLIFE_PRODUCTS = "WILDLIFE_PRODUCTS";
static const String WIRE_TRANSFER = "WIRE_TRANSFER";
static const String WIRE_TRANSFER_AND_MONEY_ORDER = "WIRE_TRANSFER_AND_MONEY_ORDER";
static const String WOMEN_ACCESSORY_SPECIALITY = "WOMEN_ACCESSORY_SPECIALITY";
static const String WOMEN_CLOTHING = "WOMEN_CLOTHING";
static const String add = "add";
static const String remove = "remove";
static const String replace = "replace";
static const String copy = "copy";
static const String test = "test";
}
//Generic Functions
//----------------------------------------------------------------------
Map<String,dynamic> _parseResponse(String json){
  Map<String,dynamic> parsedJSON = jsonDecode(json);
  if(parsedJSON["error"] != null){
    throw parsedJSON;
  }else{
    return parsedJSON;
  }
}
String _enumToString(Enum enumerated){
  String stringyfied = enumerated.toString();
  return stringyfied.substring(stringyfied.lastIndexOf(".") + 1);
}
enum UpdateProductOperation{
  add,
  replace,
  remove,
}
enum UpdateProductAttribute{
  description,
  category,
}
enum UpdateSubscriptionPlanOperation{
  replace,
}
class UpdateSubscriptionPlanAttribute{
  static const String description = "description";
  static const String payment_preferences_auto_bill_outstanding = "payment_preferences.auto_bill_outstanding";
  static const String taxes_percentage = "taxes.percentage";
  static const String payment_preferences_payment_failure_threshold = "payment_preferences.payment_failure_threshold";
  static const String payment_preferences_setup_fee = "payment_preferences.setup_fee";
  static const String payment_preferences_setup_fee_failure_action = "payment_preferences.setup_fee_failure_action";
}
//API SDK Functions
//----------------------------------------------------------------------
class PayPal{
  PayPal({
    required this.clientID,
    required this.clientSecret,
    this.sandboxMode = true,
  }){
    this._url = sandboxMode ? "https://api-m.sandbox.paypal.com" : "https://api-m.paypal.com";
    //https://www.twilio.com/docs/glossary/what-is-basic-authentication#:~:text=Basic%20Authentication%20is%20a%20method,of%20each%20request%20they%20make
    this.encodedCredentials = base64Encode("$clientID:$clientSecret".codeUnits);
  }
  final String clientID;
  final String clientSecret;
  final bool sandboxMode;
  late final String _url;
  late final encodedCredentials;
  late PayPalAccessToken accessToken;
  Future<PayPalAccessToken> init()async{
    String response = await SexyAPI(
      url: _url,
      path: "/v1/oauth2/token",
      parameters: {},
    ).post(
      headers: {
        "Content-Type" : "application/x-www-form-urlencoded",
        "Accept" : "application/json",
        "Authorization" : "Basic $encodedCredentials",
      },
      body: xWwwFormUrlencoded({
        "grant_type" : "client_credentials",
      }),
    );
    accessToken = PayPalAccessToken.parse(_parseResponse(response));
    return accessToken;
  }
  //Catalog Products API
  //Get products https://developer.paypal.com/docs/api/catalog-products/v1/
  Future<PayPalProductsList> listProducts({
    ///The number of items to return in the response.
    ///Minimum value: 1.
    ///Maximum value: 20.
    int page_size = 20,
    ///A non-zero integer which is the start index of the entire list of items that are returned in the response. So, the combination of page=1 and page_size=20 returns the first 20 items. The combination of page=2 and page_size=20 returns the next 20 items.
    ///Minimum value: 1.
    ///Maximum value: 100000.
    int page = 1,
    ///Indicates whether to show the total items and total pages in the response.
    bool total_required = true,
  })async{
    String response = await SexyAPI(
      url: _url,
      path: "/v1/catalogs/products",
      parameters: {
        "page_size" : page_size,
        "page" : page,
        "total_required" : total_required,
      },
    ).get(
      headers: {
        "Authorization" : "Bearer ${accessToken.access_token}",
        "Content-Type" : "application/json",
      },
    );
    try{
      return PayPalProductsList.parse(_parseResponse(response));
    }catch(error){
      throw response;
    }
  }
  //Create product
  Future<PayPalProduct> createProduct({
    ///The preferred server response upon successful completion of the request. Value is:
    ///return=minimal. The server returns a minimal response to optimize communication between the API caller and the server. A minimal response includes the id, status and HATEOAS links.
    ///return=representation. The server returns a complete resource representation, including the current state of the resource.
    required Prefer prefer,
    ///Contains a unique user-generated ID that the server stores for a period of time. Use this header to enforce idempotency on REST API POST calls. You can make these calls any number of times without concern that the server creates or completes an action on a resource more than once.
    required String payPalRequestID,
    ///The ID of the product. You can specify the SKU for the product. If you omit the ID, the system generates it. System-generated IDs have the PROD- prefix.
    ///Minimum length: 6.
    ///Maximum length: 50.
    required String id,
    ///The product name.
    ///Minimum length: 1.
    ///Maximum length: 127.
    required String name,
    ///The product description.
    ///Minimum length: 1.
    ///Maximum length: 256.
    required String description,
    ///The product type. Indicates whether the product is physical or tangible goods, or a service.
    //required ProductType productType,
    ///The product category.
    required String category,
    ///The image URL for the product.
    ///Minimum length: 1
    ///Maximum length: 2000.
    //required String image_url,
    ///The home page URL for the product.
    ///Minimum length: 1
    ///Maximum length: 2000.
    //required String home_url,
  })async{
    Map<String,dynamic> parameters = {
      "id" : id,
      "name" : name,
      //Adding the properties below throws an error
      "description" : description,
      //"type" : _enumToString(productType),
      "category" : category,
      //"image_url" : image_url,
      //"home_url" : home_url,
    };
    String response = await SexyAPI(
      url: _url,
      path: "/v1/catalogs/products",
      parameters: {},
    ).post(
      headers: {
        "Authorization" : "Bearer ${accessToken.access_token}",
        "Content-Type" : "application/json",
        "Prefer" : "return=${_enumToString(prefer)}",
        "PayPal-Request-Id" : payPalRequestID,
      },
      body: jsonEncode(parameters),
    );
    return PayPalProduct.parse(_parseResponse(response));
  }
  //Update product
  Future<void> updateProduct({
    required String product_id,
    required UpdateProductOperation operation,
    required UpdateProductAttribute attributeToModify,
    Object newValue = "",
  })async{
    List<Map<String,dynamic>> parameters = [{
      "op" : _enumToString(operation),
      "path" : "/"+_enumToString(attributeToModify),
      "value" : newValue,
    }];
    await SexyAPI(
      url: _url, 
      path: "/v1/catalogs/products/$product_id",
      parameters: {},
    ).patch(
      headers: {
        "Authorization" : "Bearer ${accessToken.access_token}",
        "Content-Type" : "application/json",
      },
      body: jsonEncode(parameters),
    );
  }
  //Show product details
  Future<PayPalProduct> showProductDetails({
    required String product_id,
  })async{
    String response = await SexyAPI(
      url: _url,
      path: "/v1/catalogs/products/$product_id",
      parameters: {},
    ).get(
      headers: {
        "Authorization" : "Bearer ${accessToken.access_token}",
        "Content-Type" : "application/json",
      }
    );
    try{
      return PayPalProduct.parse(_parseResponse(response));
    }catch(err){
      throw response;
    }
  }
  //TODO: Subscriptions API
  //https://developer.paypal.com/docs/api/subscriptions/v1/
  Future<ListOfPayPalPlans> listPlans({
    ///Filters the response by a Product ID. Minimum length: 6. Maximum length: 50.
    String? product_id,
    ///Filters the response by list of plan IDs. Filter supports upto 10 plan IDs. Minimum value: 3. Maximum value: 270.
    List<PayPalPlanId>? plan_ids,
    ///The number of items to return in the response. Minimum value: 1. Maximum value: 20.
    String page_size = "20",
    ///A non-zero integer which is the start index of the entire list of items to return in the response. The combination of page=1 and page_size=20 returns the first 20 items. The combination of page=2 and page_size=20 returns the next 20 items. Minimum value: 1. Maximum value: 100000.
    String page = "1",
  })async{
    List<PayPalBillingPlan> billingPlans = [];
    Map<String,dynamic> parameters = {};
    if(product_id != null){
      parameters.addAll({
        "product_id" : product_id,
        "page_size" : page_size,
        "page" : page,
        "total_required" : true,
      });
    }
    if(plan_ids != null){
      List<String> planIds = [];
      for(PayPalPlanId planId in plan_ids){
        planIds.add(planId.plan_id);
      }
      parameters.addAll({
        "plan_ids" : planIds,
      });
    }
    String response = await SexyAPI(
      url: _url,
      path: "/v1/billing/plans",
      parameters: parameters,
    ).get(
      headers: {
        "Authorization" : "Bearer ${accessToken.access_token}",
        "Content-Type" : "application/json",
      },
    );
    Map<String,dynamic> parsedJSON = _parseResponse(response);
    for(Map<String,dynamic> plan in parsedJSON["plans"]){
      //Parse links
      List<PayPalProductLink> links = PayPalProductLink.parseLinks(parsedJSON["links"].cast<Map<String,dynamic>>());
      billingPlans.add(PayPalBillingPlan(
          id: plan["id"], 
          product_id: plan["product_id"], 
          status: plan["status"], 
          name: plan["name"],
          description: plan["description"], 
          create_time: plan["create_time"], 
          links: links,
        ),
      );
    }
    //Parse PayPal billing plans
    try{
      return ListOfPayPalPlans(
        total_items: parsedJSON["total_items"] ?? 0, 
        total_pages: parsedJSON["total_pages"] ?? 0, 
        plans: billingPlans,
      );
    }catch(err){
      throw response;
    }
  }
  //Create Plan
  Future<SubscriptionPlan> createPlan({
    ///The server stores keys for 72 hours.
    required String payPalRequestId,
    ///The ID of the product.
    ///Minimum length: 6.
    ///Maximum length: 50.
    required String product_id,
    ///The plan name.
    ///Minimum length: 1.
    ///Maximum length: 127.
    required String name,
    ///The detailed description of the plan.
    ///Minimum length: 1.
    ///Maximum length: 127.
    required String description,
    ///The initial state of the plan. Allowed input values are CREATED and ACTIVE.
    ///The possible values are:
    ///CREATED. The plan was created. You cannot create subscriptions for a plan in this state.
    ///INACTIVE. The plan is inactive.
    ///ACTIVE. The plan is active. You can only create subscriptions for a plan in this state.
    String status = "ACTIVE",
    Prefer prefer = Prefer.minimal,
    required List<BillingCycle> billingCycles,
    required PaymentPreferences paymentPreferences,
    required Taxes taxes,
    ///Indicates whether you can subscribe to this plan by providing a quantity for the goods or service.
    required bool quantity_supported,
  })async{
    //Parse billing cycles
    List<Map<String,dynamic>> allBillingCycles = [];
    for(BillingCycle billingCycle in billingCycles){
      allBillingCycles.add({
          "frequency": {
            "interval_unit": billingCycle.frequency.interval_unit,
            "interval_count": billingCycle.frequency.interval_count,
          },
          "tenure_type": _enumToString(billingCycle.tenure_type),
          "sequence": billingCycle.sequence,
          "total_cycles": billingCycle.total_cycles,
          "pricing_scheme": {
            "fixed_price": {
              "value": billingCycle.pricing_scheme.value,
              "currency_code": billingCycle.pricing_scheme.currency_code,
            }
          }
        },
      );
    }
    Map<String,dynamic> parameters = {
      "product_id": product_id,
      "name": name,
      "description": description,
      "status": "ACTIVE",
      "billing_cycles": allBillingCycles,
      "payment_preferences": {
        "auto_bill_outstanding": paymentPreferences.auto_bill_outstanding,
        "setup_fee": {
          "value": paymentPreferences.setup_fee.value,
          "currency_code": paymentPreferences.setup_fee.currency_code,
        },
        "setup_fee_failure_action": _enumToString(paymentPreferences.setup_fee_failure_action),
        "payment_failure_threshold": paymentPreferences.payment_failure_threshold,
      },
      "taxes": {
        "percentage": taxes.percentage,
        "inclusive": taxes.inclusive,
      }
    };
    String response = await SexyAPI(
      url: _url,
      parameters: {},
      path: "/v1/billing/plans",
    ).post(
      headers: {
        "Authorization" : "Bearer ${accessToken.access_token}",
        "Content-Type" : "application/json",
        "Prefer" : "return=${_enumToString(prefer)}",
        "PayPal-Request-Id" : payPalRequestId,
      },
      body: jsonEncode(parameters),
    );
    try{
      //Parse response
      return SubscriptionPlan.parse(response);
    }catch(err){
      throw response;
    }
  }
  Future<void> updatePlan({
    ///The ID of the plan.
    required String id,
    required UpdateSubscriptionPlanOperation operation,
    required String attributeToModify,
    required Object newValue,
  })async{
    List<Map<String,dynamic>> parameters = [
      {
        "op": _enumToString(operation),
        "path": "/"+attributeToModify.replaceFirst(".", "/"),
        "value": newValue,
      }
    ];
    String response = await SexyAPI(
      url: _url,
      parameters: {},
      path: "/v1/billing/plans/$id",
    ).patch(
      headers: {
        "Authorization" : "Bearer ${accessToken.access_token}",
        "Content-Type" : "application/json",
      },
      body: jsonEncode(parameters),
    );
    if(response.isNotEmpty){
      throw response;
    }
  }
  //Show plan details
  Future<SubscriptionPlan> showPlanDetails({
    required String id,
  })async{
    String response = await SexyAPI(
      url: _url,
      path: "/v1/billing/plans/$id",
      parameters: {}
    ).get(
      headers: {
        "Authorization" : "Bearer ${accessToken.access_token}",
        "Content-Type" : "application/json",
      },
    );
    try{
      return SubscriptionPlan.parse(response);
    }catch(err){
      throw response;
    }
  }
  //TODO: Activate plan
  Future<void> activatePlan({
    required String id,
  })async{
    String response = await SexyAPI(
      url: _url, 
      parameters: {},
      path: "/v1/billing/plans/$id/activate",
    ).post(
      headers: {
        "Authorization" : "Bearer ${accessToken.access_token}",
        "Content-Type" : "application/json",
      },
      body: null,
    );
    if(response.isNotEmpty){
      throw response;
    }
  }
  //TODO: Deactivate plan
  Future<void> deactivatePlan({
    required String id,
  })async{
    String response = await SexyAPI(
      url: _url, 
      parameters: {},
      path: "/v1/billing/plans/$id/deactivate",
    ).post(
      headers: {
        "Authorization" : "Bearer ${accessToken.access_token}",
        "Content-Type" : "application/json",
      },
      body: null,
    );
    if(response.isNotEmpty){
      throw response;
    }
  }
}