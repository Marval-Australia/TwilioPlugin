<%@ WebHandler Language = "C#" Class="Handler" %>

using System;
using System.IO;
using System.Net;
using System.Xml;
using System.Xml.Linq;
using System.Reflection;
using System.Xml.Serialization;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using Serilog;
using System.Web.Script.Serialization;
using System.Web;
using MarvalSoftware.UI.WebUI.ServiceDesk.RFP.Plugins;
using System.Net.Http;

public class Handler : PluginHandler
{

    private string TwilioVoice { get { return this.GlobalSettings["@@TwilioVoice"]; } }
    private string TwilioLanguage { get { return this.GlobalSettings["@@TwilioLanguage"]; } }
    private string TwilioAuthToken { get { return this.GlobalSettings["@@TwilioAuthToken"]; } }
    private string TwilioAccountSID { get { return this.GlobalSettings["@@TwilioAccountSID"]; } }
    private string TwilioFromPhone { get { return this.GlobalSettings["@@TwilioFromPhone"]; } }


    private string MarvalAPIKey { get { return this.GlobalSettings["@@MarvalAPIKey"]; } }

    public override bool IsReusable { get { return false; } }


    private string PostRequest(string url, string data, string credentials = "", string contentType = "application/json")
    {
        try
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "POST";
            request.ContentType = contentType;
            request.Headers.Add("Authorization", credentials);
            Log.Information("Posting to address" + url);
            Log.Information("Posting with credentials " + credentials);
            Log.Information("Posting with data " + data);
            if (contentType.Equals("application/x-www-form-urlencoded", StringComparison.OrdinalIgnoreCase))
            {
                data = System.Web.HttpUtility.UrlEncode(data);
            }

            using (StreamWriter writer = new StreamWriter(request.GetRequestStream()))
            {
                writer.Write(data);
            }

            using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
            {
                using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                {
                    return reader.ReadToEnd();
                }
            }
        }
        catch (WebException webEx)
        {
            if (webEx.Response != null)
            {
                using (var errorResponse = (HttpWebResponse)webEx.Response)
                {
                    using (var reader = new StreamReader(errorResponse.GetResponseStream()))
                    {
                        string errorText = reader.ReadToEnd();
                        return errorText;
                    }
                }
            }

            return webEx.Message;
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }
    }
    private string PostRequest2(string url, HttpContent data, string credentials = "", string contentType = "application/json")
    {
        try
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "POST";
            request.ContentType = contentType;
            request.Headers.Add("Authorization", credentials);
            Log.Information("Posting to address" + url);
            Log.Information("Posting with credentials " + credentials);
            Log.Information("Posting with data " + data);

            using (Stream requestStream = request.GetRequestStream())
            {
                data.CopyToAsync(requestStream).GetAwaiter().GetResult();
            }

            using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
            using (StreamReader reader = new StreamReader(response.GetResponseStream()))
            {
                return reader.ReadToEnd();
            }
        }
        catch (WebException webEx)
        {
            if (webEx.Response != null)
            {
                using (var errorResponse = (HttpWebResponse)webEx.Response)
                {
                    using (var reader = new StreamReader(errorResponse.GetResponseStream()))
                    {
                        string errorText = reader.ReadToEnd();
                        return errorText;
                    }
                }
            }

            return webEx.Message;
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }
    }


    public override void HandleRequest(HttpContext context)
    {
        var param = context.Request.HttpMethod;
        var browserObject = context.Request.Browser;

        //   MsmRequestNo = !string.IsNullOrWhiteSpace(context.Request.Params["requestNumber"]) ? int.Parse(context.Request.Params["requestNumber"]) : 0;

        switch (param)
        {
            case "GET":
                var getParamVal = context.Request.Params["endpoint"] ?? string.Empty;
                if (getParamVal == "")
                {
                    context.Response.Write("No parameter specified");
                }
                else
                {
                    Log.Information("No valid GET parameter requested");
                    context.Response.Write("No valid GET parameter requested");
                }
                break;
            case "POST":
                var message = context.Request.Form["Message"];
                //var phoneFrom = context.Request.Form["phoneFrom"];
                var phoneTo = context.Request.Form["phoneTo"];
                var action = context.Request.Form["action"];

                if (action == "createTeams")
                {
                    context.Response.Write("Test Only");
                }
                else if (action == "Twilio")
                {
                    try
                    {
                        var runSpeechResponseValue = this.runSpeech(message, TwilioFromPhone, phoneTo, TwilioVoice, TwilioLanguage);
                        context.Response.Write(runSpeechResponseValue);
                    }
                    catch (Exception ex)
                    {
                      
                        context.Response.StatusCode = 400;
                       // context.Response.ContentType = "application/json";
                        context.Response.ContentType = "text/plain";
                        context.Response.Write(ex);
                    }
                }
                else
                {
                    Log.Information("No valid POST parameter requested");
                    context.Response.Write("No valid POST parameter requested");
                }
                break;
        }
    }
    public string runSpeech(string text, string phoneFrom, string phoneTo, string voice = "", string language = "")
    {

        var SID = TwilioAccountSID;
        var APIKey = TwilioAuthToken;

        string TwimlText =
       @"<?xml version=""1.0"" encoding=""UTF-8""?><Response><Say voice="""
        + voice
        + @""" language="""
        + language
        + @""">"
        + text
        + "</Say></Response>";

        Log.Information("Have Twiml String as " + TwimlText);
        var data = new[]
  {
        new KeyValuePair<string, string>("To", phoneTo),
        new KeyValuePair<string, string>("From", phoneFrom),
        new KeyValuePair<string, string>("Twiml", TwimlText)
    };
        var content = new FormUrlEncodedContent(data);
        var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(SID + ":" + APIKey);
        var basicAuthToken = System.Convert.ToBase64String(plainTextBytes);
        Log.Information("Have api key string as " + System.Convert.ToBase64String(plainTextBytes));

        var response = PostRequest2("https://api.twilio.com/2010-04-01/Accounts/" + SID + "/Calls", content, "Basic " + basicAuthToken, "application/x-www-form-urlencoded");
        Log.Information("Response is " + response);
        return response;
    }



}
