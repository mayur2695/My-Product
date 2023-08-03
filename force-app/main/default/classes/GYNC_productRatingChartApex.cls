public with sharing class GYNC_productRatingChartApex {
    public class ratingMatrixWrapper {
        @Auraenabled Public String name{get;set;}
        @Auraenabled Public Integer ratingCount{get;set;}
        @Auraenabled Public Decimal ratingPercentage{get;set;}
        /*Public ratingMatrixWrapper(String name, Integer ratingCount, Decimal ratingPercentage){
this.name = name;
this.ratingCount = ratingCount;
this.ratingPercentage = ratingPercentage;
}*/
    }
    
    public class ratingWrapper {
        @Auraenabled Public Integer totalRatingCount{get;set;} 
        @Auraenabled Public Decimal averageRating{get;set;} 
        @Auraenabled Public List<ratingMatrixWrapper> ratingMatrix{get;set;}
        public ratingWrapper(){
            totalRatingCount = 0;
            averageRating = 0.0;
            ratingMatrix = new List<ratingMatrixWrapper>();
        }
    }
    @Auraenabled
    public static ratingWrapper findReviewMatrix(Id productId){
        system.debug('Check 25: '+productId);
        ratingWrapper returnWrapper = new ratingWrapper();
        List<ratingMatrixWrapper> ratingMatrix = new List<ratingMatrixWrapper>();
        List<GYNCO_Product_Review__c> reviewList = new List<GYNCO_Product_Review__c>();
        Map<Integer, Integer> ratingCountMap = new Map<Integer, Integer>(); 
        reviewList = [SELECT GYNCF_Rating__c, GYNCF_Product__r.GYNCF_Average_Rating__c FROM GYNCO_Product_Review__c WHERE GYNCF_Product__c =: productId];
        system.debug(reviewList);
        ratingCountMap.put(1, 0);
        ratingCountMap.put(2, 0);
        ratingCountMap.put(3, 0);
        ratingCountMap.put(4, 0);
        ratingCountMap.put(5, 0);
        for(GYNCO_Product_Review__c review : reviewList){
            system.debug(reviewList);
            if(ratingCountMap.containsKey(integer.valueof(review.GYNCF_Rating__c))){
                Integer ratingCount = ratingCountMap.get(integer.valueof(review.GYNCF_Rating__c));
                ratingCountMap.put(integer.valueof(review.GYNCF_Rating__c), ratingCount+1);
            }
            
        }
        system.debug(ratingCountMap);
        Integer totalReviewCount = reviewList.size();
        for(Integer key : ratingCountMap.keySet()){
            ratingMatrixWrapper Star = new ratingMatrixWrapper();
            Star.name = key + ' Star';
            Star.ratingCount = ratingCountMap.get(key); 
            if(totalReviewCount != 0){
                Star.ratingPercentage = (Star.ratingCount*100)/totalReviewCount;
            }
            else{
                Star.ratingPercentage = 0;
            }
            ratingMatrix.add(Star);
            
        }
        system.debug(ratingMatrix);
        returnWrapper.ratingMatrix = ratingMatrix;
        returnWrapper.totalRatingCount = totalReviewCount;
        returnWrapper.averageRating = 0.0;
        if(reviewList.size()>0){
            returnWrapper.averageRating = reviewList[0].GYNCF_Product__r.GYNCF_Average_Rating__c;  
        }
        
        return returnWrapper;
        
        //ratingMatrix.add()
    }
    
}