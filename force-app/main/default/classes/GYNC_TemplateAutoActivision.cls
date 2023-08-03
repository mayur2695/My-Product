public class GYNC_TemplateAutoActivision {
    public static List<GYNCO_Offer_Letter_Template__c> ActiveFirstTemplate(List<GYNCO_Offer_Letter_Template__c> Temps){
       LIST<GYNCO_Offer_Letter_Template__c> T =[SELECT ID,Name FROM GYNCO_Offer_Letter_Template__c LIMIT 5];
        If(T.size()==0){
            Temps[0].GYNCF_Active__c = True;
        }
       Return Temps;
    }
}