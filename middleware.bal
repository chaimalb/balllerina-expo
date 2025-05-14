import ballerina/http;
import ballerina/lang.value;
import ballerina/regex;


@http:ServiceConfig {
    cors: {
        allowOrigins: ["*", "null", "file://"],
        allowCredentials: false,
        allowHeaders: ["*", "Content-Type"],
        allowMethods: ["POST", "OPTIONS", "GET"],
        exposeHeaders: ["*", "Content-Type"],
        maxAge: 3600
    }
}
service /api on new http:Listener(8080) {
    
    resource function options transform(http:Caller caller, http:Request req) returns error? {
        http:Response res = new;
        res.setHeader("Access-Control-Allow-Origin", "*");
        res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Content-Type");
        check caller->respond(res);
    }

    isolated resource function post transform(http:Caller caller, http:Request req) returns error? {
        // Create HTTP client
        http:Client backend = check new ("http://localhost:8081");
        // 1. Get JSON body
        json payload = check req.getJsonPayload();        // 2. Convert json to map<string>
        map<json> jsonMap = <map<json>>payload;
        
        // 3. Safely extract fullName
        string fullName = check value:ensureType(jsonMap["fullName"], string);

        // 4. Split using regex module
        string[] parts = regex:split(fullName, " ");

        // 5. Prepare backend request
        json transformedReq = {
            firstName: parts[0],
            lastName: parts.length() > 1 ? parts[1] : ""
        };

        // 6. Call Java backend
        http:Response response = check backend->post("/greet", transformedReq);

        // 7. Parse backend JSON response
        json backendResp = check response.getJsonPayload();
        map<json> backendMap = <map<json>>backendResp;
        string greeting = check value:ensureType(backendMap["greeting"], string);        // 8. Send final response with CORS headers
        http:Response res = new;
        res.setHeader("Access-Control-Allow-Origin", "*");
        res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Content-Type");
        json finalResp = { msg: greeting };
        res.setJsonPayload(finalResp);
        check caller->respond(res);
    }
}
