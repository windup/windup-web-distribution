window.onload = function() {
    document.getElementById('kc-form-login').style.visibility = 'hidden';
    var parent = document.getElementById('mta-title').parentNode;

    var infoElement = document.createElement("h1");
    infoElement.innerHTML = "Connecting...";
    parent.appendChild(infoElement);

    var usernameEl = document.getElementById("username");
    usernameEl.value = "tackle";
    var passwordEl = document.getElementById("password");
    passwordEl.value = "password";
    var loginButton = document.getElementById("kc-login");
    loginButton.click();
};

