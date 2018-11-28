declare module "@salesforce/apex/FileController.saveTheFile" {
  export default function saveTheFile(param: {parentId: any, fileName: any, base64Data: any, contentType: any}): Promise<any>;
}
declare module "@salesforce/apex/FileController.saveTheChunk" {
  export default function saveTheChunk(param: {parentId: any, fileName: any, base64Data: any, contentType: any, fileId: any}): Promise<any>;
}
