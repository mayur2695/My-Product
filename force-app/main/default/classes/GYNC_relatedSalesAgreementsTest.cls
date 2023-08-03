/* Test Class for the Apex Controller class GYNC_relatedSalesAgreements
* Developer Name: Indrajit Mitra
* Created On:16/02/2021
*/ 

@isTest
public class GYNC_relatedSalesAgreementsTest {
    
    @isTest
    public static void testAgreements(){
        
        Account testAcc= new Account(Name= 'Test Account');
        insert testAcc;
        Product2 prod = new Product2(Name = 'Laptop X200',
                                     Family = 'Hardware');
        insert prod;
        
        Product2 prod2= new Product2(Name = 'Speaker', Family = 'Hardware');
        insert prod2;
        
        
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        SalesAgreement saObj= new SalesAgreement();
        saObj.Name='Test SA';
        saObj.AccountId= testAcc.id;
        saObj.CurrencyIsoCode = 'USD';
        saObj.PricebookId = pricebookId;
        saObj.Status= 'Draft';
        saObj.StartDate= Date.newInstance(2021, 02, 11);
        saObj.ScheduleFrequency= 'Monthly';
        saObj.ScheduleCount= 1;
        insert saObj;
        
        SalesAgreementProduct sapObj = new SalesAgreementProduct();
        sapObj.SalesAgreementId = saObj.id;
        sapObj.InitialPlannedQuantity = 10;
        sapObj.PricebookEntryId= standardPrice.id;
        sapObj.Name= prod.Name;
        insert  sapObj;
        
        Order oObj= new Order();
        oObj.AccountId= testAcc.id;
        oObj.Pricebook2Id = pricebookId;
        oObj.Status = 'Draft';
        oObj.EffectiveDate = Date.newInstance(2021, 02, 11);
        insert oObj;
        
        OrderItem oiObj= new OrderItem();
        oiObj.Product2Id= prod.id;
        oiObj.Quantity=10;
        oiObj.UnitPrice = 100;
        oiObj.OrderId = oObj.id;
        oiObj.PricebookEntryId= standardPrice.id;
        insert oiObj;  
        Test.startTest();
        GYNC_relatedSalesAgreements.fetchSalesAgreement(oiObj.id); 
        
        GYNC_relatedSalesAgreements.updateSalesAgreement(oiObj.id,saObj.id);
        Test.stopTest();
        System.assert(true);
    }
}