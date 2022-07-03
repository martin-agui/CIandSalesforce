global with sharing class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request){
        // System.assertEquals('callout:ProjectService', request.getEndpoint());
        // System.assertEquals('POST', request.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(500);
        return res;
    }
}
