/*
Class Name : PredictEinsteinIntentAPI
Created Date : 08/15/2022
Created By: Harini Penta
Last Modified Date: 
Description :This apex class get the intent response back by sending the Labels in POST callout to Einstein Predict endpoint
*/
public class PredictEinsteinIntentAPI{
  
    public static Einstein_Intent_API__c settings{
     get{
         return Einstein_Intent_API__c.getInstance( UserInfo.getOrganizationId() );
     }
     set {}
 } 
 public static String predictIntentEP {
     get {
         return settings.Predict_Intent_Endpoint__c;
     }
     set {}
 }  

 public datareswrapper PredictEinsteinIntent(String modelId, String Text){ //List<Object>       
     String endpoint = predictIntentEP;
     HttpRequest httpReq = new HttpRequest();
     system.debug('@@ endpoint:'+endpoint);
     httpReq.setMethod( 'POST' );
     httpReq.setEndpoint( endpoint );
     
     httpReq.setHeader( 'Authorization', 'Bearer ' + EinsteinAPI.getAccessToken() );
     httpReq.setHeader( 'Cache-Control', 'no-cache' );
     httpReq.setHeader( 'Content-Type', HttpFormBuilder.GetContentType() );        
     httpReq.setTimeout( 120000 );
     
     String mutipartFormData = '';
     mutipartFormData += HttpFormBuilder.WriteBoundary();
     mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'modelId', modelId );
     mutipartFormData += HttpFormBuilder.WriteBoundary();
     mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'document', Text );
     mutipartFormData += HttpFormBuilder.WriteBoundary( NULL );        
     Blob formBlob = EncodingUtil.base64Decode( mutipartFormData );
     
     httpReq.setBodyAsBlob( formBlob );        
     Http http = new Http();        
     HTTPResponse httpRes = http.send( httpReq );        
     PredictionResponse resp = new PredictionResponse();
     
     resp = (PredictionResponse) JSON.deserialize(httpRes.getBody(), PredictionResponse.class);
     list<PredictionResponse.Probabilities> subcls =  new list<PredictionResponse.Probabilities>();
     subcls = resp.Probabilities;
     
     Decimal highprob = subcls[0].probability;
     String Intentlabel = subcls[0].label;
     Integer position = 0;
     For (integer i =0; i<subcls.size(); i++)
     {            
         if( subcls[i].probability > highprob){
             highprob = subcls[i].probability;
             Intentlabel =  subcls[i].label;
             position = i; 
         }            
     } 
     Decimal percentage = highprob * 100 ;
     datareswrapper wrap = new datareswrapper();
     wrap.Intent = Intentlabel;
     wrap.Probability = percentage;
     
     system.debug('___label:'+wrap.Intent+'_____prob:'+wrap.Probability); 
     system.debug('@@ subcls'+subcls);
     return wrap;
 }
 public class datareswrapper{
     public String Intent {get;set;}        
     public Decimal Probability {get;set;}           
 }
}