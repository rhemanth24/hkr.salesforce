public class PredictUsageResponse {

	public class PlanData {
		public String plan {get;set;} 
		public Integer amount {get;set;} 
		public String source {get;set;} 

		public PlanData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'plan') {
							plan = parser.getText();
						} else if (text == 'amount') {
							amount = parser.getIntegerValue();
						} else if (text == 'source') {
							source = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'PlanData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String object_Z {get;set;} // in json: object
	public List<Data> data {get;set;} 

	public PredictUsageResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'object') {
						object_Z = parser.getText();
					} else if (text == 'data') {
						data = arrayOfData(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Data {
		public String id {get;set;} 
		public String organizationId {get;set;} 
		public String startsAt {get;set;} 
		public String endsAt {get;set;} 
		public List<PlanData> planData {get;set;} 
		public String licenseId {get;set;} 
		public String object_Z {get;set;} // in json: object
		public Integer predictionsRemaining {get;set;} 
		public Integer predictionsUsed {get;set;} 
		public Integer predictionsMax {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'organizationId') {
							organizationId = parser.getText();
						} else if (text == 'startsAt') {
							startsAt = parser.getText();
						} else if (text == 'endsAt') {
							endsAt = parser.getText();
						} else if (text == 'planData') {
							planData = arrayOfPlanData(parser);
						} else if (text == 'licenseId') {
							licenseId = parser.getText();
						} else if (text == 'object') {
							object_Z = parser.getText();
						} else if (text == 'predictionsRemaining') {
							predictionsRemaining = parser.getIntegerValue();
						} else if (text == 'predictionsUsed') {
							predictionsUsed = parser.getIntegerValue();
						} else if (text == 'predictionsMax') {
							predictionsMax = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static PredictUsageResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new PredictUsageResponse(parser);
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
	


    private static List<Data> arrayOfData(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data(p));
        }
        return res;
    }

    public PredictUsageResponse(){
        
    }



    private static List<PlanData> arrayOfPlanData(System.JSONParser p) {
        List<PlanData> res = new List<PlanData>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new PlanData(p));
        }
        return res;
    }


}