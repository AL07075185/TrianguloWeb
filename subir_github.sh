#!/usr/bin/env bash
# ==========================================================================
#  subir_github.sh
#  Sube la carpeta del proyecto TrianguloWeb (NetBeans) a un repositorio
#  de GitHub desde Linux, usando SIEMPRE SSH (git@github.com:...).
#  Nunca usa HTTPS ni pide tokens.
#
#  Requisito: tener tu llave SSH registrada en GitHub. Compruebalo con:
#    ssh -T git@github.com
#
#  Uso:
#    chmod +x subir_github.sh
#    ./subir_github.sh [carpeta_del_proyecto]
#
#  Opciones (todas opcionales):
#    -u USUARIO     Usuario de GitHub (por defecto: se detecta por SSH)
#    -r REPO        Nombre del repositorio (por defecto: nombre de la carpeta)
#    -p             Repositorio privado (por defecto: publico)
#    -H HOST        Host SSH (por defecto: github.com; usa tu alias de
#                   ~/.ssh/config si tienes varias cuentas)
#    -R URL         URL remota completa (por ejemplo git@github.com:u/r.git)
#
#  Ejemplos:
#    ./subir_github.sh ~/Descargas/TrianguloWeb
#    ./subir_github.sh -r TrianguloWeb ~/TrianguloWeb
# ==========================================================================
set -euo pipefail

# ---------- colores para mensajes ----------
VERDE='\033[0;32m'; AMARILLO='\033[1;33m'; ROJO='\033[0;31m'; AZUL='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${AZUL}==>${NC} $*"; }
ok()    { echo -e "${VERDE}[OK]${NC} $*"; }
aviso() { echo -e "${AMARILLO}[AVISO]${NC} $*"; }
error() { echo -e "${ROJO}[ERROR]${NC} $*" >&2; exit 1; }

# ---------- parametros ----------
GH_USER=""; REPO_NAME=""; VISIBILIDAD="public"; REMOTE_URL=""; SSH_HOST="github.com"
while getopts ":u:r:pH:R:h" opt; do
  case "$opt" in
    u) GH_USER="$OPTARG" ;;
    r) REPO_NAME="$OPTARG" ;;
    p) VISIBILIDAD="private" ;;
    H) SSH_HOST="$OPTARG" ;;
    R) REMOTE_URL="$OPTARG" ;;
    h) sed -n '2,26p' "$0"; exit 0 ;;
    *) error "Opcion no valida. Usa -h para ver la ayuda." ;;
  esac
done
shift $((OPTIND - 1))

PROYECTO="${1:-$(pwd)}"
[ -d "$PROYECTO" ] || error "No existe la carpeta: $PROYECTO"
PROYECTO="$(cd "$PROYECTO" && pwd)"
cd "$PROYECTO"

# ---------- 1. Verificaciones ----------
info "Carpeta del proyecto: $PROYECTO"
command -v git >/dev/null 2>&1 || error "Git no esta instalado. Instalalo con: sudo apt install git  (o sudo dnf install git)"

if [ ! -f pom.xml ] && [ ! -d nbproject ] && [ ! -d web ] && [ ! -d src ]; then
  aviso "La carpeta no parece un proyecto de NetBeans (no hay pom.xml, nbproject, web ni src)."
  read -rp "¿Continuar de todos modos? (s/N): " r; [[ "$r" =~ ^[sS]$ ]] || exit 1
fi

[ -n "$REPO_NAME" ] || REPO_NAME="$(basename "$PROYECTO")"

# ---------- 2. Identidad de Git ----------
if [ -z "$(git config --global user.name || true)" ]; then
  read -rp "Tu nombre para los commits: " NOMBRE
  git config --global user.name "$NOMBRE"
fi
if [ -z "$(git config --global user.email || true)" ]; then
  read -rp "Tu correo de GitHub: " CORREO
  git config --global user.email "$CORREO"
fi
ok "Git configurado como: $(git config --global user.name) <$(git config --global user.email)>"

# ---------- 3. Limpieza de archivos que no deben subirse ----------
info "Limpiando archivos temporales de Windows y de compilacion..."
# Archivos que Windows agrega al copiar o descargar
find . -type f \( -name '*:Zone.Identifier' -o -name 'Zone.Identifier' -o -iname 'Thumbs.db' -o -iname 'desktop.ini' \) -print -delete 2>/dev/null || true
# Carpetas de compilacion (NetBeans las vuelve a generar con Clean and Build)
for d in build dist target nbproject/private; do
  [ -d "$d" ] && { rm -rf "$d"; echo "  eliminado: $d"; }
done
ok "Limpieza terminada."

# ---------- 4. .gitignore y .gitattributes ----------
if [ ! -f .gitignore ]; then
  cat > .gitignore <<'EOF'
# Compilacion (Ant y Maven)
build/
dist/
target/
*.class
*.war
*.jar
# Configuracion local de NetBeans
nbproject/private/
nb-configuration.xml
nbactions.xml
# Archivos del sistema
Thumbs.db
desktop.ini
*:Zone.Identifier
.DS_Store
EOF
  ok "Creado .gitignore"
fi

if [ ! -f .gitattributes ]; then
  # Normaliza los saltos de linea de Windows (CRLF) a formato estandar
  printf '* text=auto\n*.sh text eol=lf\n*.png binary\n*.jpg binary\n*.jar binary\n' > .gitattributes
  ok "Creado .gitattributes (normaliza saltos de linea de Windows)"
fi

# ---------- 5. README si no existe ----------
if [ ! -f README.md ]; then
  cat > README.md <<EOF
