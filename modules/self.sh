
DOC="Module to manage jark itself"

commands() {
    echo -e "install uninstall version"
}

commands() {
    echo -e "jark self install"
    echo -e "\tInstall jark."
    echo -e ""
    echo -e "jark self uninstall"
    echo -e "\tUninstall jark."
    echo -e ""
    echo -e "jark self version"
    echo -e "\tReturn Jark version."
}

version() {
    $JARK version
}

uninstall() {
    echo "uninstalling ..."
    $JARK vm stop
    rm -rf ${CLJR_CP}/jark*.jar
    rm -rf ${CLJR_CP}/jark.jar
    rm -rf ${CLJR_CP}/jark
}
