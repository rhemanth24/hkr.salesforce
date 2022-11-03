/*
Class Name : EinsteinAPI

*/
public class EinsteinAPI {
    //Get all the values of apex properties from custom settings
    public static Einstein_Intent_API__c settings{
        get {
            return Einstein_Intent_API__c.getInstance( UserInfo.getOrganizationId() );
        }
        set {}
    } 
    public static String tokenEndpoint {
        get {
            return settings.Token_Endpoint__c;
        }
        set {}
    }
    public static Decimal tokenExpirationSeconds {
        get {
            return settings.Token_Expiration_Seconds__c;
        }
        set {}
    }
    public static String registeredEmail{
        get {
            return settings.Registered_Email__c;
        }
        set {}
    }
    public static String intentUploadDatasetEP{
        get {
            return settings.Upload_Dataset_Endpoint__c;
        }
        set {}
    }
    public static String intentDatasetDetailsEP{
        get {
            return settings.Dataset_Details_Endpoint__c;
        }
        set {}
    }
    public static String intentTrainDatasetEP{
        get {
            return settings.Train_Dataset_Endpoint__c;
        }
        set {}
    }
    public static String intentDatasetTrainingStatusEP{
        get {
            return settings.Train_Dataset_Details_Endpoint__c;
        }
        set {}
    }
    public static String intentDatasetCSV {
        get { system.debug('@@ public link :'+ settings.Intent_Dataset_CSV__c);           
             return settings.Intent_Dataset_CSV__c;
            }
        set {}
    }
    public static string apiUsageLimit {
        get{
            return settings.API_usage_limit__c;
        }
        set{}
    }
    
    // This method is created to make a call to the Token Endpoint and get the token which will help us to make request to other Endpoints of Einstein Services.
    public Static String getAccessToken() {        
        //  Document base64Content 
      /*  Document base64Content  = [
            SELECT  Body
            FROM    Document
            WHERE   DeveloperName = 'einstein_platform_pem'
            LIMIT   1
        ];    */  
        //String keyContents  = base64Content.Body.tostring();
       // String keyContents = 'MIIEowIBAAKCAQEAng1Jw6bwMPRZR32/JbQDqApGvPdFMvYFq9gV5bqK8rOjRUI2OUzmlj1Cz7AIkUioDsHe9MxKsVHZYQQXq1erNump9qnDelEiO0bwvw252zVT9LkUZKv6P7rwfBc3FvrexV7+AcypkNNFRuNh7DuVi41954fixaJZYFpAJG4kZPKR8N688CLON1nGlrTJGhEJXlzyNmXnL1dSSfZRlksA8+JBalMaB7nCWzF5EeOOf+iBvgDxxwSXHtqLVm06bPxFQGBboAWzE0ArvhkKAskGtBO5xT4e9aiYH/MhawtUHUtlJXLJrBylPtrGC5DzhQR8opAN9RQtfMrcKzLxPkU2ZwIDAQABAoIBAQCcgE/wWlcwQmQ9NDiYHt4YAMT2zGpLAe2vsXJNXh/EHzimld+XcZxKXDLR8F8rbSRsKHCbOcckOgXj2OePFGpHH6zawFL9xWT+CUrOA8trUizmAHY/EUPk4zjJxzsXmCYKjfs60Ot+qpTIktMd1gpIezyWjKlyRUX28Kbe6+lBwpew7sbqPedZ8Oo6R7uik8/jkTub/gQ/ZJxKAkm3TIFpVqSUSGwhjbP2v6pSZC1EQ27UfePCIOGgnv1hFFPQsWoWr8FWk92/3sUlYswso/4Dlq356k7FUALhpipDFlcxdBA7W5Ct1gIsJqFeqA2y0Nz5ZCeZe/a4xYYVir6c/ORBAoGBAN1DfTPt/ICF2Zv6uDVzJtdxmixTF2ImN0bUWBWoi33Hb/LNVLW0Jqk00O+d/MERW1EsYU+2Tb5YHXQJiOQU1IFDC9JQtIlaInIdR/XEl1yyGOBYSiQ3dq+RRSz2ZRYP2O7Eo9CEqGe6xtOJ35S878GQT3gqgd8cCoHt3WwowmPRAoGBALbdV1eZOFdV1gXAW9SdhTAm74r8Xbz19yMwglhDN6GzKBSMc+ifX1ncNOb0VGCRGSBpLXuMGaLDyRFV3SFgTPZ94RG3ECJQzZuxlzOJO655miVYwQpPndD54cBw9F+2EA/sc19md5Pgfuk7JQZ3vK54ZZ2qrsWO5dVhFFV0VRy3AoGAOw8pmzPZ4yBXHlhE1ReAdZ9ADLa9FhinRoOlY1qSqScTzZZbFwkYDLApWNwtvAb6/ea/rrw1cioo6nElFeQteLdBr4iVN9hUO2tvar1nvXlYRIGsgJBBYMmA0miOQN5IBCt+okjWfqGPMqWphRUNVfhEDgoikj/02gt4v8b9ZBECgYAawuPAXxz+swIiT1dhEzhlpp0R0wMI31ounS/GKPggQu7PqwpfdctnhDF9xy39/94Ufy/3z7YEuvBXCCDXfJdmz187z3WeAANHEMNW+HNygjtL0eRWVPZ8mcUu+5jX1PYeznTH9l/zlTwdd9lgS++h/N6qJ0tygAokoxNtuhummwKBgG7UJLtYuSRsrN9ojj1ChAXctBAx8grxXliP/J7sD1hRsaU64/bdX7Kek9kTbLJxxqWrip23SKv/rzauvHD0a1ns4TRuZt8jnyztOSpU5X6qXT/gPcjfk1hcgvgVVD9EYEhB2ruyxgsD8AElZEdxzoxKOwEUkxS8ot/EoHQWZPBd';
    /*   Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v42.0/sobjects/ContentVersion/0683t00000LAJn0AAH/VersionData');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        HttpResponse response = h.send(req); 
        
        String keyContents  = response.getBody();
        system.debug('keyContentsBefore@@@'+keyContents);*/
        ContentVersion cv = [SELECT  VersionData FROM    ContentVersion WHERE   Title like '%einstein_platform' LIMIT 1 ];
        system.debug('VersionData@@@@'+cv.VersionData);
        String keyContents  = (cv.VersionData).toString();
        system.debug('keyContentsBefore@@@'+keyContents);
       keyContents         = keyContents.replace( 'BEGIN RSA PRIVATE KEY', '' );
        keyContents         = keyContents.replace( 'END RSA PRIVATE KEY', '' );
        keyContents         = keyContents.replace( '\n', '' );
        keyContents         = keyContents.replace( '-', '' );
        JWT jwt             = new JWT( 'RS256' );
        system.debug('keyContentsAFTER@@@'+keyContents);
        jwt.pkcs8           = keyContents; 
        jwt.iss             = 'developer.force.com';
        jwt.sub             =  registeredEmail;
        jwt.aud             =  tokenEndpoint;
        jwt.exp             = String.valueOf( tokenExpirationSeconds );  
        String access_token = JWTBearerFlow.getAccessToken(tokenEndpoint, jwt );  
        system.debug('@@@ access_token :'+access_token);
        return access_token;
    }
    
