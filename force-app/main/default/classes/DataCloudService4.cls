public class DataCloudService4 {
    public static Map<String, Object> queryDataCloud4(String accessToken) {
        // Fetch data from the external API
        List<Object> data = queryJsonAppointment(accessToken);
        System.debug('Data: ' + data);
        
        // Wrap the data in a map if needed for LWC
        Map<String, Object> result = new Map<String, Object>();
        result.put('data', data);
        
        return result;
    }
    
    public static List<Object> queryJsonAppointment(String accessToken) {
        String endpoint = 'https://g83g8m3fmftd8y30g5tdkzddh1.c360a.salesforce.com/api/v1/query';
        String queryJson = '{"sql" : "SELECT Epic_EPIC_Appointment_0CC23DA0__dll.DataSourceObject__c, Epic_EPIC_Appointment_0CC23DA0__dll.DataSource__c, Epic_EPIC_Appointment_0CC23DA0__dll.appointmentType__c, Epic_EPIC_Appointment_0CC23DA0__dll.comment__c, Epic_EPIC_Appointment_0CC23DA0__dll.ConditionId__c, Epic_EPIC_Appointment_0CC23DA0__dll.createdDate__c, Epic_EPIC_Appointment_0CC23DA0__dll.description__c, Epic_EPIC_Appointment_0CC23DA0__dll.end__c, Epic_EPIC_Appointment_0CC23DA0__dll.Id__c, Epic_EPIC_Appointment_0CC23DA0__dll.identifier__c,Epic_EPIC_Appointment_0CC23DA0__dll.PatientId__c FROM Epic_EPIC_Appointment_0CC23DA0__dll " }';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(queryJson);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            String responseBody = res.getBody();
            System.debug('Response Body: ' + responseBody);
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            List<Object> data = (List<Object>) responseMap.get('data');
            return data;
        } else {
            System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
            System.debug('Error Body: ' + res.getBody());
            return new List<Object>(); // Return an empty list in case of error
        }
    }
}