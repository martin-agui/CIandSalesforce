global with sharing class ProjectCalloutServiceMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request){
        // System.assertEquals('callout:ProjectService', request.getEndpoint());
        // System.assertEquals('POST', request.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        return res;
    }
}
