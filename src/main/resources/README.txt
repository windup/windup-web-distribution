 ____  _   _    _    __  __ _____
|  \/  ||__  __| / \
| |\/| |  | |   / _ \
| |  | |  | |  / ___ \
| |  | |__| |_/_/   \_\


Migration Toolkit for Applications (WINDUP) ${project.version} is an extensible and customizable rule-based tool that helps simplify migration of Java applications.

WINDUP examines application artifacts, including project source directories and applications archives,
then produces an HTML report highlighting areas that need changes.

WINDUP can be used to migrate Java applications from previous versions of Red Hat JBoss Enterprise Application Platform
or from other containers, such as Oracle WebLogic Server or IBM WebSphere Application Server.


How Does WINDUP Simplify Migration?
-------------------------------------
    WINDUP looks for common resources and highlights technologies and known “trouble spots” when migrating applications.
    The goal is to provide a high level view into the technologies used by the application and provide a detailed report organizations can use to estimate,
    document, and migrate enterprise applications to Java EE and JBoss EAP.


Run WINDUP
---------------
    Open a terminal and navigate to the WINDUP_HOME directory.

    Run WINDUP against the application using the appropriate command.

        For Linux:

        $ WINDUP_HOME/run_windup.sh

        For Windows:

        > WINDUP_HOME/run_windup.bat


Get more resources
---------------------
    User Guide is available at https://access.redhat.com/documentation/en/red-hat-jboss-migration-toolkit
    WINDUP Wiki - https://github.com/windup/windup/wiki
    WINDUP Forum for users - https://community.jboss.org/en/windup
    WINDUP JIRA issue trackers
        WINDUP core: https://issues.jboss.org/browse/WINDUP
        WINDUP Rules: https://issues.jboss.org/browse/WINDUPRULE
    WINDUP users mailing List: windup-users@lists.jboss.org
    WINDUP on Twitter: @JBossWindup (https://twitter.com/jbosswindup)
    WINDUP IRC channel: Server FreeNode (irc.freenode.net), channel #windup
