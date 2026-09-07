#!/bin/bash

crearEntorno() {
    mkdir -p "$HOME/EPNro1/entrada"
    mkdir -p "$HOME/EPNro1/salida"
    mkdir -p "$HOME/EPNro1/procesado"

    echo "Entorno creado"
}

correrProceso() {
    if [ -f "$HOME/EPNro1/consolidar.pid" ]; then
        PID=$(cat "$HOME/EPNro1/consolidar.pid")

        if kill -0 "$PID" 2>/dev/null; then
            echo "El proceso ya se está ejecutando"
            return
        fi
    fi

    "$HOME/EPNro1/consolidar.sh" &
    PID=$!
    echo "$PID" > "$HOME/EPNro1/consolidar.pid"
    echo "Proceso iniciado"
}

listarAlumnos() {
    if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
        sort -n "$HOME/EPNro1/salida/$FILENAME.txt"
    else
        echo "No existe el archivo $FILENAME.txt"
    fi
}

mostrarTop10() {
    if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
        sort -k4 -nr "$HOME/EPNro1/salida/$FILENAME.txt" | head -10
    else
        echo "No existe el archivo $FILENAME.txt"
    fi
}

mostrarSegunPadron() {
    read -p "Ingrese el nro de padrón: " padron

    if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ] &&
       grep -q "^$padron " "$HOME/EPNro1/salida/$FILENAME.txt"
    then
        grep "^$padron " "$HOME/EPNro1/salida/$FILENAME.txt"
    else
        echo "No se pudo encontrar un alumno con ese padrón"
    fi
}

imprimirLog() {
    if [ -f "$HOME/EPNro1/procesado.log" ]; then
        cat "$HOME/EPNro1/procesado.log"
    else
        echo "No se encontro un log"
    fi
}

borrarEntorno() {
    if [ -f "$HOME/EPNro1/consolidar.pid" ]; then
        PID=$(cat "$HOME/EPNro1/consolidar.pid")

        if kill -0 "$PID" 2>/dev/null; then
            kill "$PID"
            echo "Proceso detenido"
        fi
    fi

    rm -rf "$HOME/EPNro1"

    echo "Entorno eliminado"
}

if [ "$1" = "-d" ]; then
    borrarEntorno
    exit 0
fi

PID=""
continuar=true

while $continuar; do
    echo "Opciones"
    echo "1. Crear entorno"
    echo "2. Correr proceso"
    echo "3. Listar alumnos"
    echo "4. Mostrar 10 notas más altas"
    echo "5. Buscar alumno"
    echo "6. Visualizar log"
    echo "7. Salir"

    read -p "Elija una opción: " opcion

    case $opcion in
        1)
            crearEntorno
            ;;
        2)
            correrProceso
            ;;
        3)
            listarAlumnos
            ;;
        4)
            mostrarTop10
            ;;
        5)
            mostrarSegunPadron
            ;;
        6)
            imprimirLog
            ;;
        7)
            continuar=false
            echo "Saliendo..."
            ;;
        *)
            echo "Opción inválida"
            ;;
    esac
done