import { LightningElement,wire,api,track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import loadData from '@salesforce/apex/EinsteinIntentUIForAdminController.loadData';
import uploadDataset from '@salesforce/apex/EinsteinIntentUIForAdminController.uploadDataset'; 
import getDatasetDetails from '@salesforce/apex/EinsteinIntentUIForAdminController.getDatasetDetails'; 
import trainDataset from '@salesforce/apex/EinsteinIntentUIForAdminController.trainDataset';
import getDatasetTrainingStatus from '@salesforce/apex/EinsteinIntentUIForAdminController.getDatasetTrainingStatus';
import predictIntent from '@salesforce/apex/EinsteinIntentUIForAdminController.predictIntent';
import getApiUsage from '@salesforce/apex/EinsteinIntentUIForAdminController.getApiUsage';

export default class EinsteinIntentUIForAdmin extends LightningElement {
@api Name;
    statusMessage;
    error;
    predictLabel;
    isLoaded = false;
    isUpdated = false;
    datasetId = null;
    modelId   = null;
    status;
    clickedButtonLabel;
    count = 1;
    @track highProbability = 0;
    isIntentVisible = false;
    @track intent;
    @track predictionsUsed;
    @track predictionsRemaining;
    @track predictionsMax;


    get acceptedFormats() {
        return ['.csv'];
    }
 // uploading csv file and updaing the custom settings using controller file   
    uploadFileHandler( event ) {
        
        this.isLoaded = true;
        const uploadedFiles = event.detail.files;
        console.log('uploadedFiles@@@'+JSON.stringify(uploadedFiles));
        loadData( { contentDocumentId : uploadedFiles[0].documentId } )
        .then( result => {

            this.isLoaded = false;
            window.console.log('result ===> '+result);
          //  this.strMessage = result;
            this.isUpdated = result;
                      
            this.dispatchEvent(
                new ShowToastEvent( {
                    title: this.result,
                    message: result,
                    variant: 'success',//result.includes('success') ? 'success' : 'error'
                    mode: 'sticky'
                } ),
            );

        })
        .catch( error => {
            this.isLoaded = false;
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Error!!',
                    message: JSON.stringify( error ),
                    variant: 'error',
                  //  mode: 'sticky'
                } ),
            );     

        } )
    
    }
    btnUploadDS(event){

        this.clickedButtonLabel = event.target.label;
        console.log('@@ this.clickedButtonLabel:'+this.clickedButtonLabel);
        this.uploadDataset1InActions();
        console.log('in btnuploadDS');
         
    }
    btnTrainDS(event){

        this.clickedButtonLabel = event.target.label;
        console.log('@@ this.clickedButtonLabel:'+this.clickedButtonLabel);
        this.trainDataset1();
        console.log('in btnTrainDS');
         
    }
    handleInputChange(event){
        this.predictLabel = event.target.value;
        console.log('@@ predictLabel :'+this.predictLabel);
    }
    btnPredict(event){
        console.log('@@ in btnpredict :'+event.target.label);
      this.makePrediction();
    }
    uploadDataset1InActions(){
            console.log('inside uploadDataset1InActions');
            uploadDataset()
            .then(result => {
                console.log('@ result :'+result);
                this.datasetId = result;
                this.datasetId = this.datasetId.toString();
                console.log('this.datasetId:'+this.datasetId);
                const toastMsg = new ShowToastEvent({
                    title : 'Uploading Dataset',
                    message : 'The CSV is being uploaded to create the Dataset. Please wait...',
                    variant : 'info',
                    
                }); 
                this.dispatchEvent(toastMsg); 
                  this.getDatasetDetails1();    
                    
            } ).catch(error => {
                //console.error('Error in fetching datasetId :'+ error.body.message);
                console.error('Error in fetching datasetId :'+ error);
                const toastMsg = new ShowToastEvent({
                    title : 'Error in fetching datasetId',
                    message : error.body.message,
                    variant : 'error',
                    mode: 'sticky'
                    
                });
                this.dispatchEvent(toastMsg);
            });
    }
    getDatasetDetails1(){
            window.setTimeout( 
                getDatasetDetails({datasetId : this.datasetId})
                  .then(result => {console.log('above if loop :'+result);
                  this.statusMessage = result;
                     if( this.statusMessage !== "SUCCEEDED" ) {       //Entered into infinite loop saying failed:error in file format                                 
                        console.log('if loop:'+this.statusMessage);
                        const toastMsg = new ShowToastEvent({
                            title : 'Dataset Status',
                            message : this.statusMessage,    // 'The Dataset is being uploaded. Please wait...',
                            variant : 'info',
                            
                        });
                        this.dispatchEvent(toastMsg);
                        this.getDatasetDetails1();
                    }
                    else {
                        console.log('else block:'+ this.statusMessage);
                        const toastMsg = new ShowToastEvent({
                        title : 'Dataset Status',
                        message : 'The Dataset has been created successfully. Now please hit the Train button.',
                        variant : 'success',
                        mode: 'sticky'
                        
                    });
                    this.dispatchEvent(toastMsg); 
                }
        } ).catch(error => {
                //console.error('Error in fetching datasetId :'+ error.body.message);
                console.error('Error in fetching datasetId :'+ error);
                const toastMsg = new ShowToastEvent({
                    title : 'Error in fetching datasetId',
                    message : error.body.message,
                    variant : 'error',
                    mode: 'sticky'
                });
                this.dispatchEvent(toastMsg);
            }),
           1000
            );
        } 
    trainDataset1(){
        console.log('this.datasetId@@@'+this.datasetId);
        trainDataset({datasetId : this.datasetId})
        .then(result => { 
            console.log('@ train model Id :'+result);
            this.modelId = result;
            if(this.modelId != null){
            const toastMsg = new ShowToastEvent({
                title : 'Dataset Train Status',
                message : 'A Model has been created from the Dataset. The Training process will start shortly.',
                variant : 'success',
                mode: 'sticky'
        });
            this.dispatchEvent(toastMsg);
            this.getDatasetTrainingStatus1();    
           }
           else{
               const toastMsg = new ShowToastEvent({
                   title :'Dataset Train status',
                   message : 'modelId :'+this.modelId,
                   variant : 'error'
               })
               this.dispatchEvent(toastMsg);
           }   
        } ).catch(error => {
            console.error('Error in fetching modelId :'+ error.body.message);
            const toastMsg = new ShowToastEvent({
                title : 'Dataset Train Status',
                message :  error.body.message,
                variant : 'error',
                mode: 'sticky'
                
            });
            this.dispatchEvent(toastMsg);
        });
    }
    getDatasetTrainingStatus1(){
        window.setTimeout( 
            getDatasetTrainingStatus({modelId : this.modelId})
              .then(result => {
                  this.count = this.count + 1;
                console.log('count :'+this.count);
              this.status = result;
              if( this.status != "SUCCEEDED" && this.status != "FAILED") {                   
                console.log('Training dataset status :'+this.status);
                const toastMsg = new ShowToastEvent({
                    title : 'Dataset Train Status',
                    message : 'The Training process has started. This might take few minutes to complete.',
                    variant : 'info',
                    
                });
                this.dispatchEvent(toastMsg);
                window.setTimeout(this.getDatasetTrainingStatus1(),10000000); 
                }
                else if(this.status == 'SUCCEEDED'){
                    console.log('train else block:'+ this.status);
                const toastMsg = new ShowToastEvent({
                    title : 'Dataset Train Status',
                    message : 'The Training process has been completed successfully. You can now try out the Prediction.',
                    variant : 'success',
                    mode: 'sticky'
                   
                });
                this.dispatchEvent(toastMsg);
            }
            else{
                console.log('else block');
                const toastMsg = new ShowToastEvent({
                    title : 'Dataset Train Status',
                    message : this.status,
                    variant : 'error',
                    mode: 'sticky'
                    
                });
                this.dispatchEvent(toastMsg);
            }
         } ).catch(error => {
                console.error('Error in train statusdetails :'+ error.body.message);
                const toastMsg = new ShowToastEvent({
                    title : 'Dataset Train Status',
                    message : error.body.message,
                    variant : 'error',
                    mode: 'sticky'
                    
                });
                this.dispatchEvent(toastMsg);
            }),
         1000
        );
    } 
    makePrediction() {
        
        predictIntent({modelId : this.modelId, text : this.predictLabel})
        .then(result =>{            
        this.intent = result.Intent;
        this.highProbability = result.Probability;
        this.isIntentVisible = true;
        console.log('@@ var highProbability :'+this.highProbability+', '+this.intent);
        this.apiUsage();
        })
        .catch(error=>{
            const toastMsg = new ShowToastEvent({
                title : 'Error in Predict',
                message : this.error.message,
                variant : 'error',
                mode: 'sticky'
               
            });
            this.dispatchEvent(toastMsg);
            })            
     } 
     apiUsage(){
        getApiUsage()
        .then(result => { console.log('result: '+result);
        this.predictionsMax = result.predictionsTotal;
        this.predictionsRemaining = result.predictionsRemaining;
        this.predictionsUsed = result.predictionsUsed;
        console.log('from lwc :'+this.predictionsRemaining + ', '+this.predictionsMax+', '+this.predictionsUsed);
        })
        .catch(error => {
            const toastMsg = new ShowToastEvent({
                title : 'Error in apiUsage callout',
                message : this.error.message,
                variant : 'error',
                mode: 'sticky'
               
            });
            this.dispatchEvent(toastMsg);
        })
     }           
}