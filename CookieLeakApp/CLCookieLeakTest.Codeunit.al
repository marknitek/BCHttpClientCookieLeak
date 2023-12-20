codeunit 50100 "CLCookieLeakTest"
{
    TableNo = 50100;
    trigger OnRun()
    begin
        Login(Rec.ApiBaseUrl, Rec.Username, Rec.Password);
    end;

    procedure StartPassTest(ApiBaseUrl: Text)
    begin
        // Login with user1 and validate cookie that was returned and is used by the httpclient silently
        Login(ApiBaseUrl, 'user1', 'password1');
        Validate(ApiBaseUrl, 'user1', 'password1');
    end;

    procedure StartFailTest(ApiBaseUrl: Text)
    var
        Parameter: Record CLCookieLeakTestParameter;
        Session: Record Session;
        OtherSessionId: Integer;
        SessionStarted: Boolean;
    begin
        // Login with user1 and validate cookie that was returned and is used by the httpclient silently
        Login(ApiBaseUrl, 'user1', 'password1');
        Validate(ApiBaseUrl, 'user1', 'password1');

        // Start another Session and login with user2
        OtherSessionId := 0;
        Parameter.ApiBaseUrl := ApiBaseUrl;
        Parameter.Username := 'user2';
        Parameter.Password := 'password2';
        SessionStarted := StartSession(OtherSessionId, Codeunit::CLCookieLeakTest, CompanyName(), Parameter);
        if not SessionStarted then
            StopSession(OtherSessionId);

        // Wait for the other session to finish
        repeat
            Sleep(1000);
        until not Session.Get(OtherSessionId);

        // Validate with user1 again
        Validate(ApiBaseUrl, 'user1', 'password1');
    end;

    local procedure Login(ApiBaseUrl: Text; Username: Text; Password: Text)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
    begin
        Request.SetRequestUri(ApiBaseUrl + '/login' + '?username=' + Username + '&password=' + Password);
        Request.Method('GET');
        if not Client.Send(Request, Response) then
            Error('Error sending request to %1. Something went wrong', ApiBaseUrl + '/login');
        if not Response.IsSuccessStatusCode() then
            Error('Error sending request to %1. Status code %2 - %3', ApiBaseUrl + '/login', Response.HttpStatusCode, Response.ReasonPhrase);
    end;

    local procedure Validate(ApiBaseUrl: Text; Username: Text; Password: Text)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        ResponseText: Text;
        ErrorText: Text;
    begin
        Request.SetRequestUri(ApiBaseUrl + '/validate' + '?username=' + Username + '&password=' + Password);
        if not Client.Send(Request, Response) then
            Error('Error sending request to %1. Something went wrong', ApiBaseUrl + '/validate');
        if not Response.IsSuccessStatusCode() then begin
            ErrorText := StrSubstNo('Error sending request to %1. Status code %2 - %3', ApiBaseUrl + '/validate', Response.HttpStatusCode, Response.ReasonPhrase);
            if Response.Content.ReadAs(ResponseText) then
                ErrorText += ' ' + ResponseText;
            Error(ErrorText);
        end;
    end;
}