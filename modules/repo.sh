
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
    $JARK_CLIENT cljr.App list-repos
}

add() {
    $JARK_CLIENT cljr.App add-repo $*
}

remove() {
    $JARK_CLIENT cljr.App add-repo $*
}
