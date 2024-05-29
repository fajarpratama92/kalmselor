import WonderPushExtension

class NotificationService: WPNotificationServiceExtension {

    override class func clientId() -> String {
        ///STG
        // return "db50f82a180e9120c4f229ed534bbfa6a56beb22"
        ///PROD
        return "e50b5c2da3c64420ec4644d3ba9642bf30f60102"
    }

    override class func clientSecret() -> String {
        ///STG
        // return "ad5357e798399f4012ab1b57788b626b13b2774dc95088263646a657b988b250"
        ///PROD
         return "090f67bf6c65b45a1ba8aeac317a5f8885e197b1bcf9dc5abd4ea71fbd3d6f93"
    }

}