# ${REPO_NAME}

Aplicación web desarrollada con JavaServer Pages (JSP) y una clase Java que calcula el área y el perímetro de un triángulo equilátero.

Actividad 1 del curso Computación avanzada en Java, Universidad Tecmilenio.

| Cálculo | Fórmula |
| --- | --- |
| Área | A = (b × h) / 2 |
| Perímetro | P = 3 × b |

| Componente | Versión |
| --- | --- |
| JDK | 21 |
| IDE | Apache NetBeans |
| Servidor | GlassFish 8.0 (dominio domain1, localhost) |

Ejecución: abrir el proyecto en NetBeans y presionar Run. La aplicación queda disponible en http://localhost:8080/${REPO_NAME}/
EOF
  ok "Creado README.md"
fi

# ---------- 6. Repositorio local ----------
if [ ! -d .git ]; then
  git init -q
  ok "Repositorio Git inicializado."
else
  aviso "La carpeta ya tenia un repositorio Git; se reutiliza."
fi
git checkout -q -B main

git add -A
if git diff --cached --quiet; then
  aviso "No hay cambios nuevos para confirmar."
else
  git commit -q -m "Actividad 1: aplicacion web JSP triangulo equilatero"
  ok "Commit creado."
fi

echo
info "Archivos que se subiran:"
git ls-files | sed 's/^/  /'
echo

# ---------- 7. Conexion SSH con GitHub ----------
if [ -n "$REMOTE_URL" ]; then
  # Si alguien pasa una URL https, se convierte a SSH automaticamente
  if [[ "$REMOTE_URL" =~ ^https?://[^/]+/([^/]+)/([^/]+)$ ]]; then
    REMOTE_URL="git@${SSH_HOST}:${BASH_REMATCH[1]}/${BASH_REMATCH[2]%.git}.git"
    aviso "Se convirtio la URL https a SSH: $REMOTE_URL"
  fi
else
  info "Verificando la autenticacion SSH con $SSH_HOST ..."
  SALIDA_SSH="$(ssh -T -o BatchMode=yes -o ConnectTimeout=15 -o StrictHostKeyChecking=accept-new "git@${SSH_HOST}" 2>&1 || true)"
  if [[ "$SALIDA_SSH" =~ Hi\ ([A-Za-z0-9-]+)! ]]; then
    USUARIO_SSH="${BASH_REMATCH[1]}"
    ok "SSH autenticado como: $USUARIO_SSH"
    [ -n "$GH_USER" ] || GH_USER="$USUARIO_SSH"
  else
    echo "$SALIDA_SSH" >&2
    error "No se pudo autenticar por SSH con GitHub. Revisa que tu llave este cargada (ssh-add -l) y registrada en https://github.com/settings/keys"
  fi
  REMOTE_URL="git@${SSH_HOST}:${GH_USER}/${REPO_NAME}.git"
fi

# Liga web del repositorio (para pegarla en el documento)
if [[ "$REMOTE_URL" =~ ^git@[^:]+:([^/]+)/(.+)\.git$ ]]; then
  URL_WEB="https://github.com/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
  GH_USER="${BASH_REMATCH[1]}"; REPO_NAME="${BASH_REMATCH[2]}"
else
  URL_WEB="$REMOTE_URL"
fi

# ---------- 8. Crear el repositorio en GitHub ----------
if [[ "$REMOTE_URL" == git@* ]]; then
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if gh repo view "${GH_USER}/${REPO_NAME}" >/dev/null 2>&1; then
      ok "El repositorio ${GH_USER}/${REPO_NAME} ya existe en GitHub."
    else
      info "Creando el repositorio ${GH_USER}/${REPO_NAME} ($VISIBILIDAD) con GitHub CLI..."
      # Solo crea el repositorio; la subida se hace despues por SSH
      gh repo create "${GH_USER}/${REPO_NAME}" --"$VISIBILIDAD" \
        --description "Actividad 1: Aplicacion web con JSP (Computacion avanzada en Java, Tecmilenio)"
    fi
  else
    echo
    aviso "Crea el repositorio vacio en GitHub antes de continuar:"
    echo "   1. Abre https://github.com/new"
    echo "   2. Repository name: ${REPO_NAME}"
    echo "   3. Visibilidad: $([ "$VISIBILIDAD" = public ] && echo Public || echo Private)"
    echo "   4. NO marques 'Add a README', '.gitignore' ni 'license'"
    echo "   5. Clic en 'Create repository'"
    echo
    read -rp "Presiona Enter cuando el repositorio ya este creado..."
  fi
fi

# ---------- 9. Configurar el remoto SSH y subir ----------
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi
# Elimina cualquier pushurl previo (por ejemplo, uno https de una copia anterior)
git config --unset-all remote.origin.pushurl 2>/dev/null || true

URL_PUSH="$(git remote get-url --push origin)"
if [[ "$URL_PUSH" == https://* ]]; then error "El remoto sigue apuntando a HTTPS ($URL_PUSH). Revisa reglas 'insteadOf' en ~/.gitconfig."; fi
ok "Remoto origin (SSH): $URL_PUSH"

info "Subiendo por SSH..."
if ! git push -u origin main; then
  error "No se pudo subir. Verifica que el repositorio ${GH_USER}/${REPO_NAME} exista en GitHub y que tu llave SSH tenga acceso."
fi

echo
ok "Proyecto publicado correctamente por SSH."
echo -e "   Liga del repositorio: ${VERDE}${URL_WEB}${NC}"
echo "   Copia esta liga en la seccion 'Repositorio en GitHub' de tu documento."
