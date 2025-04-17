
  

# Twilio Plugin for MSM

This plugin facilitates Twilio usage with Marval.
One use case for this is to create a voice call to Twilio for a Major Incident.
In this case, you would

  
## Compatible Versions

  

| Plugin | MSM |
|---------|-------------|
| 1.0.0 | 15+ |

  
  

## Installation

  

If you do not have an API key for Twilio, you can generate one by accessing the Twilio API dashboard <a  href="https://console.twilio.com/us1/account/keys-credentials/api-keys"> here</a>

  
  

## Settings

  

### Twilio Voice

The Twilio Voice if unset, defaults to your global Twilio settings. You can set the Twilio man, woman, or an Amazon Polly Voices or Google Voices.

See this page for more information on the settings.

<a  href="https://www.twilio.com/docs/voice/twiml/say/text-speech#available-voices-and-languages">Twilio Voice and Language Settings</a>

  ### Twilio Voice
  

Some valid values for voice settings are the following

  

| Language | Voice                          | Gender |
|----------|--------------------------------|---|
| en-GB | Google.en-GB-Chirp3-HD-Aoede      | Female
| en-GB | Google.en-GB-Chirp3-HD-Kore       | Female
| en-GB | en-GB-Chirp3-HD-Orus      | Male
| en-GB | en-GB-Chirp3-HD-Puck      | Male
| en-GB | Polly.Amy-Neural      | Female
| en-GB | Polly.Arthur-Neural      | Male
| en-ZA | Polly.Ayanda-Neural      | Female
| en-US | Google.en-US-Chirp3-HD-Orus      | Male
| en-US | Google.en-US-Chirp3-HD-Leda      | Female
| es-ES | Google.es-ES-Chirp3-HD-Aoede      | Female
| es-ES | Google.es-ES-Chirp3-HD-Charon      | Male
| en-AU | Polly.Olivia-Neural      | Female
| en-AU | Polly.Russell      | Male
| en-AU | Google.en-AU-Neural2-A      | Female
| en-AU | Google.en-AU-Neural2-B      | Male
  
   > Supplying blank values for Language and Voice will revert them to your Twilio default settings.

### Contributing

  

We welcome all feedback including feature requests and bug reports. Please raise these as issues on GitHub. If you would like to contribute to the project please fork the repository and issue a pull request.
