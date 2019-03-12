## Aanroep van een Azure LogicApp
Vanuit de fulfilment service (mergetool) kan via de action "webservice" een REST API oproep worden gedaan. Als voorbeeld roepen we in onderstaande snippet een Azure LogicApp op, maar dit had ook een Office 365 Flow kunnen zijn of een andere REST API.
Voor de LogicApp  gebruiken we een POST om de data als JSON door te geven. Voor deze API maakt het niet uit wat de structuur is omdat we dit in de LogicApp zelf kunnen bepalen, maar zou er een specifieke REST API worden oproepen dan moet het formaat overeenkomen met die betreffende API.

Vervang in onderstaande voorbeeld de `url` en `method` parameter door de specifiek inbound end-point url van de LogicApp die gebruikt wordt. In ons voorbeeld hebben we in de payload zoveel mogelijk de CallPro benaming overgenomen, en ook diverse aparte sub-objecten gemaakt. De payload hoeft uiteraard alleen de data en velden te bevatten die nodig zijn zodat de API die wordt aangeroepen zijn werk kan doen. 

```
<Action Type="webservice" Collection="FLOW">
	<library>azure</library>   
	<url>https://prod-107.westeurope.logic.azure.com:443/</url>   
	<header name="content-type">application/json</header>
	<header name="accept">application/json</header> 
	<method type="POST">
	workflows/guid/triggers/manual/paths/invoke?api-version=2016-10-01&amp;sp=%2Ftriggers%2Fmanual%2Frun&amp;sv=1.0&amp;sig=signature
	</method>
	<payload>
	{
        "entry": {
            "clentryid": %ENTRY.CLENTRYID%,
            "statid": %ENTRY.STATID%,
            "statdate": "%ENTRY.STATDATE \DTyyyy-MM-dd HH:mm%",
            "statpriority": %ENTRY.STATPRIORITY%,
            "note": "%ENTRY.ENTRYNOTE \UL%"
        },
        "agent": {
            "resid": %AGENT.RESID%,
            "name": "%AGENT.NAME%"
        },	
        "campaign": {
            "resid": %CAMPAIGN.RESID%,
            "name": "%CAMPAIGN.NAME%"
        },
        "status": {
            "statid": %STATUS.STATID%,
            "name": "%STATUS.NAME%",
            "statcode": "%STATUS.STATCODE%",
            "statpriority": %STATUS.STATPRIORITY% 
        },
        "script": {
            "telnr": "%SCRIPT.TELNR%",
            "gsmnr": "%SCRIPT.GSMNR%",
            "name_gender": "%SCRIPT.NAME_GENDER%",
            "name_first": "%SCRIPT.NAME_FIRST%",
            "name_middle": "%SCRIPT.NAME_MIDDLE%",
            "name_last": "%SCRIPT.NAME_LAST%",
            "addr_street": "%SCRIPT.ADDR_STREET%",
            "addr_number": "%SCRIPT.ADDR_NUMBER%",
            "addr_zip": "%SCRIPT.ADDR_ZIP%",
            "addr_city": "%SCRIPT.ADDR_CITY%",
            "email": "%SCRIPT.EMAIL%",
            "info": "%SCRIPT.INFO%"
        }
	}
	</payload>
</Action>   
```

