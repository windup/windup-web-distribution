<html class="layout-pf layout-pf-fixed transitions">
<head>
    <title>Red Hat Application Migration Toolkit Web Console (RHAMT WC)</title>
    <base href="${basePath}">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="${keycloak.serverUrl}/js/keycloak.js"></script>

    <script>
        // this is here so that AbstractUITest can tell we are loading the actual app
        window['mainApp'] = true;
        window['windupConstants'] = {
            'SERVER': '${serverUrl}',
            'REST_SERVER': '${serverUrl}',
            'REST_BASE': '${apiServerUrl}',
            'GRAPH_REST_BASE': '${graphApiServerUrl}',
            'STATIC_REPORTS_BASE': '${staticReportServerUrl}',
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