    // This method is created to build Http Requests.
    private HttpRequest buildRequest( String method, String endpoint ) {
        HttpRequest httpReq = new HttpRequest();
        
        httpReq.setMethod( method );
        httpReq.setEndpoint( endpoint );
        
       // httpReq.setHeader( 'Authorization', 'Bearer ' + getAccessToken() );
       httpReq.setHeader( 'Authorization', 'Bearer ' + 'LFGVUV2ZLJAVKTCRGVLESNSLGQZEIRKYGVNDIMZVLBBEQVCSIJDUSQKDJZFVCRCVJBKE2S2QJFBEYUBTIQZUWQ2CIY3UITJUGY3UMWSMJVGEKSKRLFJU4USEKZMVOU2ZLJGECM2BKQ3UQS2VIRLVESKKK5LUUUSWLBDFC7COIE');
        httpReq.setHeader( 'Cache-Control', 'no-cache' );
        httpReq.setHeader( 'Content-Type', HttpFormBuilder.GetContentType() );
        
        httpReq.setTimeout( 120000 );
        
        return httpReq;
    }
    
    
    //This method is created to make a Http POST Call to the Einstein Intent APIs to upload the file into their server.
    
    public DatasetUploadResponse uploadDataset() {
        String endpoint = intentUploadDatasetEP;
        
        HttpRequest httpReq = buildRequest( 'POST', endpoint );
        
        String mutipartFormData = '';
        mutipartFormData += HttpFormBuilder.WriteBoundary();
        mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'path', intentDatasetCSV); 
        mutipartFormData += HttpFormBuilder.WriteBoundary();
        mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'type', 'text-intent' );
        mutipartFormData += HttpFormBuilder.WriteBoundary( NULL );
        
        Blob formBlob = EncodingUtil.base64Decode( mutipartFormData );
        
        httpReq.setBodyAsBlob( formBlob );
        
        Http http = new Http();
        
        HTTPResponse httpRes = http.send( httpReq ); 
        
        DatasetUploadResponse resp = new DatasetUploadResponse();
        
        resp = ( DatasetUploadResponse ) JSON.deserialize( httpRes.getBody(), DatasetUploadResponse.class );
        system.debug('@@ resp:'+resp);
        return resp;
    }
    
    // This method is created to make a GET call and get the status of the dataset upload process.
    
    public DatasetDetailsResponse getDatasetDetails( String datasetId ) {
        String endpoint = intentDatasetDetailsEP.replace( '#DSID#', datasetId );
        HttpRequest httpReq = buildRequest( 'GET', endpoint );
        
        Http http = new Http();       
        HTTPResponse httpRes = http.send( httpReq );
        
        DatasetDetailsResponse resp = new DatasetDetailsResponse();
        
        resp = ( DatasetDetailsResponse ) JSON.deserialize( httpRes.getBody(), DatasetDetailsResponse.class );
        system.debug('details resp:'+resp);
        return resp;
    }
    
    
    // This method is created to make a POST Http call to create a model and start training the AI.
    
    public TrainDatasetResponse trainDataset( String datasetId ) {  
        String endpoint = intentTrainDatasetEP;
        HttpRequest httpReq = buildRequest( 'POST', endpoint );
        system.debug('@@ endpoint train :'+endpoint);
        String mutipartFormData = '';
        mutipartFormData += HttpFormBuilder.WriteBoundary();
        mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'name', 'CCS Chat - ' + DateTime.now().getTime() );
        mutipartFormData += HttpFormBuilder.WriteBoundary();
        mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'datasetId', String.valueOf( datasetId ) );
        mutipartFormData += HttpFormBuilder.WriteBoundary( NULL );
        
        Blob formBlob = EncodingUtil.base64Decode( mutipartFormData );        
        httpReq.setBodyAsBlob( formBlob );        
        Http http = new Http();        
        HTTPResponse httpRes = http.send( httpReq );
        system.debug('httpRes.getStatusCode()@@@'+httpRes.getStatusCode());
        system.debug('httpRes.getStatus()@@@'+httpRes.getStatus());
        system.debug('httpRes.getBody()@@@'+httpRes.getBody());
        TrainDatasetResponse resp = new TrainDatasetResponse();
        resp = ( TrainDatasetResponse ) JSON.deserialize( httpRes.getBody(), TrainDatasetResponse.class ); 
        system.debug('@@ train1 result :'+ resp);
        return resp;
    }
    
    
    // This method is created to make a GET call to get the training status of the Dataset.
    
    public String getDatasetTrainingStatus( String modelId ) {
        String endpoint = intentDatasetTrainingStatusEP.replace( '#MODELID#', modelId );
        HttpRequest httpReq = buildRequest( 'GET', endpoint );        
        Http http = new Http();        
        HTTPResponse httpRes = http.send( httpReq );
        
        TrainingStatusResponse respTrainingStatus   = new TrainingStatusResponse();
        TrainDatasetResponse respTrainDataset     = new TrainDatasetResponse();
        
        try {
            respTrainingStatus = ( TrainingStatusResponse ) JSON.deserialize( httpRes.getBody(), TrainingStatusResponse.class );
            system.debug('@@ TrainingStatusResponse :'+respTrainingStatus);
            TrainingStatusResponse subcls =  new TrainingStatusResponse();
            subcls = respTrainingStatus;
            return subcls.status;
        }
        catch( Exception ex ) {
            respTrainDataset = ( TrainDatasetResponse ) JSON.deserialize( httpRes.getBody(), TrainDatasetResponse.class );
            system.debug('@@ TrainDatasetResponse :'+respTrainDataset);
            TrainDatasetResponse subcls =  new TrainDatasetResponse();
            subcls = respTrainDataset;
            return subcls.status;
        }
    }
    //This class make a callout to get the number of Predictions used, resmaining and maximum limit
    
    public PredictUsageResponse predictApiUsage(){
        String endpoint = apiUsageLimit;
        HttpRequest httpReq = buildRequest( 'GET', endpoint );
        
        Http http = new Http();       
        HTTPResponse httpRes = http.send( httpReq );
                
        PredictUsageResponse resp = new PredictUsageResponse();
        resp = ( PredictUsageResponse ) JSON.deserialize( httpRes.getBody(), PredictUsageResponse.class );
        
        return resp;
    }
}