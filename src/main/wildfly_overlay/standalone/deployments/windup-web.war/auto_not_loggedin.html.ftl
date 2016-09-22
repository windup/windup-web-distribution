<html>
<head>
    <title>Windup 3.0</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- PatternFly Styles -->
    <!-- Note: No other CSS files are needed regardless of what other JS packages located in patternfly/components that you decide to pull in -->
    <link rel="stylesheet" href="node_modules/patternfly/dist/css/patternfly.min.css">
    <link rel="stylesheet" href="node_modules/patternfly/dist/css/patternfly-additions.min.css">
    <link rel="stylesheet" href="css/windup-web.css">

    <!-- jQuery -->
    <script src="node_modules/jquery/dist/jquery.min.js"></script>

    <!-- Bootstrap JS -->
    <script src="node_modules/bootstrap/dist/js/bootstrap.min.js"></script>

    <script src="${keycloak.serverUrl}/js/keycloak.js"></script>

    <script>
        // Append a script tag pointing to a javascript file that requires authentication. Now that we have
        // a token, this will succeed and we will have an authentication session in the webapp as well.
        function appendAuthenticatedScript() {
            var s = document.createElement("script");
            s.src = "authenticated.jsp";
            document.body.appendChild(s);
        }

        $(function() {
            var keycloak = new Keycloak('keycloak.json');
            keycloak.init({ onLoad: 'login-required' }).success(function(authenticated) {
                if (authenticated) {
                    console.log("User is logged in: " + keycloak.token);

                    appendAuthenticatedScript();
                } else {
                    console.log("User is not logged in");
                    $('#loading').hide();
                }
            }).error(function(error) {
                console.log("Error checking authentication due to: " + error);
            });
        });
    </script>
</head>

<body>
    <div id="loading" class="blank-slate-pf">
        <h1>
            Checking Authentication...
        </h1>
    </div>
</body>

</html>
