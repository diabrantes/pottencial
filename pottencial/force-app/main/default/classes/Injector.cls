public class Injector {
    private static Injector instance;
    @TestVisible
    private static Injector mockInjector;

    public static Injector getInstance() {
        if (instance == null) {
            instance = mockInjector;
        } else {
            instance = new Injector();
        }

        return instance;
    }

    public Object instantiate(Type classType) {
        Object instance = classType.newInstance();
        return instance;
    }
}