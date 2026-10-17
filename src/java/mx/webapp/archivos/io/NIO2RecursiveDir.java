package mx.webapp.archivos.io;

import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.List;

/**
 * Busca de forma recursiva los archivos contenidos en un directorio.
 */
public final class NIO2RecursiveDir {

    /** Límite de archivos para no saturar el navegador con carpetas muy grandes. */
    public static final int LIMITE = 500;

    private NIO2RecursiveDir() {
    }

    public static List<Path> walkDir(Path directorio) throws IOException {
        List<Path> archivos = new ArrayList<>();

        Files.walkFileTree(directorio, new SimpleFileVisitor<Path>() {
            @Override
            public FileVisitResult visitFile(Path archivo, BasicFileAttributes atributos) {
                archivos.add(archivo);
                return archivos.size() < LIMITE ? FileVisitResult.CONTINUE : FileVisitResult.TERMINATE;
            }

            @Override
            public FileVisitResult visitFileFailed(Path archivo, IOException ex) {
                return FileVisitResult.CONTINUE;
            }
        });

        archivos.sort(null);
        return archivos;
    }
}
