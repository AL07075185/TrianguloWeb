<%-- Barra de navegación compartida entre la calculadora y el administrador de archivos --%>
<nav class="navbar navbar-expand-md navbar-dark bg-primary">
    <div class="container">
        <span class="navbar-brand"><i class="bi bi-triangle-half"></i> TrianguloWeb</span>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menu"
                aria-controls="menu" aria-expanded="false" aria-label="Mostrar menú">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="menu">
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">
                    <i class="bi bi-calculator"></i> Calculadora
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/Admin.do">
                    <i class="bi bi-folder2-open"></i> Administrador de archivos
                </a>
            </div>
        </div>
    </div>
</nav>
