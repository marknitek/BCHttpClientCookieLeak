using System.Collections.Specialized;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Net.Http.Headers;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

var app = builder.Build();

app.MapGet("/login", async (HttpContext context) =>
{
    var username = context.Request.Query["username"];
    var password = context.Request.Query["password"];

    var cookieOptions = new CookieOptions(); 
    cookieOptions.Expires = DateTime.Now.AddDays(1);
    cookieOptions.Path = "/"; 

    context.Response.Cookies.Append("SessionUser", username, cookieOptions);
});

app.MapGet("/validate", (HttpContext context) =>
{
    var username = context.Request.Query["username"];
    var password = context.Request.Query["password"];

    if (context.Request.Cookies.ContainsKey("SessionUser"))
    {
        var cookie = context.Request.Cookies["SessionUser"];
        if (cookie == username)
        {
            return Results.Ok();
        } else {
            return Results.BadRequest($"Provided Cookie does not belong to the user: {username}");
        }
    }
    
    return Results.BadRequest("No Cookie provided, Please login first");
});

app.Run();