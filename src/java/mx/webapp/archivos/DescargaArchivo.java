package mx.webapp.archivos;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet que envía al navegador el archivo seleccionado en DirView.jsp.
 */
@WebServlet(name = "DescargaArchivo", urlPatterns = {"/Descarga.do"})
public class DescargaArchivo extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String parametro = request.getParameter("archivo");
        Path archivo = null;

        try {
            if (parametro != null) {
                archivo = Paths.get(parametro);
            }
        } catch (InvalidPathException ex) {
            archivo = null;
        }

        if (archivo == null || !Files.isRegularFile(archivo)) {
            List<String> errores = new ArrayList<>();
            errores.add("El archivo solicitado no existe.");
            request.setAttribute("errores", errores);
            request.getRequestDispatcher("/Admin.do").forward(request, response);
            return;
        }

        String nombre = archivo.getFileName().toString();
        String nombreUtf8 = URLEncoder.encode(nombre, StandardCharsets.UTF_8).replace("+", "%20");
        response.setContentType("application/octet-stream");
        response.setContentLengthLong(Files.size(archivo));
        response.setHeader("Content-Disposition", "attachment; filename=\""
                + nombre.replaceAll("[^\\x20-\\x7E]|\"", "_") + "\"; filename*=UTF-8''" + nombreUtf8);
        Files.copy(archivo, response.getOutputStream());
    }
}
