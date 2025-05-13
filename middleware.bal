import ballerina/http;
import ballerina/log;

http:Client backend = check new ("http://localhost:8081");

service /api on new http:Listener(8080) {

    resource function post transform(http:Caller caller, http:Request req) returns error? {
        json input = check req.getJsonPayload();
        string fullName = <string>input.fullName;

        // Transform: fullName → firstName + lastName
        string[] parts = fullName.split(" ");
        json transformedReq = {
            firstName: parts[0],
            lastName: parts.length() > 1 ? parts[1] : ""
        };

        // Call Java backend
        http:Response response = check backend->post("/greet", transformedReq);
        json backendResp = check response.getJsonPayload();

        // Transform backend response
        json finalResp = {
            msg: backendResp.greeting
        };

        check caller->respond(finalResp);
    }
}
