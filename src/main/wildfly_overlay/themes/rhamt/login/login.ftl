<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>
    <#if section = "title">
    ${msg("loginTitle",(realm.displayName!''))}
    <#elseif section = "header">
    ${msg("loginTitleHtml",(realm.displayNameHtml!''))}
    <#elseif section = "logo">
        <span id="rhamt-title">
            <strong class="visible-xs-inline">RHAMT</strong>
            <strong class="hidden-xs">Red Hat Application Migration Toolkit</strong> Web Console
        </span>
    <#elseif section = "form">
        <#if realm.password>
        <form id="kc-form-login" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="username" class="${properties.kcLabelClass!}"><#if !realm.loginWithEmailAllowed??>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                </div>

                <div class="${properties.kcInputWrapperClass!}">
                    <#if usernameEditDisabled??>
                        <input id="username" class="${properties.kcInputClass!}" name="username" value="${(login.username!'')}" type="text" disabled />
                    <#else>
                        <input id="username" class="${properties.kcInputClass!}" name="username" value="${(login.username!'')}" type="text" autofocus autocomplete="off" />
                    </#if>
                </div>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label>
                </div>

                <div class="${properties.kcInputWrapperClass!}">
                    <input id="password" class="${properties.kcInputClass!}" name="password" type="password" autocomplete="off" />
                </div>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                    <#if realm.rememberMe && !usernameEditDisabled??>
                        <div class="checkbox">
                            <label>
                                <#if login.rememberMe??>
                                    <input id="rememberMe" name="rememberMe" type="checkbox" tabindex="3" checked> ${msg("rememberMe")}
                                <#else>
                                    <input id="rememberMe" name="rememberMe" type="checkbox" tabindex="3"> ${msg("rememberMe")}
                                </#if>
                            </label>
                        </div>
                    </#if>
                    <div class="${properties.kcFormOptionsWrapperClass!}">
                        <#if realm.resetPasswordAllowed>
                            <span><a href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a></span>
                        </#if>
                    </div>
                </div>

                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <div class="${properties.kcFormButtonsWrapperClass!}">
                        <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}" name="login" id="kc-login" type="submit" value="${msg("doLogIn")}"/>
                    </div>
                </div>
            </div>
        </form>
        </#if>
    <#elseif section = "info">
        <p>
            <strong class="welcome-help-text"> Welcome to the Red Hat Application Migration Toolkit Web Console. </strong>
        </p>
        <p>
            Learn more about Red Hat Application Migration Toolkit from the
            <a href="https://access.redhat.com/documentation/en/red-hat-jboss-migration-toolkit/">documentation</a>.
        </p>

        <#if realm.password && realm.registrationAllowed && !usernameEditDisabled??>
        <div id="kc-registration">
            <span>${msg("noAccount")} <a href="${url.registrationUrl}">${msg("doRegister")}</a></span>
        </div>
        </#if>

        <#if realm.password && social.providers??>
        <div id="kc-social-providers">
            <ul>
                <#list social.providers as p>
                    <li><a href="${p.loginUrl}" id="zocial-${p.alias}" class="zocial ${p.providerId}"> <span class="text">${p.displayName}</span></a></li>
                </#list>
            </ul>
        </div>
        </#if>
    </#if>
</@layout.registrationLayout>
