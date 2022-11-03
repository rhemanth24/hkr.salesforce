public class PredictionResponse {

	public List<Probabilities> probabilities {get;set;} 
	public String object_Z {get;set;} // in json: object

	public PredictionResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'probabilities') {
						probabilities = arrayOfProbabilities(parser);
					} else if (text == 'object') {
						object_Z = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Probabilities {
		public Double probability {get;set;} 
		public String label {get;set;} 
        
        public Probabilities() {
        
    }
		public Probabilities(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'probability') {
							probability = parser.getDoubleValue();
						} else if (text == 'label') {
							label = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Probabilities consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static PredictionResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new PredictionResponse(parser);
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
	
    public PredictionResponse() {
        
    }

    private static List<Probabilities> arrayOfProbabilities(System.JSONParser p) {
        List<Probabilities> res = new List<Probabilities>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Probabilities(p));
        }
        return res;
    }
}