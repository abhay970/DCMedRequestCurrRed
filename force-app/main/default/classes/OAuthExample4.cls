public class OAuthExample4 {
    @AuraEnabled
    public static Map<String, Object> getAccessToken4() {
        String endpoint = 'https://login.salesforce.com/services/oauth2/token';
        String clientId = '3MVG9jSKmPAPVo2KSuUmd0_YbjzXRIjxzl8JreFyVg2LENX08V.TjmuOrRzNRp.lC4knRSaqytXHv2Fw1Llbw';
        String clientSecret = '2E6BC395244DE09EB4E262B002F96D31FBD97528BA42532B3B305A9CD58C4D2C';
        String username = 'abhay.kumar.yadav@techkasetti.com2024/07/25_15-30-0.demo';
        String password = 'Kasetti@555';
        String grantType = 'password';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        String body = 'grant_type=' + EncodingUtil.urlEncode(grantType, 'UTF-8') +
            '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
            '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8') +
            '&username=' + EncodingUtil.urlEncode(username, 'UTF-8') +
            '&password=' + EncodingUtil.urlEncode(password, 'UTF-8');
        req.setBody(body);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            String responseBody = res.getBody();
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            String accessToken = (String) responseMap.get('access_token');
            
            // Fetch data using the access token
            Map<String, Object> data = DataCloudOauth4.getAccessToken4(accessToken);
            System.debug('Data===========:njjnkj ' + data);
            return data;
        } else {
            System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
            System.debug('Error Body: ' + res.getBody());
            return new Map<String, Object>(); // Return an empty map in case of error
        }
    }
}