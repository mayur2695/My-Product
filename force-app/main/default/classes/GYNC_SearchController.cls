public with sharing class GYNC_SearchController {
    
    @AuraEnabled
    public static List <Product2> searchData() {
        List<Product2> prodList = new List<Product2>();
       for(Product2 prod : [SELECT Id,Name,ProductCode,GYNF_Availability__c,GYNCF_Price__c,GYNCF_Product_Category__r.Name,GYNCF_Average_Rating__c,GYNCF_Tags__c from Product2 
                              WHERE GYNCF_Product_Category__c != null])
                              {
                                prodList.add(prod);

                              }


    // System.debug(prodList);
//    List<Product2> prodList = [SELECT Id,GYNCF_Product_Category__r.Name,Name FROM product2];
    return prodList;
          
    } 
    @AuraEnabled
    public static List <Product2> priceLowToHigh(List<Product2> v) {
        System.debug('hello'+v);
       // List<Product2> accList = new List<Product2>();
       // for(Product2 acc : [SELECT Id, Name,ProductCode,GYNF_Availability__c,GYNCF_Price__c,GYNCF_Product_Category__r.name,GYNCF_Average_Rating__c from Product2 WHERE GYNCF_Product_Category__c != null AND GYNCF_Price__c != null ORDER BY GYNCF_Price__c ASC])
       // {
           // accList.add(acc);

      //  }
        //System.debug('retvalue is:'+retValue); 
        return v;
            
    }
    @AuraEnabled
    public static List <Product2> priceLowToHigh() {
        List<Product2> accList = new List<Product2>();
             for(Product2 acc : [SELECT Id, Name,ProductCode,GYNF_Availability__c,GYNCF_Price__c,GYNCF_Product_Category__r.name,GYNCF_Average_Rating__c from Product2 WHERE GYNCF_Product_Category__c != null AND GYNCF_Price__c != null ORDER BY GYNCF_Price__c ASC])
        {
            accList.add(acc);

       }
        //System.debug('retvalue is:'+retValue); 
        return accList;
            
    }
    @AuraEnabled
    public static List <Product2> priceHighToLow(List<Product2> v) {
        /*List<Product2> accList = new List<Product2>();
        for(Product2 acc : [SELECT Id, Name,ProductCode,GYNF_Availability__c,GYNCF_Price__c,GYNCF_Product_Category__r.name,GYNCF_Average_Rating__c from Product2 WHERE GYNCF_Product_Category__c != null AND GYNCF_Price__c != null ORDER BY GYNCF_Price__c DESC])
        {
            accList.add(acc);

        }*/
        return v;      
    }
    @AuraEnabled
    public static List <Product2> popularityLowToHigh(List<Product2> v) {
        System.debug('hello'+v);
        /*List<Product2> accList = new List<Product2>();
        for(Product2 acc : [SELECT Id, Name,ProductCode,GYNF_Availability__c,GYNCF_Price__c,GYNCF_Product_Category__r.name,GYNCF_Average_Rating__c from Product2 WHERE GYNCF_Product_Category__c != null AND GYNCF_Price__c != null ORDER BY GYNCF_Average_Rating__c ASC])
        {
            accList.add(acc);

        }*/
        return v;     
    }
    @AuraEnabled
    public static List <Product2> popularityHighToLow(List<Product2> v) {
        System.debug('hello'+v);
        // List<Product2> accList = new List<Product2>();
        // for(Product2 acc: [SELECT Id, Name,ProductCode,GYNF_Availability__c,GYNCF_Price__c,GYNCF_Product_Category__r.name,GYNCF_Average_Rating__c from Product2 WHERE GYNCF_Product_Category__c != null AND GYNCF_Price__c != null ORDER BY GYNCF_Average_Rating__c DESC])
        // {
        //     accList.add(acc);

        // }

        return v;      
    }   
    @AuraEnabled
    public static List<Product2> sliderProducts(decimal limitFromSlider,List<Product2> v){
        List<Product2> accList = new List<Product2>();
       // Product2 test=[select GYNCF_Price__c from Product2 where GYNCF_Price__c <= :limitfromSlider];
     //  integer value= integer.Parse(limitfromSlider,NumberStyles.Currency);
     //  limitFromSlider= [select GYNCF_Price__c from Product2];
      System.debug(limitFromSlider);
     //  integer test= integer.valueOf(limitFromSlider);
       // System.debug(test);
       for(Product2 prod : [SELECT Id, Name,ProductCode,GYNF_Availability__c,GYNCF_Price__c,GYNCF_Product_Category__r.name,GYNCF_Average_Rating__c from Product2 WHERE  Id IN : v AND GYNCF_Product_Category__c != Null AND GYNCF_Price__c <: limitFromSlider ])
       {
        accList.add(prod);

       }
       System.debug('Product list is:'+accList);
        return accList;
    }

}