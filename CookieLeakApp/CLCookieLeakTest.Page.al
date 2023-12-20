page 50100 CLCookieLeakTest
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Cookie Leak Test';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(ApiBaseUrl; ApiBaseUrl)
                {
                    Caption = 'API Base URL';
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(StartPassTest)
            {
                Caption = 'Start Test (Regular)';
                ApplicationArea = All;
                ToolTip = 'Starts a succesful api test (login/validate) without any other session involved)';

                trigger OnAction()
                var
                    CookieLeakTest: Codeunit CLCookieLeakTest;
                begin
                    CookieLeakTest.StartPassTest(ApiBaseUrl);
                    Message('Test Completed');
                end;
            }
            action(StartFailTest)
            {
                Caption = 'Start Test (Cookie Leak)';
                ApplicationArea = All;
                Tooltip = 'Startes a failing api test, where another session logs in and the cookie from the other session is leaked to this session and passed to the api';

                trigger OnAction()
                var
                    CookieLeakTest: Codeunit CLCookieLeakTest;
                begin
                    CookieLeakTest.StartFailTest(ApiBaseUrl);
                    Message('Test Completed');
                end;
            }
        }
    }

    var
        ApiBaseUrl: Text;
}