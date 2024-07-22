#!/bin/bash

# Controlla se l'utente ha fornito il comando (enable/disable/install/uninstall) e il file di input
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <enable|disable|install|uninstall> <file_di_lista_app>"
    exit 1
fi

# Estrai i parametri
COMMAND=$1
APP_LIST_FILE=$2

# Verifica se il file di lista delle app esiste
if [ ! -f "$APP_LIST_FILE" ]; then
    echo "Il file $APP_LIST_FILE non esiste."
    exit 1
fi

# Verifica se il comando è valido
if [ "$COMMAND" != "enable" ] && [ "$COMMAND" != "disable" ] && [ "$COMMAND" != "install" ] && [ "$COMMAND" != "uninstall" ]; then
    echo "Comando non valido. Usa 'enable', 'disable', 'install' o 'uninstall'."
    exit 1
fi

# Comandi pm corrispondenti
if [ "$COMMAND" == "enable" ]; then
    PM_COMMAND="pm enable"
elif [ "$COMMAND" == "disable" ]; then
    PM_COMMAND="pm disable-user"
elif [ "$COMMAND" == "install" ]; then
    PM_COMMAND="pm install"
else
    PM_COMMAND="pm uninstall --user 0"
fi

# Assicurarsi di essere root
if [ "$(id -u)" -ne 0 ]; then
    echo "Questo script deve essere eseguito con privilegi di root."
    exit 1
fi

# Legge il file di lista delle app e applica il comando pm per ogni pacchetto
while IFS= read -r APP_PATH; do
    if [ "$COMMAND" == "install" ]; then
        echo "Eseguendo: $PM_COMMAND $APP_PATH"
        $PM_COMMAND "$APP_PATH"
    else
        PACKAGE=$(basename "$APP_PATH" .apk)
        echo "Eseguendo: $PM_COMMAND $PACKAGE"
        $PM_COMMAND "$PACKAGE"
    fi
done < "$APP_LIST_FILE"

echo "Operazione completata."