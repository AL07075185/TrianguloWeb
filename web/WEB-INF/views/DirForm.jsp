<%--
    Document   : DirForm
 Descripcion   : Formulario para capturar el directorio que se desea explorar
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/includes/TagLibs.jsp"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Administrador de archivos</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%@include file="/WEB-INF/includes/Bootstrap.jsp"%>
    </head>
    <body class="bg-light">
        <%@include file="/WEB-INF/includes/Navbar.jsp"%>

        <main class="card shadow-sm mx-auto my-5 p-4" style="max-width: 40rem;">
            <h1 class="h3 text-primary"><i class="bi bi-folder2-open"></i> Administrador de archivos</h1>
            <p class="text-body-secondary">Captura la ruta de una carpeta del equipo local</p>

            <c:forEach var="error" items="${errores}">
                <p class="alert alert-danger"><c:out value="${error}"/></p>
            </c:forEach>

            <form action="Lista.do" method="post">
                <label for="path" class="form-label">Directorio</label>
                <div class="input-group">
                    <input type="text" class="form-control" id="path" name="path"
                           value="<c:out value='${param.path}'/>"
                           placeholder="Ejemplo: C:\Users\usuario\Documents" required>
                    <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Listar</button>
                </div>
            </form>
        </main>

        <%@include file="/WEB-INF/includes/BootstrapJS.jsp"%>
    </body>
</html>
