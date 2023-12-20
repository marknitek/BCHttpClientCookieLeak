table 50100 "CLCookieLeakTestParameter"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; PK; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; ApiBaseUrl; Text[1024])
        {
            DataClassification = CustomerContent;
        }
        field(3; Username; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(4; Password; Text[50])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; PK)
        {
            Clustered = true;
        }
    }

}