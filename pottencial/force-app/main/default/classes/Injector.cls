public class Injector {
    private static Injector instance;
    @TestVisible
    private static Injector mockInjector;

    public static Injector getInstance() {
        if (mockInjector != null) {
            return mockInjector;
        } else {
            if (instance == null) {
                instance = new Injector();
            }
            return instance;
        }
    }
}