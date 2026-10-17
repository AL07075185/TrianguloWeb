<%--
    Document   : DirView
 Descripcion   : Muestra los archivos del directorio capturado con su ruta, tamaño y descarga
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/includes/TagLibs.jsp"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Contenido del directorio</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%@include file="/WEB-INF/includes/Bootstrap.jsp"%>
    </head>
    <body class="bg-light">
        <%@include file="/WEB-INF/includes/Navbar.jsp"%>

        <main class="card shadow-sm mx-auto my-5 p-4" style="max-width: 60rem;">
            <h1 class="h3 text-primary"><i class="bi bi-folder2-open"></i> Contenido del directorio</h1>
            <p class="text-body-secondary text-break"><c:out value="${directorio}"/></p>

            <c:if test="${fn:length(paths) lt 1}">
                <p class="alert alert-info">El directorio no contiene archivos.</p>
            </c:if>

            <c:if test="${fn:length(paths) ge 1}">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                        <thead class="table-primary">
                            <tr>
                                <th>Nombre</th>
                                <th class="d-none d-md-table-cell">Ruta</th>
                                <th class="text-end">Tamaño</th>
                                <th class="text-center">Descargar</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${paths}">
                                <c:url var="urlDescarga" value="/Descarga.do">
                                    <c:param name="archivo" value="${p.toString()}"/>
                                </c:url>
                                <tr>
                                    <td class="text-nowrap"><i class="bi bi-file-earmark"></i> <c:out value="${p.getFileName()}"/></td>
                                    <td class="small text-break d-none d-md-table-cell"><c:out value="${p.getParent()}"/></td>
                                    <td class="text-end text-nowrap"><fmt:formatNumber value="${p.toFile().length()}"/> bytes</td>
                                    <td class="text-center">
                                        <a class="btn btn-sm btn-outline-success" href="${urlDescarga}">
                                            <i class="bi bi-download"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <a class="btn btn-outline-primary w-100" href="Admin.do">
                <i class="bi bi-arrow-left"></i> Explorar otro directorio
            </a>
        </main>

        <%@include file="/WEB-INF/includes/BootstrapJS.jsp"%>
    </body>
</html>
