public class DataCloudOauth4 {
    public static Map<String, Object> getAccessToken4(String accessToken) {
        String endpoint = 'https://ka1721901639871.my.salesforce.com/services/a360/token';
        String grantType = 'urn:salesforce:grant-type:external:cdp';
        String subjectTokenType = 'urn:ietf:params:oauth:token-type:access_token';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        String body = 'grant_type=' + EncodingUtil.urlEncode(grantType, 'UTF-8') +
            '&subject_token=' + EncodingUtil.urlEncode(accessToken, 'UTF-8') +
            '&subject_token_type=' + EncodingUtil.urlEncode(subjectTokenType, 'UTF-8');
        req.setBody(body);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            String responseBody = res.getBody();
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            String accessTokenValue = (String) responseMap.get('access_token');
            Map<String, Object> data = DataCloudService4.queryDataCloud4(accessTokenValue);
            return data;
        } else {
            System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
            System.debug('Error Body: ' + res.getBody());
            return new Map<String, Object>(); // Return an empty map in case of error
        }
    }
}