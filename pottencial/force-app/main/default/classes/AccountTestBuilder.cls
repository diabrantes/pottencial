@isTest
public class AccountTestBuilder implements TestBuilder{
    private Account record;

    public AccountTestBuilder() {
        record = new Account();
    }

    public static AccountTestBuilder build() {
        return new AccountTestBuilder();
    }

    public Account getInstance() {
        return record;
    }

    public AccountTestBuilder withMockId() {
        record.Id = fflib_IDGenerator.generate(Account.SOBjectType);
        return this;
    }

    public AccountTestBuilder withName(String name) {
        record.Name = name;
        return this;
    }

    public AccountTestBuilder withIdentifier(String identifier) {
        record.Identificador__c = identifier;
        return this;
    }
}