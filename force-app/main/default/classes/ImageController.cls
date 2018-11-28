public class ImageController {
    public String imageURL{get;set;}
    public String sfdcBaseURL{get;set;}
    public List<Attachment> attList{get;set;} 
       
    public ImageController(){
        sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();       
        imageURL = sfdcBaseURL + '/servlet/servlet.FileDownload?file=';
        attList = [SELECT BodyLength,Id,Name FROM Attachment where Description = null AND ContentType IN ('image/jpeg','image/gif','image/png','image/jpg','image/bmp') AND Name Like 'image00%' AND BodyLength < 20480 Order By CreatedDate ASC LIMIT 1000];
    }
}