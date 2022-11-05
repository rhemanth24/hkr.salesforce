public with sharing class TemperatureConverter {
    public TemperatureConverter() {

    }
    public static Decimal FahrenheitToCelsius(Decimal fh){
        Decimal cs = (fh - 32) * 5/9;
        system.debug('Adding Comment');
        return cs.setScale(2);
    }
}
