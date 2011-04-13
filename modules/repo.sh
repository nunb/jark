
DOC="Module for working with cljr build system"

commands() {
    echo -e "list add remove"
}

_doc() {
    echo -e "jark repo list"
    echo -e "\tList current repositories."
    echo -e ""
    echo -e "jark repo add URL"
    echo -e "\tAdd repository."
    echo -e ""
    echo -e "jark repo remove URL"
    echo -e "\tRemove repository"
}

list() {
    $JARK_CLIENT cljr.main cljr-list-repos
    exit 0
}

add() {
    $JARK_CLIENT cljr.main cljr-add-repo $*
    exit 0
}

remove() {
    $JARK_CLIENT cljr.main cljr-remove-repo $*
    exit 0
}
