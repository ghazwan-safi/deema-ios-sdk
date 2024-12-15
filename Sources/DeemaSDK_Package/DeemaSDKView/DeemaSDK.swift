//
//  WebView.swift
//  DeemaSDK
//  Created by Taimur Imam on 28/11/24.


import SwiftUI
import WebKit
import Alamofire
import SwiftyJSON

public enum PaymentStatus {
    case success
    case failure
}

struct MerchantResponse {
    var  purchase_id : String
    var  redirect_link : String
    var order_reference : String
    init(from json: JSON)
    {
        self.purchase_id = json["purchase_id"].stringValue
        self.redirect_link = json["redirect_link"].stringValue
        self.order_reference = json["order_reference"].stringValue
    }
}

public enum Environment {
    case sandbox
    case production
}

public struct DeemaSDK: View {
    public init(SDK_Key : String ,amount : String , merchant_id : String ,  currency : String  , environment : Environment,  paymentStatus: @escaping (_ message : String , _ status : PaymentStatus) -> Void) {
        self.paymentStatus = paymentStatus
        self.SDK_Key = SDK_Key
        self.amount = amount
        self.merchant_id = merchant_id
        self.currency = currency
        self.merchantResponse =   MerchantResponse(from: JSON())
        self.isLoading = true
        self.message = "Web View has been removed after payment completion."
        self.isWebViewShow = false
        self.currentURL = ""
        self.showAlert = false
        self.environment = environment
    }
      private var merchant_id : String
      private var amount : String
      private var currency : String
      private var SDK_Key : String
      private var environment : Environment
    var merchantUrl : String{
        if  environment == .sandbox {
            //TESTING url here
            return "https://staging-api.deema.me/api/merchant/v1/purchase"
        }else{
            return  "https://staging-api.deema.me/api/merchant/v1/purchase"
        }
    }
    
    @State private var merchantResponse =  MerchantResponse(from: JSON())
    @State private var isLoading: Bool = true
    @State private var message = "Web View has been removed after payment complete."
    @State private var isWebViewShow: Bool = false
    @State private var currentURL: String = ""
    @State private var showAlert: Bool = false
    @State var link = ""
    let paymentStatus: (_ message : String , _ status : PaymentStatus)->Void
    
    public  var body: some View {
        ZStack{
            Color.authenticBackGround
                .ignoresSafeArea()
            ActivityIndicator(isAnimating: $isLoading, style: UIActivityIndicatorView.Style.large)
                .task {
                    placeMerchantOrder()
                }
                    if  isWebViewShow {
                        if let url = URL(string: merchantResponse.redirect_link) {
                            WebView(url:url , currentURL: $currentURL, isRemove: $isWebViewShow, isLoading: $isLoading, environment: environment, paymentCompleted: {status,message in
                                paymentStatus(message , status)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    isWebViewShow = false
                                    showAlert.toggle()
                                }
                                
                            } )
                            .ignoresSafeArea()
                        }
                    }
        }
    }
    
    
        var purchaseResponse: PurchaseResponse?

        // Method to update the response
        func updateResponse(_ response: PurchaseResponse) {
            merchantResponse.redirect_link = response.data.redirectLink
            merchantResponse.order_reference = response.data.orderReference
            merchantResponse.purchase_id = "\(response.data.purchaseId)"
            isWebViewShow.toggle()
        }

    func saveResponse(response: PurchaseResponse) async {
         updateResponse(response)
    }
    
    func placeMerchantOrder(){
        let params = [
            "merchant_order_id" : merchant_id ,
            "amount" : amount ,
            "currency_code" : currency
        ]
        let headers: HTTPHeaders = [
            "source": "sdk",
            "Authorization" : "Basic \(SDK_Key)"
        ]
        AF.request(self.merchantUrl, method: .post, parameters: params, encoding: JSONEncoding.default , headers:headers )
            .responseDecodable(of: PurchaseResponse.self) { response in
                switch response.result {
                case .success(let purchaseResponse):
                    Task {
                        await saveResponse(response: purchaseResponse)
                        }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
       }
}


struct PurchaseResponse: Codable, Sendable {
    let message: String
    let data: PurchaseData
}


