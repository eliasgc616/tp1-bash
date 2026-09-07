shopt -s nullglob

while true; do

    for archivo in "$HOME/EPNro1/entrada/"*.txt; do

        cat "$archivo" >> "$HOME/EPNro1/salida/$FILENAME.txt"
        mv "$archivo" "$HOME/EPNro1/procesado/"
        echo "$(date "+%d/%m/%Y %H:%M:%S") - Procesado archivo $(basename "$archivo")" >> "$HOME/EPNro1/procesado.log"

    done

    sleep 10
done