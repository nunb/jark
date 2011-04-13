
DOC="Module to manage jark itself"

commands() {
    echo -e "install uninstall version"
}

_doc() {
    echo -e "jark self install"
    echo -e "\tInstall jark."
    echo -e ""
    echo -e "jark self uninstall"
    echo -e "\tUninstall jark."
    echo -e ""
    echo -e "jark self version"
    echo -e "\tReturn Jark version."
}

install() {
    $JARK install
    exit 0
}

version() {
    $JARK version
    exit 0
}

uninstall() {
    echo "uninstalling ..."
    $JARK vm stop
    rm -rf ${CLJR_CP}/jark*.jar
    rm -rf ${CLJR_CP}/jark.jar
    rm -rf ${CLJR_CP}/jark
    exit 0
}
