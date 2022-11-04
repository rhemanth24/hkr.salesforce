@isTest
private class TemperatureConverterTestclass {    
    @isTest static void testWarmTemp(){
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(70);
        System.assertEquals(21.11,celsius);
    }
}
