<html class="layout-pf layout-pf-fixed transitions">
<head>
    <title>Windup 3.0</title>
    <base href="/windup-web/">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="${keycloak.serverUrl}/js/keycloak.js"></script>

    <script>
        // this is here so that AbstractUITest can tell we are loading the actual app
        window['mainApp'] = true;
        window['windupConstants'] = {
            'SERVER': '${serverUrl}',
            'SSO_MODE': 'login-required'
        };
    </script>

<link href="css/vendor.css" rel="stylesheet"><link href="css/app.css" rel="stylesheet"></head>

<body class="cards-pf">
<windup-app>
    <div id="loading" class="blank-slate-pf">
        <h1>
            Loading...
        </h1>
    </div>
</windup-app>
<script type="text/javascript" src="js/polyfills.js"></script><script type="text/javascript" src="js/vendor.js"></script><script type="text/javascript" src="js/app.js"></script></body>

</html>
