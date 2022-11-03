/*
Class Name : EinsteinIntentUIForAdminController
Created Date : 08/15/2022
Created By: Harini Penta
Last Modified Date: 
Description : This is Apex class uploads csv document in files and update the public link in custom settings. It also get the responses from Create and Train the dataset endpoints
*/
public class EinsteinIntentUIForAdminController {
    String token;
    String trainStatus = null;
    @AuraEnabled
    public static String loadData( Id contentDocumentId ) {
        system.debug('uploaded file id:'+contentDocumentId);
        String strMessage;
        Boolean isUpdated;
        Id contentVersionId;
        if ( contentDocumentId != null ) {  
            ContentDistribution[] distributionsToInsert = new List<ContentDistribution>();
            for(List<ContentVersion> objContentVersion : [ SELECT Id, VersionData, FileType,CreatedDate  FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId]){
                // and CreatedDate  = this_year order by createddate DESC limit 1]){
                //create public link only if CSV is uploaded
                if(objContentVersion[0].FileType.toLowerCase()=='csv'){
                    system.debug('objContentVersion.FileExtension.toLowerCase():' + objContentVersion[0].FileType); 
                    contentVersionId = objContentVersion[0].Id;
                    system.debug('contentVersionId@@@'+contentVersionId);
                    distributionsToInsert.add(createContentDistribution(objContentVersion[0].Id));
                }
            }
            if(!distributionsToInsert.isEmpty())
            {
                insert distributionsToInsert;
                strMessage = 'File Uploaded Successfully';
            }else{
                strMessage = 'Some error occured. Please reach out to your System Admin';
            }
            
            //Public link is generated for uploaded csv file
            List<ContentDistribution> cd = [SELECT id, ContentVersionId,ContentDownloadUrl FROM ContentDistribution where ContentVersionId =:contentVersionId];
            system.debug('@@ ContentDistribution:'+ cd[0].ContentDownloadUrl);
            
            //The public link is updated in Einstein intent custom settings record
            List<Einstein_Intent_API__c> intent = [select Token_Endpoint__c	,Registered_Email__c, Intent_Dataset_CSV__c from Einstein_Intent_API__c];
            intent[0].Intent_Dataset_CSV__c = cd[0].ContentDownloadUrl;
            update intent;
        }
        return strMessage;
    }
    public static ContentDistribution createContentDistribution(Id contentVersionId){
        ContentDistribution newDist = new ContentDistribution();
        newDist.ContentVersionId = contentVersionId;
        newDist.Name = 'External Link';
        newDist.PreferencesNotifyOnVisit = false;
        newDist.PreferencesAllowViewInBrowser = true;
        newDist.PreferencesAllowOriginalDownload=true;
        return newDist;        
    } 
    @AuraEnabled
    public static Integer uploadDataset() {
        EinsteinAPI api = new EinsteinAPI();
        DatasetUploadResponse datasetUploadResp = api.uploadDataset();
        System.debug('@@@ DatasetUploadResponse :'+datasetUploadResp.id);
        return datasetUploadResp.id;
    } 
    @AuraEnabled
    public static String getDatasetDetails( String datasetId ) {
        string id = datasetId; 
        EinsteinAPI api = new EinsteinAPI();        
        DatasetDetailsResponse datasetDetailsResp = api.getDatasetDetails( datasetId );
        return datasetDetailsResp.statusMsg;
    }  
    @AuraEnabled
    public static String trainDataset( String datasetId ) {
        EinsteinAPI api = new EinsteinAPI();        
        TrainDatasetResponse trainDatasetResp = api.trainDataset( datasetId );
        system.debug('@@ get train status :'+trainDatasetResp+' '+trainDatasetResp.modelId);
        updateEinsteinIntentSettings(trainDatasetResp.modelId);
        return trainDatasetResp.modelId;
    }
    @AuraEnabled
    public static String getDatasetTrainingStatus( String modelId ) {
       
        EinsteinAPI api = new EinsteinAPI();        
        String resp = api.getDatasetTrainingStatus(modelId);
        system.debug('@@ train :'+resp);
        return resp;
    }
    @AuraEnabled
    public static Object predictIntent( String modelId, String text ) {
        PredictEinsteinIntentAPI api = new PredictEinsteinIntentAPI();        
        PredictEinsteinIntentAPI.datareswrapper resp = api.PredictEinsteinIntent(modelId,text);
        WrapperRecords wrap = new WrapperRecords();
        wrap.Intent = resp.Intent;
        wrap.Probability = resp.Probability;
        system.debug('@@_____________:'+wrap);    
        return wrap;
    }
    @AuraEnabled
    public static Object getApiUsage( String modelId ) {
        system.debug('___________modelId:'+modelId);
        EinsteinAPI api = new EinsteinAPI();        
        PredictUsageResponse resp = api.predictApiUsage();

        WrapperRecords wrap = new WrapperRecords();
        wrap.predictionsRemaining = resp.data[0].predictionsRemaining;
        wrap.predictionsUsed = resp.data[0].predictionsUsed;
        wrap.predictionsTotal = resp.data[0].predictionsMax;
        return wrap;
    }
    public static void updateEinsteinIntentSettings(String modelId){
        List<Einstein_Intent_API__c> intent = [select Token_Endpoint__c	,Intent_Model_Id__c, Intent_Dataset_CSV__c from Einstein_Intent_API__c];
        intent[0].Intent_Model_Id__c = modelId;
        update intent;
    } 
    public class WrapperRecords{
        @AuraEnabled public String Intent {get;set;}
        @AuraEnabled public Decimal Probability {get;set;} 
        @AuraEnabled public Integer predictionsUsed {get;set;}
        @AuraEnabled public Integer predictionsRemaining {get;set;}
        @AuraEnabled public Integer predictionsTotal {get;set;}    
    }
}