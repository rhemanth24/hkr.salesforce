public class TrainingStatusResponse {

	public Integer datasetId {get;set;} 
	public Integer datasetVersionId {get;set;} 
	public String name {get;set;} 
	public String status {get;set;} 
	public Integer progress {get;set;} 
	public String createdAt {get;set;} 
	public String updatedAt {get;set;} 
	public String modelId {get;set;} 
	public Double learningRate {get;set;} 
	public Integer epochs {get;set;} 
	public String modelType {get;set;} 
	public String algorithm {get;set;} 
	public String language {get;set;} 
	public String object_Z {get;set;} // in json: object
	public TrainParams trainParams {get;set;} 
	public TrainStats trainStats {get;set;} 

	public TrainingStatusResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'datasetId') {
						datasetId = parser.getIntegerValue();
					} else if (text == 'datasetVersionId') {
						datasetVersionId = parser.getIntegerValue();
					} else if (text == 'name') {
						name = parser.getText();
					} else if (text == 'status') {
						status = parser.getText();
					} else if (text == 'progress') {
						progress = parser.getIntegerValue();
					} else if (text == 'createdAt') {
						createdAt = parser.getText();
					} else if (text == 'updatedAt') {
						updatedAt = parser.getText();
					} else if (text == 'modelId') {
						modelId = parser.getText();
					} else if (text == 'learningRate') {
						learningRate = parser.getDoubleValue();
					} else if (text == 'epochs') {
						epochs = parser.getIntegerValue();
					} else if (text == 'modelType') {
						modelType = parser.getText();
					} else if (text == 'algorithm') {
						algorithm = parser.getText();
					} else if (text == 'language') {
						language = parser.getText();
					} else if (text == 'object') {
						object_Z = parser.getText();
					} else if (text == 'trainParams') {
						trainParams = new TrainParams(parser);
					} else if (text == 'trainStats') {
						trainStats = new TrainStats(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class TrainStats {
		public Integer labels {get;set;} 
		public Integer examples {get;set;} 
		public Double averageF1 {get;set;} 
		public String totalTime {get;set;} 
		public Object transforms {get;set;} 
		public String trainingTime {get;set;} 
		public Boolean earlyStopping {get;set;} 
		public Integer lastEpochDone {get;set;} 
		public String modelSaveTime {get;set;} 
		public Integer testSplitSize {get;set;} 
		public Integer trainSplitSize {get;set;} 
		public String datasetLoadTime {get;set;} 
		public Object preProcessStats {get;set;} 
		public Object postProcessStats {get;set;} 
		public String globalResourceDownloadTime {get;set;} 

		public TrainStats(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'labels') {
							labels = parser.getIntegerValue();
						} else if (text == 'examples') {
							examples = parser.getIntegerValue();
						} else if (text == 'averageF1') {
							averageF1 = parser.getDoubleValue();
						} else if (text == 'totalTime') {
							totalTime = parser.getText();
						} else if (text == 'transforms') {
							transforms = parser.readValueAs(Object.class);
						} else if (text == 'trainingTime') {
							trainingTime = parser.getText();
						} else if (text == 'earlyStopping') {
							earlyStopping = parser.getBooleanValue();
						} else if (text == 'lastEpochDone') {
							lastEpochDone = parser.getIntegerValue();
						} else if (text == 'modelSaveTime') {
							modelSaveTime = parser.getText();
						} else if (text == 'testSplitSize') {
							testSplitSize = parser.getIntegerValue();
						} else if (text == 'trainSplitSize') {
							trainSplitSize = parser.getIntegerValue();
						} else if (text == 'datasetLoadTime') {
							datasetLoadTime = parser.getText();
						} else if (text == 'preProcessStats') {
							preProcessStats = parser.readValueAs(Object.class);
						} else if (text == 'postProcessStats') {
							postProcessStats = parser.readValueAs(Object.class);
						} else if (text == 'globalResourceDownloadTime') {
							globalResourceDownloadTime = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TrainStats consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TrainParams {

		public TrainParams(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'TrainParams consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static TrainingStatusResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new TrainingStatusResponse(parser);
	}
    public TrainingStatusResponse(){
        
    }
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

}