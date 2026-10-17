package mx.webapp.archivos;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet de entrada al administrador de archivos: muestra el formulario DirForm.jsp.
 */
@WebServlet(name = "AdminArchivos", urlPatterns = {"/Admin.do"})
public class AdminArchivos extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesar(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesar(request, response);
    }

    private void procesar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Object errores = request.getAttribute("errores");
        request.setAttribute("errores", errores);
        request.getRequestDispatcher("/WEB-INF/views/DirForm.jsp").forward(request, response);
    }
}
