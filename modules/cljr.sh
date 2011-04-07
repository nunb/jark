DOC="Manage the cljr repository"

commands() {
    echo -e "reload add"
}

_doc() {
    echo -e "jark cljr reload"
    echo -e "\tReload cljr." 
    echo -e "" 
    echo -e "jark cljr add"
    echo -e "\tAdd all jars in the cljr classpath to the current Jark server."
}

add() {
    for JAR in `find ${CLJR_CP} -name "*.jar" -print`
    do
        echo "Adding $JAR .."
        $JARK_CLIENT ng-cp $JAR
    done
    exit 0
}

reload() {
    $JARK_CLIENT cljr.App reload
}

