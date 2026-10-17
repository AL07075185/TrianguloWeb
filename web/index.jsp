<%--
    Document   : index
 Descripcion   : Formulario que solicita la base y la altura del triángulo equilátero
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Triángulo equilátero</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%@include file="/WEB-INF/includes/Bootstrap.jsp"%>
    </head>
    <body class="bg-light">
        <%@include file="/WEB-INF/includes/Navbar.jsp"%>

        <main class="card shadow-sm mx-auto my-5 p-4" style="max-width: 30rem;">
            <h1 class="h3 text-primary">Triángulo equilátero</h1>
            <p class="text-body-secondary">Cálculo de área y perímetro con JSP y una clase Java</p>

            <form action="resultado.jsp" method="post">
                <label for="base" class="form-label">Base (b)</label>
                <input type="number" class="form-control mb-3" id="base" name="base" step="any" min="0.01"
                       placeholder="Ejemplo: 6" required>

                <label for="altura" class="form-label">Altura (h)</label>
                <input type="number" class="form-control mb-3" id="altura" name="altura" step="any" min="0.01"
                       placeholder="Ejemplo: 5.2" required>

                <button type="submit" class="btn btn-primary w-100">
                                    <i class="bi bi-calculator"></i> Calcular
                                </button>
            </form>

            <p class="text-center text-body-secondary small mt-3 mb-0">A = (b &times; h) / 2 &nbsp;&nbsp;|&nbsp;&nbsp; P = 3 &times; b</p>
        </main>

        <%@include file="/WEB-INF/includes/BootstrapJS.jsp"%>
    </body>
</html>
