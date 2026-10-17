package mx.webapp.archivos;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import mx.webapp.archivos.io.NIO2RecursiveDir;

/**
 * Servlet que valida el directorio capturado y envía su contenido a DirView.jsp.
 */
@WebServlet(name = "ListaArchivos", urlPatterns = {"/Lista.do"})
public class ListaArchivos extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        List<String> errores = new ArrayList<>();
        List<Path> paths = new ArrayList<>();
        String parametro = request.getParameter("path");
        Path directorio = null;

        if (parametro == null || parametro.trim().isEmpty()) {
            errores.add("El campo directorio es obligatorio.");
        } else {
            try {
                directorio = Paths.get(parametro.trim()).toAbsolutePath();
                if (Files.isDirectory(directorio)) {
                    paths = NIO2RecursiveDir.walkDir(directorio);
                } else {
                    errores.add("El directorio \"" + parametro + "\" no existe o no es una carpeta.");
                }
            } catch (InvalidPathException | IOException ex) {
                errores.add("No fue posible leer el directorio \"" + parametro + "\".");
            }
        }

        if (!errores.isEmpty()) {
            request.setAttribute("errores", errores);
            request.getRequestDispatcher("/Admin.do").forward(request, response);
            return;
        }

        request.setAttribute("directorio", directorio.toString());
        request.setAttribute("paths", paths);
        request.getRequestDispatcher("/WEB-INF/views/DirView.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Admin.do");
    }
}
