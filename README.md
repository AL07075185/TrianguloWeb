# TrianguloWeb

Aplicación web Java desarrollada con **JSP, Servlets y JSTL** e integrada con **Twitter Bootstrap 5**. Reúne en una sola webapp las actividades 1 y 2 del curso *Computación Avanzada en Java* de la Universidad Tecmilenio:

1. **Calculadora de triángulo equilátero** (Actividad 1): calcula el área y el perímetro a partir de la base y la altura con una clase Java y una página JSP.
2. **Administrador de archivos** (Actividad 2): explora un directorio del equipo local, lista sus archivos y subcarpetas con su ruta y tamaño, y permite descargarlos desde el navegador.

Las dos partes comparten la interfaz de Bootstrap: barra de navegación adaptable, tarjetas, formularios, tablas, alertas e íconos.

## Tecnologías

| Componente | Versión |
|---|---|
| Java Development Kit | JDK 21 o superior |
| IDE | Apache NetBeans 31 (proyecto Java Web con Ant) |
| Servidor de aplicaciones | GlassFish 8.0.0 (Jakarta EE 11), dominio `domain1` en localhost |
| Servlets / JSP / JSTL | Jakarta Servlet 6.1, Jakarta Pages, Jakarta Standard Tag Library 3.0 |
| Framework de interfaz | Twitter Bootstrap 5.3.8 y Bootstrap Icons 1.13.2 (archivos locales) |

## Estructura del proyecto

```
TrianguloWeb/
├── src/java/mx/webapp/
│   ├── geometria/Triangulo.java          Lógica del triángulo (área y perímetro)
│   └── archivos/
│       ├── AdminArchivos.java            Servlet /Admin.do
│       ├── ListaArchivos.java            Servlet /Lista.do
│       ├── DescargaArchivo.java          Servlet /Descarga.do
│       └── io/NIO2RecursiveDir.java      Búsqueda recursiva con java.nio.file
├── web/
│   ├── index.jsp                         Formulario de la calculadora
│   ├── resultado.jsp                     Resultado del cálculo
│   ├── bootstrap/                        CSS, JS e íconos de Bootstrap
│   └── WEB-INF/
│       ├── includes/                     Bootstrap.jsp, BootstrapJS.jsp, TagLibs.jsp, Navbar.jsp
│       ├── views/                        DirForm.jsp, DirView.jsp
│       ├── web.xml                       Página de inicio
│       └── glassfish-web.xml             Ruta de contexto /TrianguloWeb
└── dist/TrianguloWeb.war                 Aplicación empaquetada lista para desplegar
```

## Direcciones de la aplicación

| URL (`http://localhost:8080/TrianguloWeb`) | Componente | Función |
|---|---|---|
| `/` o `/index.jsp` | index.jsp | Formulario de base y altura |
| `/resultado.jsp` | resultado.jsp + Triangulo | Muestra el área y el perímetro o el error de validación |
| `/Admin.do` | Servlet AdminArchivos | Formulario para capturar el directorio |
| `/Lista.do` | Servlet ListaArchivos | Valida la ruta y muestra la tabla de archivos |
| `/Descarga.do` | Servlet DescargaArchivo | Descarga el archivo seleccionado |

Las vistas `DirForm.jsp` y `DirView.jsp` están dentro de `WEB-INF`, por lo que solo se accede a ellas a través de los servlets (patrón Modelo-Vista-Controlador).

## Ejecución

**Desde NetBeans**

1. Abrir el proyecto en NetBeans y asignar GlassFish 8 como servidor (Propiedades del proyecto > Run).
2. Ejecutar **Clean and Build** y después **Run**.
3. Abrir `http://localhost:8080/TrianguloWeb/`.

**Desplegando el WAR**

```bash
asadmin start-domain domain1
asadmin deploy dist/TrianguloWeb.war
```

## Uso

- **Calculadora:** capturar la base y la altura y presionar *Calcular*. Ejemplo: base 6 y altura 5.2 dan un área de 15.60 y un perímetro de 18.00. Los valores vacíos, negativos o iguales a cero muestran una alerta.
- **Administrador de archivos:** entrar a *Administrador de archivos* en la barra de navegación, escribir la ruta de una carpeta (por ejemplo `/home/usuario/Documentos` o `C:\Users\usuario\Documents`) y presionar *Listar*. La tabla muestra cada archivo con su nombre, ruta y tamaño, y el botón verde lo descarga.

## Integración de Twitter Bootstrap

- Los archivos de Bootstrap se incluyen dentro del proyecto en `web/bootstrap`, por lo que la aplicación funciona sin conexión a Internet.
- `WEB-INF/includes/Bootstrap.jsp` carga las hojas de estilo en el `<head>` y `BootstrapJS.jsp` carga el JavaScript al final del `<body>`. Cada vista los incorpora con `<%@include file="..."%>`.
- Bootstrap 5 ya no requiere jQuery; el archivo `bootstrap.bundle.min.js` incluye Popper.

## Notas

- El administrador de archivos solo lee y descarga; no modifica ni elimina archivos. Para no saturar el navegador, lista como máximo 500 archivos por consulta.
- La aplicación da acceso al sistema de archivos del equipo donde corre el servidor, por lo que está pensada para uso académico en localhost.

---
Computación Avanzada en Java · Universidad Tecmilenio · Actividades 1 y 2
