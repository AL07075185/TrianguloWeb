<%-- 
    Document   : resultado
 Descripcion   : Recibe la base y la altura enviadas desde index.jsp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="mx.webapp.geometria.Triangulo"%>
<%
    // 1. Recepcion de los datos enviados por el formulario (peticion POST)
    request.setCharacterEncoding("UTF-8");
    String b = request.getParameter("base");
    String h = request.getParameter("altura");

    // 2. Invocacion de la clase Triángulo para realizar los cálculos
    Triangulo triangulo = null;
    String mensajeError = null;
    double area = 0;
    double perimetro = 0;

    try {
        triangulo = new Triangulo(b, h);
        area = triangulo.calcularArea();
        perimetro = triangulo.calcularPerimetro();
    } catch (IllegalArgumentException ex) {
        mensajeError = ex.getMessage();
    }
%>
    
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Resultado del triángulo equilatero</title>
        <%@include file="/WEB-INF/includes/Bootstrap.jsp"%>
    </head>
    <body class="bg-light">
        <%@include file="/WEB-INF/includes/Navbar.jsp"%>

        <main class="card shadow-sm mx-auto my-5 p-4" style="max-width: 30rem;">
            <h1 class="h3 text-primary">Resultado</h1>

            <% if (mensajeError != null) { %>
                <%-- 3a. Si los datos no son válidos se muestra el error --%>
                <p class="alert alert-danger"><%= mensajeError %></p>
            <% } else { %>
                <%-- 3b. Se muestran los datos capturados y los resultados --%>
                <table class="table">
                    <tr>
                        <th>Base (b)</th>
                        <td><%= String.format("%.2f", triangulo.getBase()) %></td>
                    </tr>
                    <tr>
                        <th>Altura (h)</th>
                        <td><%= String.format("%.2f", triangulo.getAltura()) %></td>
                    </tr>
                    <tr class="table-primary">
                        <th>Área A = (b &times; h) / 2</th>
                        <td><%= String.format("%.2f", area) %></td>
                    </tr>
                    <tr class="table-primary">
                        <th>Perímetro P = 3 &times; b</th>
                        <td><%= String.format("%.2f", perimetro) %></td>
                    </tr>
                </table>
            <% } %>
            
            <a class="btn btn-outline-primary w-100" href="index.jsp">
                <i class="bi bi-arrow-counterclockwise"></i> Realizar otro cálculo </a>
        </main>

        <%@include file="/WEB-INF/includes/BootstrapJS.jsp"%>
    </body>
</html>
